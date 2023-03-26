# frozen_string_literal: true

class UserSubscriptionCalendarsController < BaseController
  before_action :validate_calendars_length, only: [:destroy]

  DEFAULT_CALENDAR_COLOR='#3788d8'
  DEFAULT_CALENDAR_NAME = 'Predeterminado'

  def index
    create_default_calendar(params[:user_subscription_id]) if list_items.empty?
    response_with_objects(list_items, count_items)
  end

  private

  def validate_calendars_length
    items = @item_class.search({ user_subscription_id: @item[:user_subscription_id] })
    return unless items.length < 2

    json_response({ message: I18n.t('user_subscription_calendars.errors.last_calendar') },
                  :forbidden)
  end

  def create_default_calendar(user_subscription_id)
    @item_class.create!({
      user_subscription_id: user_subscription_id,
      name: DEFAULT_CALENDAR_NAME,
      type: 'data',
      url: '',
      color: DEFAULT_CALENDAR_COLOR
    })
  end

  def default_search_param_keys
    super() + [:user_subscription_id]
  end

  def set_item_class
    @item_class = Objects.tolgeo_model_class(params['tolgeo'], 'user_subscription_calendar')
  end

  def item_params
    params.permit([:user_subscription_id, :name, :type, :url, :color, {
      events: [:id, :title, :start, :end, :allDay]
    }])
  end
end
