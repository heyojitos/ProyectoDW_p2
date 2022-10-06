GO
USE DBCARRITO

GO
create proc sp_obtenerCategoria
as
begin
 select * from CATEGORIA
end


go


--PROCEDIMIENTO PARA GUARDAR CATEGORIA
CREATE PROC sp_RegistrarCategoria(
@Descripcion varchar(50),
@Resultado bit output
)as
begin
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM CATEGORIA WHERE Descripcion = @Descripcion)

		insert into CATEGORIA(Descripcion) values (
		@Descripcion
		)
	ELSE
		SET @Resultado = 0
	
end

go

--PROCEDIMIENTO PARA MODIFICAR CATEGORIA
create procedure sp_ModificarCategoria(
@IdCategoria int,
@Descripcion varchar(60),
@Activo bit,
@Resultado bit output
)
as
begin
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM CATEGORIA WHERE Descripcion =@Descripcion and IdCategoria != @IdCategoria)
		
		update CATEGORIA set 
		Descripcion = @Descripcion,
		Activo = @Activo
		where IdCategoria = @IdCategoria
	ELSE
		SET @Resultado = 0

end


GO
create proc sp_obtenerMarca
as
begin
 select * from MARCA
end

go

--PROCEDIMIENTO PARA GUARDAR MARCA
CREATE PROC sp_RegistrarMarca(
@Descripcion varchar(50),
@Resultado bit output
)as
begin
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM MARCA WHERE Descripcion = @Descripcion)

		insert into MARCA(Descripcion) values (
		@Descripcion
		)
	ELSE
		SET @Resultado = 0
	
end

go

--PROCEDIMIENTO PARA MODIFICAR MARCA
create procedure sp_ModificarMarca(
@IdMarca int,
@Descripcion varchar(60),
@Activo bit,
@Resultado bit output
)
as
begin
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM MARCA WHERE Descripcion =@Descripcion and IdMarca != @IdMarca)
		
		update MARCA set 
		Descripcion = @Descripcion,
		Activo = @Activo
		where IdMarca = @IdMarca
	ELSE
		SET @Resultado = 0

end

GO
create proc sp_obtenerProducto
as
begin
 select p.*,m.Descripcion[DescripcionMarca],c.Descripcion[DescripcionCategoria] from PRODUCTO p
 inner join marca m on m.IdMarca = p.IdMarca
 inner join CATEGORIA c on c.IdCategoria = p.IdCategoria

end

go

create proc sp_registrarProducto(
@Nombre varchar(500),
@Descripcion varchar(500),
@IdMarca int,
@IdCategoria int,
@Precio decimal(10,2),
@Stock int,
@RutaImagen varchar(100),
@NombreImagen varchar(100),
@Resultado int output
)
as
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM PRODUCTO WHERE Descripcion = @Descripcion)
	begin
		insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen,NombreImagen) values (
		@Nombre,@Descripcion,@IdMarca,@IdCategoria,@Precio,@Stock,@RutaImagen,@NombreImagen)

		SET @Resultado = scope_identity()
	end
end

go

create proc sp_editarProducto(
@IdProducto int,
@Nombre varchar(500),
@Descripcion varchar(500),
@IdMarca int,
@IdCategoria int,
@Precio decimal(10,2),
@Stock int,
@Activo bit,
@Resultado bit output
)
as
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM PRODUCTO WHERE Descripcion = @Descripcion and IdProducto != @IdProducto)
	begin
		update PRODUCTO set 
		Nombre = @Nombre,
		Descripcion = @Descripcion,
		IdMarca = @IdMarca,
		IdCategoria = @IdCategoria,
		Precio =@Precio ,
		Stock =@Stock ,
		Activo = @Activo where IdProducto = @IdProducto

		SET @Resultado =1
	end
end

go
create proc sp_actualizarRutaImagen(
@IdProducto int,
@RutaImagen varchar(500)
)
as
begin
	update PRODUCTO set RutaImagen = @RutaImagen where IdProducto = @IdProducto
