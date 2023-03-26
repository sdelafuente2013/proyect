class UpdateUsuarioMySubscriptionVisible < ActiveRecord::Migration[5.1]
  def change

    execute("update usuario set my_subscription_visible = 0 where id in (select * from (select u.id from usuario u , grupo g where u.grupoid=g.id and u.grupoid in (76, 1055, 8, 1073, 576, 941, 1079, 10, 702, 285, 499, 297, 143, 303, 47)) as X);")

    execute("update usuario set my_subscription_visible = 0 where id in (select * from (select id from usuario where username in (
      'ica', 'alzira', 'icaavila', 'icalba', 'icaalmeria', 'icaantequera', 'Biblioteca', 'biblioburgos',
      'ciudadreal', 'icacuenca', 'ferrol', 'icaguadalajara', 'pamplona', 'PAMPLONA', 'Colegio', 'icagijon',
      'guipuzcoa ', 'guipuzkoa', 'icahuelva', 'ICATOLEDO', 'icabjerez', 'laspalmas', 'biblioleon ', 'lleida',
      'ICALORCA', 'ICALUGO', 'Madrid', 'malaga', 'Oviedo', 'pontevedra', 'sabadell', 'icasal', 'santfeliu', 'santfeliu',
      'ICAS', 'Sevilla', 'icolabotal ', 'tenerife', 'icater', 'rubi', 'ICATOLEDO', 'ICAV', 'cmadrid', 'reicaz', 'ICAALZIRA',
      'avila', 'CASTELLON', 'ACORUNA', 'ALBACETE', 'almeria', 'ICABA', 'ICAIB', 'alumnosICAB', 'icabp', 'icaburgos',
      'CADIZ', 'icacantabria', 'CCANTABRIA', 'CARTAGENA', 'CEUTA', 'icacr', 'ICACORDOBA', 'cuenca', 'ICAFERROL', 'colegiats',
      'granollers', 'guadalajara ', 'APPSHUELVA', 'JEREZ', 'LANZAROTE', 'ICAR', 'icalpa', 'ical', 'clleida', 'LORCA', 'icalugo',
      'CMADRID', 'COLEGIADOSICAM', 'malaga', 'colegiados', 'mataro', 'MELILLA', 'icaoviedo', 'icapontevedra', 'icasbd', 'salamanca',
      'icasf', 'CSANTIAGO', 'segovia', 'APPSEVILLA', 'ICASORIA', 'talavera', 'ICATARRAGONA', 'ICATENERIFE', 'icatercolegiado',
      'toledo', 'tortosa', 'ICAVALENCIA', 'ABOGADOSICAV', 'valladolid', 'icavic', 'icazamora', 'consejoclm', 'consejocl', 'col·legis'
    )) as X);")
    
  end
end
