

insert into USUARIO(Nombres,Apellidos,Correo,Clave) values ('test nombre','test apellido','test@example.com','ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae')

 go

 insert into CATEGORIA(Descripcion) values 
 ('Tecnologia'),
 ('Muebles'),
 ('Dormitorio'),
  ('Deportes')


go

  insert into MARCA(Descripcion) values
('SONYTE'),
('HPTE'),
('LGTE'),
('HYUNDAITE'),
('CANONTE'),
('ROBERTA ALLENTE')


go


insert into DEPARTAMENTO(IdDepartamento,Descripcion)
values 
('01','Guatemala'),
('02','Escuintla'),
('03','Peten')


go

insert into MUNICIPIO(IdMunicipio,Descripcion,IdDepartamento)
values
('0101','Mixco','01'),
('0102','Villanueva','01'),

--ESCUINTLA
('0201', 'Palin ', '02'),
('0202', 'Santa Lucia ', '02'),

--PETEN
('0301', 'Flores ', '03'),
('0302', 'Sayaxe ', '03')


go

insert into COLONIA(IdColonia,Descripcion,IdMunicipio,IdDepartamento) values 
('010101','Monte Real','0101','01'),
('010102', 'Milagro', '0101', '01'),

('010201', 'San Cristobal', '0102', '01'),
('010202', 'Villa Nueva', '0102', '01'),

--ESCUINTLA
('020101', 'Ica', '0201', '02'),
('020102', 'La Tinguiña', '0201', '02'),
('020201', 'Chincha Alta', '0202', '02'),
('020202', 'Alto Laran', '0202', '02'),


--PETEN
('030101', 'Lima', '0301', '03'),
('030102', 'Ancón', '0301', '03'),
('030201', 'Barranca', '0302', '03'),
('030202', 'Paramonga', '0302', '03')



