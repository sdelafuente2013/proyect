class AddSiteUrlPathToSubsystem < ActiveRecord::Migration[5.1]
  def change
    add_column :subsystem, :path, :string
    
    if Esp::Subsystem.count >= 7
      Esp::Subsystem.update(0, path: 'tol')
      Esp::Subsystem.update(1, path: 'tnr')
      Esp::Subsystem.update(2, path: 'tase')
      Esp::Subsystem.update(3, path: 'tph')
      Esp::Subsystem.update(4, path: 'analytics')
      Esp::Subsystem.update(5, path: 'icab')
      Esp::Subsystem.update(6, path: 'cyl')
    end
  end
end
