use md3_ss02;
create table users(
  id int auto_increment primary key,
  name varchar(100),
  myMoney double,
  address varchar(255),
  phone varchar(11),
  dateOfBirth date,
  status bit
);

create table transfer(
  sender_id int,
  receiver_id int,
  money double,
  transfer_date datetime,
  primary key (sender_id,receiver_id),
  foreign key (sender_id) references users(id),
  foreign key (receiver_id) references users(id)
);
INSERT INTO users (name, myMoney, address, phone, dateOfBirth, status) VALUES
('Nguyễn Văn A', 15000000, '123 Đường Láng, Hà Nội', '0912345678', '1985-05-20', b'1'),
('Trần Thị B', 20000000, '456 Đường Giải Phóng, Hà Nội', '0923456789', '1990-08-15', b'1'),
('Lê Minh C', 30000000, '789 Đường Nguyễn Trãi, Hà Nội', '0934567890', '1988-12-25', b'1'),
('Phạm Thanh D', 25000000, '101 Đường Cầu Giấy, Hà Nội', '0945678901', '1992-03-10', b'1'),
('Hoàng Thị E', 35000000, '202 Đường Kim Mã, Hà Nội', '0956789012', '1987-07-30', b'1');

-- Bắt đầu transaction

start transaction;
-- update lại money của người gửi
update users set myMoney = myMoney - 13000000 WHERE id = 1; 
-- tạo transfers
insert into transfers (sender_id,receiver_id ,money,transfer_date) values (1,2,13000000,NOW());
-- update lại money của người nhận
update users set myMoney = myMoney + 13000000 where id = 2;
commit;
set autocommit = 0; 
 

