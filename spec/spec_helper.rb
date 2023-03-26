RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end


# tells if json response from server includes expected params
def validate_params(request_params, json_data, ignore_attributes)
  all_found = true
  request_params.each do |key, value|
    unless ignore_attributes.include?(key)
      if /.+_attributes$/.match?(key) && value.is_a?(Hash)
        all_found &= validate_nested_attribute(key, value, json_data, ignore_attributes)
      else
        all_found &= (json_data.key?(key) && json_data[key] == value)
        unless all_found
          puts "FAILED: Could not find expected data in response JSON: #{key} = #{value}"
        end
      end
      break unless all_found
    end
  end
  all_found
end

# tells if data rows from a nested attribute are included in json response
def validate_nested_attribute(attributes_name, rows, json_data, ignore_attributes)
  assoc_name = attributes_name.chomp("_attributes") 
  found = false
  rows.each do |id, row_data|
    found = found_in_json(row_data, json_data[assoc_name], ignore_attributes)
    break unless found
  end
  found
end

# tells if a data row is included in a json response
def found_in_json(row_data, json_data, ignore_attributes)
  found = false
  json_data.each do |json_row|
    row_data.each do |key, value|
      unless ignore_attributes.include?(key)
        if /.+_attributes$/.match?(key) && value.is_a?(Hash)
          found = validate_nested_attribute(key, value, json_row, ignore_attributes) 
        else
          found = (json_row.key?(key) && json_row[key] == value)
        end
        break unless found
      end
    end
    break if found
  end
  unless found
    puts "FAILED: Could not find expected data in response JSON"
    puts "Expected data: #{row_data.inspect}"
    puts "JSON: #{json_data.inspect}"
  end
  found
end

def stub_requests_to_api_foros
  endpoints = [nil, '/crea_usuario.php', '/modifica_usuario.php', '/borra_usuario.php', '/crea_grupo.php', '/modifica_grupo.php', '/borra_grupo.php', '/grupo_mueve_a_grupos.php']

  endpoints.each do |endpoint|
    stub_request(:any, "#{ENV['XT_API_BASE_FOROS']}#{endpoint}").with(query: hash_including({}))
  end
end

def create_or_return_subsytem_tol(id=0)
  subsys = Esp::Subsystem.where(:id => id).first || Esp::Subsystem.new(id: id, name: 'Subsystem')
  subsys.save

  subsys
end

def create_or_return_subsytem_latam(id=0)
  subsys = Latam::Subsystem.where(:id => id).first || Latam::Subsystem.new(id: id, name: 'Subsystem')
  subsys.save

  subsys
end