end

go

create proc sp_obtenerUsuario(
@Correo varchar(150),
@Clave varchar(100)
)
as
begin
	IF EXISTS (SELECT * FROM usuario WHERE Correo = @Correo and Clave = @Clave)
	begin
		SELECT IdUsuario,Nombres,Apellidos,Correo,Clave,Reestablecer FROM usuario WHERE Correo = @Correo and Clave = @Clave
	end
end


go

create proc sp_registrarUsuario(
@Nombres varchar(100),
@Apellidos varchar(100),
@Correo varchar(150),
@Clave varchar(100),
@Reestablecer bit,
@Resultado int output
)
as
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM USUARIO WHERE Correo = @Correo)
	begin
		insert into USUARIO(Nombres,Apellidos,Correo,Clave,Reestablecer) values
		(@Nombres,@Apellidos,@Correo,@Clave,@Reestablecer)

		SET @Resultado = scope_identity()
	end
end
go

create proc sp_InsertarCarrito(
@IdCliente int,
@IdProducto int,
@Cantidad int,
@Resultado int output
)
as
begin
	set @Resultado = 0
	if not exists (select * from CARRITO where IdProducto = @IdProducto and IdCliente = @IdCliente)
	begin
		update PRODUCTO set Stock = Stock -1 where IdProducto = @IdProducto
		insert into CARRITO(IdCliente,IdProducto,Cantidad) values ( @IdCliente,@IdProducto,@Cantidad)
		set @Resultado = 1
	end
	
end

go

create proc sp_ObtenerCarrito(
@IdCliente int
)
as
begin
	select c.IdCarrito, p.IdProducto,m.Descripcion,p.Nombre,p.Precio,p.RutaImagen from carrito c
	inner join PRODUCTO p on p.IdProducto = c.IdProducto
	inner join MARCA m on m.IdMarca = p.IdMarca
	where c.IdCliente = @IdCliente
end

go


create proc sp_registrarVenta(
@IdCliente int,
@TotalProducto int,
@MontoTotal decimal(10,2),
@Contacto varchar(50),
@Telefono varchar(50),
@Direccion varchar(500),
@IdDistrito varchar(10),
@IdTransaccion varchar(50),
@QueryDetalleVenta nvarchar(max),
@Resultado bit output
)
as
begin
	begin try
		SET @Resultado = 0
		begin transaction
		
		declare @idVenta int = 0
		insert into VENTA(IdCliente,TotalProducto,MontoTotal,Contacto,Telefono,Direccion,IdDistrito) values
		(@IdCliente,@TotalProducto,@MontoTotal,@Contacto,@Telefono,@Direccion,@IdDistrito)

		set @idVenta = scope_identity()

		set @QueryDetalleVenta = replace(@QueryDetalleVenta,'¡idventa!',@idVenta)

		EXECUTE sp_executesql @QueryDetalleVenta

		delete from CARRITO where IdCliente = @IdCliente

		SET @Resultado = 1

		commit
	end try
	begin catch
		rollback
		SET @Resultado = 0
	end catch
end

go

create proc sp_ObtenerVenta(
@IdCliente int)
as
begin
select v.MontoTotal,convert(char(10),v.FechaVenta,103)[Fecha],

(select m.Descripcion, p.Nombre,p.RutaImagen,dc.Total,dc.Cantidad from DETALLE_VENTA dc
inner join PRODUCTO p on p.IdProducto = dc.IdProducto
inner join MARCA m on m.IdMarca = p.IdMarca
where dc.IdVenta = v.IdVenta
FOR XML PATH ('PRODUCTO'),TYPE) AS 'DETALLE_PRODUCTO'

from VENTA v
where v.IdCliente = @IdCliente
FOR XML PATH('COMPRA'), ROOT('DATA') 
end

exec sp_ObtenerVenta 2