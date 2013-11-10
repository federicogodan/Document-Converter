# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Load the associations for the formats compatibilities

#Load the formats
f1  = Format.new(name:"DOC")
f2  = Format.new(name:"DOCX")
f3  = Format.new(name:"PPT")
f4  = Format.new(name:"PPTX")
f5  = Format.new(name:"XLS")
f6  = Format.new(name:"XLSX")
f7  = Format.new(name:"ODT")
f8  = Format.new(name:"ODS")
f9  = Format.new(name:"ODP")
f10 = Format.new(name:"TXT")
f11 = Format.new(name:"PDF")
f12 = Format.new(name:"HTML")
f13 = Format.new(name:"JPG")
f14 = Format.new(name:"PNG")
f15 = Format.new(name:"RFT")
f1.save
f2.save
f3.save
f4.save
f5.save
f6.save
f7.save
f8.save
f9.save
f10.save
f11.save
f12.save
f13.save
f14.save
f15.save

#Load the associations
#DOC to DOCX,ODT,ODS,ODP,TXT,PDF,JPG,PNG,HTML
f1.destinies.push(f2)
f1.destinies.push(f7)
f1.destinies.push(f8)
f1.destinies.push(f9)
f1.destinies.push(f10)
f1.destinies.push(f11)
f1.destinies.push(f12)
f1.destinies.push(f13)
f1.destinies.push(f14)
f1.save


#DOCX to DOC,RFT,ODT,HTML,TXT,PDF
f2.destinies.push(f1)
f2.destinies.push(f15)
f2.destinies.push(f7)
f2.destinies.push(f12)
f2.destinies.push(f10)
f2.destinies.push(f11)
f2.save


#PPT to ODP,PDF,JPG,PNG,HTML
f3.destinies.push(f9)
f3.destinies.push(f11)
f3.destinies.push(f13)
f3.destinies.push(f14)
f3.destinies.push(f12)
f3.save

#PPTX to PPT,ODP,PDF,JPG,PNG,HTML
f4.destinies.push(f3)
f4.destinies.push(f9)
f4.destinies.push(f11)
f4.destinies.push(f13)
f4.destinies.push(f14)
f4.destinies.push(f12)
f4.save

#XLS to ODS,PDF,JPG,PNG,HTML,XLSX
f5.destinies.push(f8)
f5.destinies.push(f11)
f5.destinies.push(f12)
f5.destinies.push(f13)
f5.destinies.push(f14)
f5.destinies.push(f6)
f5.save

#XLSX to ODS,XLS,PDF,JPG,PNG,HTML
f6.destinies.push(f8)
f6.destinies.push(f11)
f6.destinies.push(f12)
f6.destinies.push(f13)
f6.destinies.push(f14)
f6.destinies.push(f5)
f6.save

#ODT to DOC,DOCX,JPG,PNG,HTML
f7.destinies.push(f1)
f7.destinies.push(f2)
f7.destinies.push(f11)
f7.destinies.push(f12)
f7.destinies.push(f13)
f7.destinies.push(f14)
f7.save

#ODS to PDF,JPG,PNG,HTML
f8.destinies.push(f11)
f8.destinies.push(f12)
f8.destinies.push(f13)
f8.destinies.push(f14)
f8.save

#ODP to PPT,PPTX,PDF,JPG,PNG,HTML
f9.destinies.push(f3)
f9.destinies.push(f4)
f9.destinies.push(f11)
f9.destinies.push(f12)
f9.destinies.push(f13)
f9.destinies.push(f14)
f9.save

#TXT to DOC,DOCX,RTF,ODT,PDF,HTML
f10.destinies.push(f1)
f10.destinies.push(f2)
f10.destinies.push(f11)
f10.destinies.push(f12)
f10.destinies.push(f7)
f10.destinies.push(f15)
f10.save

#PDF to JPG,PNG
f11.destinies.push(f13)
f11.destinies.push(f14)
f11.save

#HTML to TXT,PDF
f12.destinies.push(f10)
f12.destinies.push(f11)
f12.save

#JPG to DOC,DOCX,ODT,ODP,TXT,PDF,PNG
f13.destinies.push(f1)
f13.destinies.push(f2)
f13.destinies.push(f7)
f13.destinies.push(f9)
f13.destinies.push(f10)
f13.destinies.push(f11)
f13.destinies.push(f14)
f13.save

#PNG to ODT,ODP,PDF,JPG
f14.destinies.push(f7)
f14.destinies.push(f9)
f14.destinies.push(f11)
f14.destinies.push(f13)
f14.save

#Create users
for i in 0..50
  em = "user" + i.to_s + "@pruebap.com" 
  nik = "userexample" + i.to_s 
  pass = "passuser" + i.to_s 
  User.create(email: em, nick: nik, password: pass) 
end

#Create Document for user
for i in 0..10
  usr_id = 1
  ft_id = 1
  fl = "file_" + i.to_s
  nm = "file_name" + i.to_s
  sz = i
  Document.create(user_id: usr_id, format_id: ft_id, file: fl, name: nm, size: sz)
end

#Create ConvertedDocument for user 
for i in 1..10
  dw_lk = "www.algo.com.uy"
  sz = i * 10
  cd = ConvertedDocument.new(download_link: dw_lk, size: sz)
  cd.document = Document.find(i)
  cd.format = Format.find(i)
  cd.set_to_converting
  cd.save
end

AdminUser.create!(:email => 'admin@example.com', :password => 'password', :password_confirmation => 'password') if AdminUser.where(:email => 'admin@example.com').nil?