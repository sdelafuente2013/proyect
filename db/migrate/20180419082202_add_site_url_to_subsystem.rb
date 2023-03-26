class AddSiteUrlToSubsystem < ActiveRecord::Migration[5.1]
  def change
    add_column :subsystem, :url, :string
    
    if Esp::Subsystem.count >= 7
      Esp::Subsystem.update(0, url: 'http://www.tirantonline.com')
      Esp::Subsystem.update(1, url: 'http://notariado.tirant.com')
      Esp::Subsystem.update(2, url: 'http://www.tirantasesores.com')
      Esp::Subsystem.update(3, url: 'http://propiedadhorizontal.tirant.com')
      Esp::Subsystem.update(4, url: 'http://analytics.tirant.com')
      Esp::Subsystem.update(5, url: 'http://icab.tirantonline.com')
      Esp::Subsystem.update(6, url: 'http://cyl.tirantonline.com')
    end
  end
end
