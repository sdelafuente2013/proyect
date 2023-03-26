namespace :countryisocodes do
  desc "Update Pais Latam with iso codes from two digits"
  task :update => :environment do
    p "Updating LATAM country iso codes from 2 digits"
    
    iso_3digits = ["esp", "mex", "arg", "slv", "col", "per", "chl", "bra", "pan", "ven", "bol", "cri", "ecu", "gtm", "hnd", "jam", "pry", "dom","tto","ury","prt","nic"]
  
    iso_2digits = ["es", "mx", "ar", "sv", "co", "pe", "cl", "br", "pa", "ve", "bo", "cr", "ec", "gt", "hn", "jm", "py", "do","tt","uy","pt","ni"]
  
    iso_3digits.each_with_index do |iso_code, i|
      p "UPDATE ISOCODE: %s" % iso_code
      p "for latam"
      Latam::Pais.by_iso_code(iso_code).update(:codigo_iso_2digits => iso_2digits[i])
      p "for esp"
      Esp::Pais.by_iso_code(iso_code).update(:codigo_iso_2digits => iso_2digits[i])
      p "for mex"
      Mex::Pais.by_iso_code(iso_code).update(:codigo_iso_2digits => iso_2digits[i])
    end

    p "Done!"
  end
  
end