# Describes tests expecting standard CRUD behavior for a model.
#
# === Parameters
# * +klass+: Class of the model under test.
# * +options+: Hash with options for customizing the tests.
#
# === Options
# * <tt>:factory</tt> - (symbol) Factory used to generate test objects. Automatically inferred
#   from the class name if not provided.
# * <tt>:index</tt> - (boolean) +true+ for testing INDEX request, +false+ skips this test. Defaults
#   to +true+.
# * <tt>:show</tt> - (boolean) +true+ for testing SHOW request, +false+ skips this test. Defaults
#   to +true+.
# * <tt>:delete</tt> - (boolean) +true+ for testing DELETE request, +false+ skips this test. Defaults
#   to +true+.
# * <tt>:create_params</tt> - Hash with parameters for testing creation of a new object. Keys must be
#   strings. If not provided, CREATE request is not tested.
# * <tt>:update_params</tt> - Hash with parameters for testing update of a new object. Keys must be
#   strings. If not provided, UPDATE request is not tested. Only addition of new nested attributes is
#   tested, updating or deleting existing nested attributes is not tested.
# * <tt>:check_attributes</tt> - Array with attribute names whose values will be checked on each test. If
#   none are provided, only +id+ is checked.
# * <tt>:ignore_attributes</tt> - Array with attribute names that should be ignored for create and
#   update tests.
# * <tt>:unique_attributes</tt> - Array with attribute names whose values should be unique.
# * <tt>:delete_associations</tt> - Array with classes of associated objects that should be deleted when
#   the main object is deleted.
# * <tt>:ordering</tt> - (string) Name of attribute that determines ordering of records when listing. Only
#   needed when factory generates random +id+.
# * <tt>:records_count</tt> - (integer) Number of test records to be created. Defaults to 2. Minimum is 2.
def describe_crud(klass, options = {})
  # define default constants
  tolgeo_name = klass.name.deconstantize.downcase
  class_name = klass.name.demodulize
  factory_name = class_name.underscore
  route_name = factory_name.pluralize
  index_path = "/" + tolgeo_name + "/" + route_name

  # parse options
  factory_symbol = options[:factory] || factory_name.to_sym
  index = options.key?(:index) ? options[:index] : true
  show = options.key?(:show) ? options[:show] : true
  delete = options.key?(:delete) ? options[:delete] : true
  create_params = options[:create_params] || {}
  update_params = options[:update_params] || {}
  check_attributes = options[:check_attributes] || []
  ignore_attributes = options[:ignore_attributes] || []
  unique_attributes = options[:unique_attributes] || []
  delete_associations = options[:delete_associations] || []
  ordering = options[:ordering] || nil
  records_count = options[:records_count] || 2
  records_count = 2 if records_count < 2

  klass.destroy_all
  # create test data
  let!(:records) { create_list(factory_symbol, records_count) }
  let(:record) { 
    first = records.first
    if ordering
      records.each do |record|
       first = record if record[ordering] < first[ordering]
      end
    end
    first
  }
  let(:other_record) {
    records.second.equal?(record) ? records.first : records.second
  }

  # index -------------------------------------------------- 
  if index
    describe "index > GET #{index_path}" do
      it "returns #{class_name} list with status 200" do
        get index_path
        expect(response).to have_http_status(200)
        expect(json['total']).to eq(records_count)
        expect(json['objects'][0]['id']).to eq(record.id)
        check_attributes.each do |attribute|
          expect(json['objects'][0]).to have_key(attribute)
          expect(json['objects'][0][attribute]).to eq(record.send(attribute))
        end
      end
    end
  end

  # show -------------------------------------------------- 
  if show
    describe "show > GET #{index_path}/:id" do
      context "with valid #{class_name} id" do
        it "returns the #{class_name} with status 200" do
          get index_path + "/" + record.id.to_s
          expect(response).to have_http_status(200)
          expect(json['resource']).to eq(record.id)
          expect(json['object']['id']).to eq(record.id)
          check_attributes.each do |attribute|
            expect(json['object']).to have_key(attribute)
            expect(json['object'][attribute]).to eq(record[attribute])
          end
        end
      end

      context "with invalid #{class_name} id" do
        it 'returns not found message with status 404' do
          get index_path + "/invalid"
          expect(response).to have_http_status(404)
          expect(response.body).to match(/Couldn't find/)
        end
      end
    end
  end

  # create -------------------------------------------------- 
  unless create_params.empty?
    describe "create > POST #{index_path}" do
      context 'with valid request' do
        before(:example) do
          post index_path, params: create_params
        end
       
        it "creates the #{class_name}" do
          new_id = json['object']['id']
          expect(klass.count - records_count).to eq(1)
          expect{klass.find(new_id)}.not_to raise_error
        end

        it "returns the #{class_name} with status 201" do
          expect(response).to have_http_status(201)
          check_attributes.each do |attribute|
            expect(json['object']).to have_key(attribute)
            expect(json['object'][attribute]).to eq(create_params[attribute])
          end
          expect(validate_params(create_params, json['object'], ignore_attributes)).to be true
        end
      end

      unique_attributes.each do |attr|
        context "with duplicated #{attr} request" do
          let(:duplicated_params) {
            create_params.merge({
              attr => record[attr]
            })
          }

          before(:example) do
            post index_path, params: duplicated_params.merge({ locale: 'en' })
          end

          it "does not create any #{class_name}" do
            expect(klass.count - records_count).to eq(0)
          end

          it 'returns validation failure message with status 422' do
            expect(response).to have_http_status(422)
            expect(response.body).to match(/Validation failed:/)
          end
        end
      end

      context 'with invalid request' do
        before(:example) do
          post index_path, params: { locale: 'en' }
        end

        it "does not create any #{class_name}" do
          expect(klass.count - records_count).to eq(0)
        end

        it 'returns validation failure message with status 422' do
          expect(response).to have_http_status(422)
          expect(response.body).to match(/Validation failed:/)
        end
      end
    end
  end

  # update -------------------------------------------------- 
  unless update_params.empty?
    describe "update > PATCH #{index_path}/:id" do
      context "with valid request" do
        before(:example) do
          patch index_path + "/" + record.id.to_s, params: update_params
        end

        it "updates the #{class_name} record" do
          record.reload
          check_attributes.each do |attribute|
            expect(json['object']).to have_key(attribute)
            expect(json['object'][attribute]).to eq(update_params[attribute])
            expect(record[attribute]).to eq(update_params[attribute])
          end
          expect(validate_params(update_params, json['object'], ignore_attributes)).to be true
        end

        it 'returns ok status 200' do
          expect(response).to have_http_status(200)
        end
      end

      unique_attributes.each do |attr|
        context "with duplicated #{attr} request" do
          let(:original_attr) { record[attr] }

          before(:example) do
            duplicated_params = {
              attr => other_record[attr],
              locale: 'en'
            }
            patch index_path + "/" + record.id.to_s, params: duplicated_params
          end

          it 'does not update record' do
            expect(record.reload[attr]).to eq(original_attr)
          end

          it 'returns validation failure message with status 422' do
            expect(response).to have_http_status(422)
            expect(response.body).to match(/Validation failed:/)
          end
        end
      end
      
      context "with invalid #{class_name} id" do
        it 'returns not found status 404' do
          patch index_path + "/invalid", params: update_params
          expect(response).to have_http_status(404)
        end
      end
    end
  end

  # delete -------------------------------------------------- 
  if delete
    describe "delete > DELETE #{index_path}/:id" do
      context "with valid #{class_name}" do
        let!(:record_id) { record.id }
        let!(:record_associations_ids) {
          association_ids = {}
          delete_associations.each do |assoc|
            assoc_name = assoc.name.demodulize.underscore.pluralize
            association_ids[assoc] = record.send(assoc_name).pluck(:id)
          end
          association_ids
        }

        before(:example) do
          delete index_path + "/" + record_id.to_s
        end

        it "deletes the #{class_name}" do
          expect(klass.count - records_count).to eq(-1)
          expect{klass.find(record_id)}.to raise_error(ActiveRecord::RecordNotFound)
        end

        unless delete_associations.empty?
          it 'deletes associated records' do
            record_associations_ids.each do |assoc, ids|
              expect(ids).not_to be_empty
              ids.each do |id|
                expect{assoc.find(id)}.to raise_error(ActiveRecord::RecordNotFound)
              end
            end
          end
        end

        it 'returns no content status 204' do
          expect(response).to have_http_status(204)
        end
      end

      context "with invalid #{class_name} id" do
        before(:example) do
          delete index_path + "/invalid"
        end

        it "does not delete any #{class_name}" do
          expect(klass.count - records_count).to eq(0)
        end

        it 'returns not found status 404' do
          expect(response).to have_http_status(404)
        end
      end
    end
  end
end
