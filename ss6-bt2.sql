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
    
-- Tạo Transaction khi thêm sản phẩm vào giỏ hàng thì 
-- kiểm tra xem stock của products có đủ số lượng không nếu không thì rollback ???   

delimiter $$
create procedure addtoCart(
  in p_user_id int,
  in p_product_id int,
  in p_quantity int
)
begin
   declare v_stock int;
   declare lbl_end int default 0;
  -- Bắt đầu transaction
  start transaction;
  -- kiem tra so luong ton kho cua san pham
  select stock into v_stock
  from product
  where id = p_product_id
  for update;
  -- Nếu số lượng tồn kho không đủ, rollback transaction và kết thúc thủ tục
  if v_stock< p_quantity then
   rollback;
   select 'Số lượng sản phẩm không đủ' as message;
   set lbl_end = 1;
   
end if;
-- Thêm sản phẩm vào giỏ hàng
 if lbl_end = 0 then
insert into shopping_cart(user_id, product_id, quantity, amount)
values (p_user_id,p_product_id,p_quantity
,p_quantity* (select price from product where id = p_product_id));

  -- Cập nhật số lượng tồn kho
  
  update product 
  set stock = stock - p_quantity
  where id = p_product_id;
  -- Hoàn tất transaction
  commit;
  select 'Thêm sản phẩm vào giỏ hàng thành công' as message;
  end if;
end$$
delimiter ;


-- Test thủ tục
call addToCart(1, 1, 5);
call addToCart(2, 2, 150);

-- Tạo Transaction khi xóa sản phẩm trong giỏ hàng thì trả lại số lượng cho products

delimiter $$

create procedure removeFromCart(
  in p_cart_id int
)
begin
  declare v_product_id int;
  declare v_quantity int;
  declare lbl_end int default 0;

  -- Bắt đầu transaction
  start transaction;

  -- Lấy thông tin sản phẩm và số lượng từ giỏ hàng
  select product_id, quantity into v_product_id, v_quantity
  from shopping_cart
  where id = p_cart_id
  for update;

  -- Nếu sản phẩm không tồn tại trong giỏ hàng, rollback transaction và kết thúc thủ tục
  if v_product_id is null or v_quantity is null then
    rollback;
    select 'Sản phẩm không tồn tại trong giỏ hàng' as message;
    set lbl_end = 1;
  end if;

  if lbl_end = 0 then
    -- Xóa sản phẩm khỏi giỏ hàng
    delete from shopping_cart
    where id = p_cart_id;

    -- Trả lại số lượng cho sản phẩm
    update product
    set stock = stock + v_quantity
    where id = v_product_id;

    -- Hoàn tất transaction
    commit;
    
    select 'Xóa sản phẩm khỏi giỏ hàng và cập nhật tồn kho thành công' as message;
  end if;

end$$

delimiter ;

call removeFromCart(7);
call removeFromCart(9);
select * from product;
select * from shopping_cart;



