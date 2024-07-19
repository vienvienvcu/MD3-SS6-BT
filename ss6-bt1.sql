use md3_ss02;
create table users(
   id int auto_increment primary key,
   name varchar(100),
   address varchar(255),
   phone varchar(11),
   dateOfBirth date,
   status bit
);
create table product(
   id int auto_increment primary key,
   name varchar (100),
   price double ,
   stock int,
   status bit
);
create table shopping_cart(
   id int auto_increment primary key,
   user_id int,
   product_id int,
   quantity int,
   amount double,
   constraint fk_users foreign key (user_id) references users(id),
   constraint fk_product foreign key (product_id) references product(id)
);


select * from users;
insert into users(name,address,phone,dateOfBirth,status) 

values ('nguyen thi vien','binh giang,hai duong','098765443','1996-06-06',1),
      ('tran van hai','lang ha, ha noi','098769999','1997-07-07',1),
      ('ho quang anh','bac giang, viet nam','09276777','1997-06-05',1),
      ('le van toan','hung yen, viet nam','091769966','1994-08-04',1),
      ('pham van tuyen','de la thanh, ha noi','0908769678','1990-07-01',1);
      
select * from product;
INSERT INTO product (name, price, stock, status) 
VALUES 
    ('Pizza', 100.0, 50, 1),
    ('Burger', 50.0, 100, 1),
    ('Pasta', 75.0, 80, 1),
    ('Soda', 10.0, 200, 1),
    ('Chicken Wings', 120.0, 60, 1);
    
select * from shopping_cart;
INSERT INTO shopping_cart (user_id, product_id, quantity, amount)
VALUES 
    (1, 1, 2, 200.0),  -- Pizza
    (2, 2, 1, 50.0),   -- Burger
    (3, 3, 3, 225.0),  -- Pasta
    (4, 4, 5, 50.0),   -- Soda
    (5, 5, 1, 120.0);  -- Chicken Wings
    
    
-- Tạo Trigger khi thay đổi giá của sản phẩm thì amount (tổng giá) cũng sẽ phải cập nhật lại 
      
delimiter $$

create trigger after_product_update
after update on product 
for each row 
begin 
 if new.price != old.price then
     update shopping_cart 
     set amount = new.price*quantity
     where product_id = new.id ;
     end if;
end $$

delimiter ; 

show triggers;

update product
set price = 80
where id = 3;

select * from product;
select * from shopping_cart;

-- Tạo trigger khi xóa product thì những dữ liệu ở bảng shopping_cart có chứa product bị xóa thì cũng phải xóa theo

delimiter $$

create trigger after_product_delete
after delete on product 
for each row 
begin 
   delete from shopping_cart
   where product_id = old.id;
end $$

delimiter ;
-- Xóa trigger hiện tại nếu có
DROP TRIGGER IF EXISTS after_product_delete;
-- Tạo trigger mới

DELIMITER $$
CREATE TRIGGER before_product_delete
BEFORE DELETE ON product 
FOR EACH ROW 
BEGIN 
   DELETE FROM shopping_cart
   WHERE product_id = OLD.id;
END $$
DELIMITER ;

delete from product 
where id = 2;

-- Hiển thị bảng product và shopping_cart để kiểm tra kết quả xóa
SELECT * FROM product;
SELECT * FROM shopping_cart;


