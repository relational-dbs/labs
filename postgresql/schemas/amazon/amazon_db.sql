/* **************************************** */
/*          INSTRUCCIONES INICIALES         */
/* **************************************** */
SET CLIENT_ENCODING TO 'UTF8';

/* **************************************** */
/*                  ESQUEMA                 */
/* **************************************** */
-- categoria
create table public.categoria (
    id bigserial primary key,
    nombre character varying(300) not null
);
create unique index categoria_nombre_key on categoria using btree (nombre);
create index categoria_nombre_like on categoria using btree (nombre);

-- usuario
create table public.usuario (
    id bigserial primary key,
    nombre character varying(300) not null,
    apellido character varying(300) not null,
    telefono character varying(15) not null,
    correo character varying(254) not null,
    contrasena character varying(100) not null,
    es_prime boolean not null
);
create unique index usuario_telefono_key on usuario using btree (telefono);
create unique index usuario_correo_key on usuario using btree (correo);
create index usuario_telefono_like on usuario using btree (telefono);
create index usuario_correo_like on usuario using btree (correo);

-- producto
create table public.producto (
     id bigserial primary key,
     nombre character varying(300) not null,
     descripcion text not null,
     precio numeric(12,2) not null,
     imagen character varying(100) not null
);

-- orden
create table public.orden (
    id bigserial primary key,
    fecha_creacion timestamp with time zone not null,
    fecha_entrega timestamp with time zone,
    direccion_entrega text not null,
    usuario_id bigint not null,

    foreign key (usuario_id) references public.usuario (id)
    on update restrict on delete restrict
);
create index orden_usuario_id on orden using btree (usuario_id);

-- producto_categoria
create table public.producto_categoria (
    id bigserial primary key,
    categoria_id bigint not null,
    producto_id bigint not null,

    foreign key (categoria_id) references public.categoria (id)
    on update restrict on delete cascade,

    foreign key (producto_id) references public.producto (id)
    on update restrict on delete cascade
);
create index producto_categoria_categoria_id on producto_categoria using btree (categoria_id);
create index producto_categoria_producto_id on producto_categoria using btree (producto_id);

-- producto_orden
create table public.producto_orden (
    id bigserial primary key,
    cantidad smallint not null,
    orden_id bigint not null,
    producto_id bigint not null,

    foreign key (orden_id) references public.orden (id)
    on update restrict on delete restrict,

    foreign key (producto_id) references public.producto (id)
    on update restrict on delete restrict
);
create index producto_orden_orden_id on producto_orden using btree (orden_id);
create index producto_orden_producto_id on producto_orden using btree (producto_id);

-- pago
create table public.pago (
    id bigserial primary key,
    fecha_pago timestamp with time zone not null,
    fecha_validacion timestamp with time zone,
    monto numeric(12,2) not null,
    validado boolean not null,
    orden_id bigint not null,

    foreign key (orden_id) references public.orden (id)
    on update restrict on delete restrict
);
create index pago_orden_id on pago using btree (orden_id);

/* **************************************** */
/*                SECUENCIAS                */
/* **************************************** */
-- categoria
alter sequence categoria_id_seq restart with 41;

-- usuario
alter sequence usuario_id_seq restart with 321;

-- producto
alter sequence producto_id_seq restart with 531;

-- orden
alter sequence orden_id_seq restart with 1417;

-- producto_categoria
alter sequence producto_categoria_id_seq restart with 1571;

-- producto_orden
alter sequence producto_orden_id_seq restart with 7689;

-- pago
alter sequence pago_id_seq restart with 4936;

/* **************************************** */
/*                   DATOS                  */
/* **************************************** */
-- categoria
COPY public.categoria (id, nombre) FROM stdin WITH (FORMAT CSV, DELIMITER ',');
1,Electrónica
2,Computadoras y Accesorios
3,Hogar Inteligente
4,Hogar y Cocina
5,Muebles
6,Electrodomésticos
7,Productos para Mascotas
8,Juguetes y Juegos
9,Bebés
10,"Ropa, Zapatos y Joyería"
11,Belleza y Cuidado Personal
12,Salud y Hogar
13,Deportes y Aire Libre
14,Herramientas y Mejoras del Hogar
15,Automotriz
16,Industrial y Científico
17,Libros
18,Películas y TV
19,Música
20,Videojuegos
21,Oficina y Papelería
22,Alimentos y Gourmet
23,Hecho a Mano
24,Instrumentos Musicales
25,Jardín y Exteriores
26,"Arte, Manualidades y Costura"
27,Coleccionables y Bellas Artes
28,Celulares y Accesorios
29,Software
30,Equipaje y Viajes
31,Relojes
32,Cuidado de la Salud
33,Suministros para Oficina
34,Cámaras y Fotografía
35,Accesorios de Moda
36,E-books y Lectores Electrónicos
37,Productos de Limpieza
38,Seguridad y Vigilancia
39,Accesorios para Computadoras
40,Joyería Fina
\.

-- usuario
COPY public.usuario (id, nombre, apellido, telefono, correo, contrasena, es_prime) FROM stdin WITH (FORMAT CSV, DELIMITER ',');
1,Vanessa,Fitzpatrick,666-897-4631,tamara69@example.com,dd1ff2200daa2a4c5c192adcaab78be2e902e2063c70021c320742002c486bdb,false
2,Nathan,Bridges,566-638-4021,aramirez@example.org,410351f0afa05b3be2e7dc9d3086621821528afeb2e99868fce7109317cc08ae,false
3,Stephen,Campbell,(304)968-8401,zroberts@example.net,6977f36a36e5fee7cd4a3245d8661d4a134295fd7c45de985bd1ccd1465935a0,false
4,Kelly,Esparza,765-531-0492,danielrodriguez@example.com,581a93a4695542c322f922ef412f4a2abd2862b44090fca09165e754fca33790,false
5,Thomas,Ramos,3985397505,josephguerrero@example.com,0fe1d63d8a601c1517d3d172d2503e3d12df9b4689925f0628f3532f51b22c39,false
6,Virginia,Cherry,299-708-5752,angelvaldez@example.org,34c9af5635e47f53ef761fb5d4dd984b45083ce954f26d851c7b38021b99fa70,false
7,Matthew,Petersen,(314)666-0494,dwarren@example.org,3ad85bf2b2fe51884e7acdfb70f51d9a853764c7b02bdb7b78143fcefe30f586,true
8,Megan,Griffin,714-908-2321,wrobinson@example.net,c1817013863ef3d5d633c9f90cc10cb0ac8ba7d485696aee8a8d59be2362d495,false
9,Alex,Fowler,666-616-9838,ldodson@example.net,8dff60113a89721413190d80f1d7fe9f7cd75757630a42319cfbcdd23c7fcff3,false
10,Trevor,Foster,(236)408-0215,qdavidson@example.net,d4021c834b407f13032f33cf94ba3646cbabfb5d32d298b29190adbaeb694fb5,false
11,Emily,Johnson,685-879-6708,kathryn80@example.org,cc7c1c51f3bb5b710a157c6a3ceee071aa1487ec6476a944015b43f431e67047,false
12,Gary,Mcgee,(646)200-3628,nathanielgreen@example.com,76208cdbb2cfbfe703dbd4549ddc9ee904fdf8fc65e492d5800c9fa7ebdb7c29,true
13,William,Flores,503-866-7264,johnathan88@example.org,2b9f6a183589e606aab22c1137ae670325fa61acd7655aeb9a9941a1f517db1f,false
14,Nicholas,Bright,802-557-1884,dakota73@example.org,63c1224d3d07105cf1c99ff9031b32ae1df13b18b40514a7af1df613825f629f,false
15,Stacie,Parker,2089556563,psmith@example.com,e3f4a2d4975bd9a2c31a3bef581435f554fcd1c5f2be3aff88f491b74d6c4ad4,false
16,Donna,Alexander,(777)737-6546,grayrandy@example.net,e69abb21f203c87b2f1db5c1b8b8962ae04b41ec1b2bfc759b60f9179bb10916,true
17,William,Smith,547-533-1363,bartonmary@example.org,b61f7c330a10f9aad7eb002760c5b33d287ced1dcc2acec483ba6f717e05af1a,true
18,Maria,Cardenas,(422)895-4273,marcbernard@example.net,6f6217ac41c3ffc3830541e7908ca6c5b20d74abd7b160e7e2411423245a8f5d,true
19,Melissa,Ayers,3438140412,lnorris@example.net,01a3daff6942a45e120eec423db30296f7b3867e50003636291dc60d54fa436f,false
20,Samantha,Tucker,869-555-2963,stevenscott@example.com,f8be271e58b8c77bd0856d1eeeaa81bf28a91973eb06f84360a917c4603c5449,false
21,Penny,Martin,6193675431,leemercedes@example.org,8966e1b75b659e0db8a2531ac0b63ddf18344d2afd836eff384da0480bebc542,false
22,Sara,Cooper,3295829359,harteric@example.com,c1bcd5c96413bb2d678c1a8d0e26f03b3159be1139636197723a0a6440e06929,false
23,Henry,Jensen,5305087361,vrodriguez@example.org,829fde9f3867e70de65205ea2adce947db3e2adf90bb29e0f7ade9a0a19d9735,false
24,Kathryn,Gregory,(547)534-8557,cwhite@example.com,c89ae0cd7fd567488045486af5448b9329073a9c68b63674ff6cce0720a9f906,true
25,Wendy,Roach,812-444-3063,reyeskayla@example.org,50e5551f51dd5583cd289b4dade96ce78a967299b409b49e111751193082ed5f,false
26,Scott,Thomas,212-759-1462,michellecrawford@example.org,2183e6d4d90c6062e38701a5d6bfbe6cae59354b530ef1f610337afa4b41ce7c,false
27,Annette,Washington,321-597-0337,debra22@example.org,3477aff8cd322c077f5cdd39dbe593c15851954fd73d8cf32373ce7ab7d40207,false
28,Christopher,Morris,400-679-7296,heather69@example.org,2c360a3b55750e83a0b443f6c39bc0df25fca20a0ea1431cf79982b29662ee98,false
29,Austin,Kim,6148933098,diana59@example.net,800c0eeaee6212e4b01ccc34ea3ba523a7c5ef4a665e8df6c269e1518273666d,false
30,Margaret,Cummings,8715185441,johnsonshannon@example.com,324c95d58140e1d67981dd31c9f67773ef8740e3b16206c60e19950c085a3519,false
31,Amanda,Mcguire,620-719-5219,james87@example.org,f79511cbf152c2225678314fc4331f7b8df17c28ad63af24a37f762a43107866,true
32,James,Carter,(990)962-0574,christopher84@example.net,754a52e45701116849612635d1b504194f62a197830c141908cd906a4ab8c051,false
33,Brian,Brown,209-656-6645,hstone@example.net,12fbe57ea9c772ab63ca06ed5603ca93b363397604d931390cc0b1acbc0d8b99,true
34,Timothy,Gamble,319-280-6799,halldarren@example.com,8e3c45ee559da582b0589df37573b1a7a5f38b31bab833676612d76ea96b6e2a,false
35,Rachel,Lane,7619396311,fhill@example.net,3bafc2d8a3e1516852917166f2ad872c91d0359828345ef6ea124957bc672506,false
36,Paula,Henderson,(847)336-4665,gomezmeredith@example.org,b252e08dae711f571b647c4d727d014d128b5cc9a718abe3ce9f63a0f4d7c764,false
37,George,Gallegos,7767365236,orozcodonna@example.com,46418561ff1382717002417e7e2d9ab6318463e24e99305c5119b7b5a2c922f4,false
38,Molly,Nelson,753-370-0150,erik93@example.org,754dbcc8752676d520cb8f48408a402d8163a0ea74bfad60238303dcd8a7f9ad,true
39,Michael,Suarez,216-647-7055,iannunez@example.com,8e3919a0f58871f32ec050852ec815574d8ba94389d548a401b405161eadc59a,false
40,Michael,Baker,8358488103,pittsmichael@example.org,82d99e8cb25b139be1943c51d8eab11b2e0dd09156ea3226488269f211ae5000,false
41,James,Robertson,6838047817,wigginslarry@example.com,89285af978b780b02e6461c4b383a8f3a54ea12883934dd0e93f5b128fa65a38,false
42,Toni,Perkins,4069637995,hlong@example.org,db16b9304f4f5dbf3a24a4296bf6134dce1e12cd7ed4fb115438849af9b94e82,false
43,Brandon,Bell,(611)906-1158,leonmatthew@example.org,2d6b7120be2501554f3d845411b246915ad9378928c52ddd6d03dc7086431dac,false
44,Bruce,Lawson,8519442977,ofrazier@example.net,53e50c437b09d8a48816250119f763fbaf560668bb0777dfe2c67e6266e19eda,false
45,Natalie,Hooper,6268804534,qwilliams@example.org,26582bc227b9ecf6f8c56a6b2ea29212138e054ec6cf39edf2ac8e45ae8eed11,false
46,Brandi,Davidson,305-639-4220,kevin78@example.com,2b91318b2fb24da4153e127481f2552c1664162fdd26f496c2577725b528cb1c,false
47,Robert,Odonnell,930-580-4341,rhenderson@example.com,dd3c93fb5f01190b7f69baad71befd8ee0e9bd605d922fe25e0acf3b1ed3ef59,false
48,Cathy,Mcgrath,4128276087,zsolis@example.net,de8af05d259196a9faaa84d8f11a96093cde2a20e415ff16bf6f6b1305eef8a3,false
49,Matthew,Flores,595-479-6871,reginaldmartin@example.net,67492eed37a934bd6639f07dc7e33314d7ba4fb6fc79d023a501b95ce1900356,false
50,Mark,Grant,2515778000,hubbardjames@example.org,fc753b69473a2290eaba06f55c0e039be4cb428211bfc8dc0edd5c71a3b1a25d,true
51,Brandon,Martinez,6535105248,nashjonathan@example.org,0bea5ab47f1fcd21185ece3748b3431269fb3179fe0eebaf27027127d64ef8e1,true
52,Kurt,Chandler,6636546951,cdavis@example.net,f54a20959fddcd517283aecf6ddb1e707074e74b59449bf8d8e8ebef92becad7,false
53,Madison,Perez,(898)535-4239,sboone@example.org,9ed9ace3a787d77b3c7b28906d90abbb9a450fb6dca385a388ff0a09eed87d21,false
54,Hannah,Hicks,456-787-3421,ramirezwalter@example.com,a7eaf9dd1228b4aad60720dfa1017b9a29093f90650b059d8dfdf6d763bb8b5d,true
55,Cynthia,Craig,(944)871-9871,nicholaswest@example.com,0121e405fbec5568494d8bca4174a736dad05e324ebfe80ee8b14bf181dbe5ff,false
56,Judith,Sellers,430-679-4149,phillip80@example.net,f77dd1fe9ae1a37b881f89451037b94deb7c000273708d050b5018fe4fd3dcb0,true
57,Bailey,Dunn,852-903-1243,franciscoclark@example.com,43c884e9c717859b93182da7f8eab93915a29b38d5a325106a6e4c36b64847e6,true
58,Chelsea,Miller,771-816-2178,ericalowe@example.org,a7a531e933a19d14e5f36eb6d418c71784fdcab193cb20a7d1978a9d07be1241,false
59,Adriana,Quinn,(933)662-4229,melissajennings@example.org,5b293e93021e297936a7852940de25486bc08eebe8175ed9c96a0c1c9b7f9ade,true
60,Travis,Walsh,657-640-9333,mikaylaholloway@example.net,c4e1668df2f74d4c9d481288f1dc5969c9be50de88e8dbcd6a2e2b97f3bb45ef,false
61,Yolanda,Allen,805-679-2051,hboyd@example.net,c954cf0b3a7d00d6b93c3bf8bd7b756e4d53f0d491b1cfedf24dc1a457ae00e6,false
62,Lance,Thomas,823-882-1084,fwagner@example.com,f28e52541b2809069cbe582a4c78e161a698121b4f3c1091226a63a530db3fe3,false
63,Shelley,Washington,(453)658-2140,charlesalvarez@example.org,b5d5481795b32f61529755343638f803cb294107de0514c4e5d683e4cce18684,false
64,Lindsey,Marshall,9208859709,zacharyfuller@example.org,d9aba079b4f614411999161c875b5bd868001a9f5002ae3bb15dca85c925c4bb,false
65,Melanie,Barton,6526578805,amassey@example.net,bbb7367db5482131ca61c22b3bf0e71fa64c72ec27aa25eadbbdb4a5cbc89ba8,false
66,Edward,Mercer,(291)388-4432,marie90@example.org,2eaf5a19e81b008b133ea4db6d4dbd05b20f2da59a642c0c2b5b0baa0c457d8c,false
67,Teresa,Obrien,(922)895-4931,tylerjohnson@example.net,439e8a1473aede9485bc0bab109a332c815485be18bf85171ae7653694bedab9,true
68,Julia,Baker,242-994-7645,mbaird@example.org,e66565bcae80927ca0074d64415685b598a4d7be9b7d51900be23e29dfb49d1e,false
69,Tonya,Alexander,(740)685-4105,danielskaren@example.net,0107a993f5451766ab8beb25600816f993b35d1b5d5a3abc73565d44f0720968,false
70,Michelle,Torres,946-671-7448,lharvey@example.com,9f82b2574b63a3800fda0a8ef0e56da1ac0f6925a8a973faa6b9c625bd4bbe00,false
71,Ana,Bruce,595-661-1614,prestonsamuel@example.net,d20faa99d35d6cb0891ee1f9a693aa726bacd7a32e863cd31609e6bb6661cf03,false
72,Samantha,Sexton,(873)384-4121,kaylaroberts@example.org,2269e50732ceaded3e608d74069211cabd71b6f546acbc24a6dc5b3f87118dbd,true
73,Luis,Gonzales,(310)860-8014,gsmith@example.net,5796912ca28209ec4c56ee46316edf981e7ea19d789faf28eca1c64ec4993a88,false
74,Frank,Sanders,4047718212,audreymunoz@example.org,c7bd19a3af20753dffd6a7a548f9977c23dded45aa286e2e1a160433ada884ed,false
75,Robert,Gibbs,967-698-9815,hgordon@example.org,fa9f14fdbbd0cab4e06d29749888f872029f66026b42b1d0499d7f82f6633120,true
76,Jessica,Petty,948-699-2987,dwalton@example.net,764c0a499bc67ca13afb4a2ee419ac9c201782d19751fe5b21da1d9eab588a78,true
77,Stephanie,Reyes,(855)636-7451,owallace@example.org,276f5e26a59caa4926654c88687fa642d70ea2b469e371d092da10ef3ebfb32b,true
78,Helen,Mcclure,362-295-0699,amy73@example.com,3ccb9dfe70b9288bd716a8c6fa4b0df87f3f55b04ed07b27ed18d9e24960848b,false
79,Nicolas,Chapman,953-615-6374,erica73@example.com,c392173fdba0b5f7c289e240ae5ef87f2b07b76a78a49fd5e7797ff3fc7b9e78,false
80,Nicole,Hughes,3827078209,mistyatkinson@example.com,5bfe05a42ba61b4516af404bcc3c5f15639c51dab2e3882f563e6b3d573de173,true
81,Jason,Owens,(697)945-8145,jacqueline98@example.com,56369c54e9e2a6e6da87a6a6e73784847252b984043b68d202e06fceed928e4b,false
82,Todd,Harrison,(850)901-7153,matthew78@example.net,19ed281294c344ea6338bd51a4a79fb2a6cace5d7415cefbbad9420a3a5a8412,false
83,Barry,Blake,(771)697-0083,glennwolf@example.org,300f9e21690c366787cda00029bb05bd1c51bc3595d8c0d42d62e17f661e2cf0,true
84,Mark,Jones,459-850-6117,allenbrianna@example.com,2cd1d6f5001e1008d305beee59ce827080385989c412e574ddb40a206b8ba70d,false
85,Stephen,Alvarez,278-494-4677,wyates@example.org,6b1bb124ef5f43bcb36a4f54972ffefff81f65d0dbb3384482a68032a3102ff9,false
86,Aaron,Webb,451-464-3369,samuel08@example.org,8f87ad4e3f116aac6d183c0eab0c1053a261b61cf1c56d2e98c6b3715cfa7203,false
87,Lisa,Davis,356-389-5979,brandonperry@example.com,bc8260f7aa4477ceadfe444d3c7bf8a6d70582086aedeac948f483e6b6e12888,false
88,Jonathan,Snow,6795291323,handerson@example.com,9ca08bced3e452fb32d5212c77a2b2ffc7ccc91b81de5af17b1bbc766eee750a,true
89,Ariana,Reid,2222600933,amccarthy@example.org,b19b10bcdbc57589b379b640a05fac7c6344c251d9d829377f5c2aaad8067db5,false
90,Jennifer,Simpson,8458472907,martinezjason@example.org,9a4667bf78ac28832131a4524d3e640569817a548d93c8033c053bbb281eddc1,false
91,Maria,Gibbs,(625)409-8477,jacqueline80@example.com,5ec9dd010197c5bff7e245bcb332190388b548375611eb2864d109307863c8fd,false
92,Robert,Weaver,886-291-1473,natashadickson@example.org,7aa18afff7001b6e7bf168972ad894830bea3213b440ff208e24a3112e7e260e,false
93,Jose,Walker,6792026610,brownkevin@example.org,673fdf1381b37b243ee6735c16bd70eec44878ad19f65d3023940d4e87a275bc,false
94,Eddie,Sanchez,4183833290,bradyjessica@example.org,9b69e6e372e70c3348bc1654479a653e1100947571765e4df05276f4e99eeeb3,false
95,Michael,Richardson,(597)560-7194,valerie85@example.org,9be0aefeb29beb25d106731a128cfab8c1e7b736932f47a32d52021d08b60b8b,false
96,Joanna,Smith,(490)934-3998,gmoore@example.com,c4bd0bb5d874b316d68628ee6b73f8fce6af8ea8457b1810433a8245ff1919a5,false
97,Briana,Park,327-230-3776,rebeccajohnson@example.com,51647dc1510a2ab5bc8c16c915e5798110bf35a7ad2135ea4a261a2d147def27,false
98,Dan,Cortez,767-845-1925,harveycharles@example.com,00a1f440928dbc5dce7b60de449881be8ca78e957c0e44bbbd18faa586d0b207,true
99,Thomas,Higgins,691-565-1673,kevin46@example.net,d7c7b45962450e8e20a7e08300d4c7fc7767eb616fa383deb4c1cbea248a67bc,true
100,Christine,Moreno,5742648279,dixonmichael@example.com,5b05e36d1233aa05b6f9de95bc3603602c9281ffef50bb4989701fa9288fde30,false
101,John,Oconnell,4395227985,tcarter@example.com,50ba423ab5a4558cb1607036420014be353a4c2b9c625f355c19ee610d45a48a,false
102,Jamie,Owens,6819858168,mooremorgan@example.net,02a55de3f3bc0dc0832302fa3ba56118cd15845c3005dfb956e6448a9368b042,true
103,Sherry,Brown,674-386-1631,qlee@example.net,3ee424e3b5c5b6c138c34a6655a7bae1b932c35e1a7a4bfef7f7b51ea33ce367,false
104,Joseph,Morse,3056469832,olamb@example.org,b49a04760d53aa38340edfaeebfe0a0d7117c6e3f24dd4708eb767bfeaa12b72,false
105,Kevin,Hardy,(978)534-5280,griffinsamuel@example.net,fcac8de684bb36423ccf273f94d734d053398cb07f4664262ca93224d9966932,true
106,Megan,Copeland,4794829758,fbradshaw@example.org,eac7454fa2df5882575ddf3c7b6d9b0829e585217cfffc7914dc4646e3aed59a,false
107,Kristen,Savage,7186876035,singletonmiguel@example.net,c217b6083ee0b0da638f683873e423fca1a948e204d66666349efdbc2300f619,false
108,Michael,Moore,3233106099,seanmyers@example.com,c0dc7c347f144f5452babbeca26a63e32470feacf8233b993798e8741912cd27,false
109,Todd,Castillo,7994240771,yobrien@example.org,4922e6c252a4ab3cb624a0d73a4fdaa20b9c3a6a050d23777bdffb2cf5f2ce31,false
110,Bruce,Barnes,8382432309,thompsonrenee@example.org,fb03e40d7e01ec1d2f981a8413ffbe0a9c382a662cec9fa93861107522fcebb9,false
111,John,Phillips,6567955277,crystal36@example.com,38dfabe7457014113cb6d32c38dd7dc9548d864768ec00fa812507a49912a57b,false
112,Kristen,Collins,(244)575-2078,michelle27@example.org,2019c6e95e2946e838bf5e441a19ec4d5b327257fe1ccddf79c6897e3b984d7b,false
113,Courtney,Lopez,(431)675-5983,charles43@example.net,76a222634006133465421f604becd7de1a4f1ba463a267f68e22074d948517a4,false
114,Jerome,Hill,4626551520,kristyavila@example.org,b6ecc5a0fa0da7d9712640926cda0709ba67fe8c34c53a97f722671aa9075c99,false
115,Amanda,Alexander,537-753-7242,tina44@example.net,828abb573b562c18f3f7ad0c211dc15df6dc03890a5b4a3d03be80c85221b57f,true
116,Andrew,Jacobs,325-593-6947,cshaffer@example.com,2a4f33f5ebd84343af11c8d1cf1698ffd93b17db68b9441161440cf41ed50999,false
117,Timothy,King,9819663734,coxjennifer@example.com,e91075b9c69cbe3a4d177e1d5c902726b4583824c47f6197edf9547cac73e47e,false
118,David,Allen,963-912-9532,chanbarbara@example.org,404a5e3f61671fd73e1f03efb589bec8e8d1d84178ecb6b3c7164e7fcfd779e9,false
119,Amy,Ochoa,9304472378,tannervincent@example.net,afc1f2ae4e520a228acb2e07acd0af3c6c7befbe82eea1678831adb6b29ba51c,false
120,Adam,Cooper,3787094214,evelynwhite@example.net,bae253679d39cfceca57dc6bada0aa1c65a111d1248056f4a9a1051d00a139f9,true
121,Michael,Reed,5025672187,sheiladeleon@example.org,7e8df6022a8742c5d293f4c16a85ef062ede4371e35b8078dcad407f35092ccf,false
122,Christopher,Watkins,(581)803-5566,lewissamuel@example.net,db50590d35926f7b2e25992934d911ca66984650d11801d7f0a97dfe08a12ed1,false
123,Jasmine,Graham,(706)606-7868,vsmith@example.org,704708b6a80f025ee6182276e64713754b980c05fac6c65f9531c65ad8a882dd,false
124,Jennifer,Alexander,8139410141,kellyjoy@example.org,bdfcea35292fbc28dee7876204fdeef180137a466677097e4cc9033d3bb89ddb,false
125,Felicia,Medina,(856)466-2574,liupeggy@example.org,bc8037ab7de5b6ca8245edfda5aad8799089b743911b29e561633aadcfe484bf,false
126,Evan,Joseph,904-941-7636,amy31@example.com,e9484144fc6b1589c8b29d86dee2029d39256b7ec19ddeeeef7d6a2608f56629,false
127,Joseph,Thomas,(392)973-8463,uvalenzuela@example.org,24a9efd98a756196b63b0c2a8b11b27b1a64a2709018877aef3d8ce02dbc3086,false
128,Mark,Brown,6104887308,johnwatson@example.org,34f2f86aad87362a66a37b2e3a7301bb2d3d72761cecd1199d7f774b1ad55f71,false
129,Megan,Ruiz,8723838401,amy84@example.com,992edbcf8754cf6ff2d99214e208ff17fe00ba79d0470f36b4d1d40db785d77d,false
130,Jose,Torres,(354)487-4217,mccallwillie@example.net,a5646191565ba5f565b1ab38d8f6bf72489a4487ad069587352972952b46f7b4,false
131,Melinda,Hunt,7433454507,kristyromero@example.org,3109e2ffbac7acaf8531362d247f90302e188c590a733b7fc43208389275993e,false
132,Douglas,Rojas,8812541447,ufry@example.com,e3a885e4334686c4325b56309d88e12413ad78dda796e24c141fa7d267432794,false
133,Ricardo,Phillips,828-982-3310,mday@example.net,f956f00dcc3d6f2ec3cce3b7d963b9f23ac2fb81394c1617607578b448082b27,false
134,Thomas,Lane,7684911659,randy50@example.com,183f81a83fb25d7de3c124ee4155981737318c86ecdacfac5da723c421d2ae0b,false
135,Michael,Thompson,922-380-4885,alicia69@example.com,d276ab29103084e8dd0d49822422fe47613c61f12da609582fd0c33271c49a3a,false
136,Cameron,Jenkins,500-485-5794,phillipmiller@example.org,2f125731bb0bee51b771a6a3d1275b36578df8ddb505a9cc5dd1805a966da7f7,false
137,Thomas,Miller,8637513357,michael85@example.org,60cf1930b3a804b8315614172a3bb57404e5cb9e293481a35aa16790b46235b0,false
138,Morgan,Atkins,(889)559-8924,sylviajones@example.org,874ce23940abf043bb92f18dc8a906f27d9986b8bd2a9ba3966dccf3cab81e4a,true
139,Shannon,Jones,934-702-5971,lmcdonald@example.com,0e0a1ac250288de64376856ecc32b486c980a3923530efa901168fb0ac1337a3,false
140,Christopher,Kennedy,(272)918-0808,dgonzalez@example.org,54de5950233cc25d16cb4927ca6454d05e8b6da94c10f884e02e144d41bdddf9,false
141,Brandi,Flores,519-204-5563,gary90@example.com,e68d43b2c8a455dbf9d2ea19d20e857fd84e549d62f2319316db796cd1fc745b,false
142,Joshua,Williams,3852424310,icardenas@example.com,555549021e40e6e7a21932edd63006945bc4d20c6361df7351cdfcb02534d31c,false
143,Jason,Lozano,6834351261,danielwilkins@example.org,3cc03b782d534cd1067a907e20bc8e1c05ad9b0ca29d5216cb926719ffea1efe,false
144,Beth,Brown,5705418980,melissa21@example.org,fccc62f49b2c8267352b7259ccf0b02f4d116a97156dbefcc2e0cf0a408711f2,false
145,Joshua,Warren,5548957929,pamela42@example.com,a3a1186369c7b390135d25bd009687af45b1ca0fe8798d2192d3251eff8ca443,false
146,Janice,Garcia,(697)345-3125,dhahn@example.net,11290c0cc3f98292fc6bd5c64055a49eb3bf5f1a59c0c2931fe1549a53fe16e8,false
147,Thomas,Jackson,8589476122,wbaker@example.com,4133b8f56defce01370baae350a5cbeee4fd20a462ce678587d823b2de3ae87d,true
148,Daniel,Morris,919-491-3906,matthewstephenson@example.org,bbd5456fb2983f8e681e52f124b5acd982d054ebf04007a301cdf733226e0e60,false
149,Robert,Marquez,6286742133,willie97@example.com,2d25ebaa3db154a59deaadfc997b3a98be21e742aadee60d7ce7efc52315616e,false
150,Robert,Sherman,(853)397-9147,michelleherrera@example.org,f1702497d997d4ada92e71f54b85e03d9cb18440cb70f16bf5175c8f4c50592f,false
151,Jennifer,Morales,6823155659,stephengomez@example.org,94f90697785bb321e80f17d78e27875291ccd20df87de5a1a83351303b6553d9,false
152,Caitlyn,Burgess,(510)695-5704,bwerner@example.org,ac0157aa0aca48b539055a5608c66a90100f0c58486dfd195ca2d93954a840e1,false
153,Neil,Black,369-249-8680,ksmith@example.net,ac66a5cabd55cefe89cb21eacc589bd767124b847e31f38ee5d85c0829aa2d31,false
154,Kimberly,Harris,419-255-4574,danielmorris@example.com,924c5017ba61b7e1723bfa92ff058dad9ca2d7ba3ec7c9b99e1439984a5df321,false
155,Troy,Williams,(618)393-5521,cristinapayne@example.net,6ae79d805b50271d3cc0ceee21b3e381cf083c947afd71db2277b988d8429188,true
156,Rebecca,Yates,(767)294-4291,willie76@example.com,bd02af3c2ee28f7c54384f2610b41cc9d3332e7c534ae6f20f3547be50f8a2e5,false
157,William,Smith,301-827-5502,richlisa@example.net,ae8bbf1e9c161afce0c08b7f94c1543cd3696e821626842730710e1ca59b3ec1,false
158,Adam,Reynolds,3052170341,carrie09@example.net,f7e0b02af7b95d63f3d9a16f50be3f0f18f27bc12c908a993fcdd7ac25cd3d10,true
159,Michele,Ross,990-227-4463,yjackson@example.org,132d877b6af247b559b2987f38669e32a726cb389ee17a22cddc7227d3c4fdc7,false
160,Nicole,Wood,728-751-3594,lauren06@example.org,22cf327bb3f7950ec4cb6cab19e50d53b78a74933d4bfff5b2cb12fc1001e62c,true
161,Jonathan,Burnett,4518571405,garzalarry@example.org,7b98eab8a2715d521f5e86aec0349c41aa0b64bfb9c4b53268eb07b3b33cf04f,false
162,Susan,Parker,(553)223-7236,karenmartinez@example.com,fd6dd1cea6d4583c788e0897803356bacc4ae36c07e0fdd7f26b0b1de0bff423,false
163,Michael,Howell,592-352-0429,sophia02@example.org,cb592f8a63139d8b03d55d87484789a318c50454f222645eb020647cf75e8e91,false
164,Tiffany,Frank,(532)324-2806,obrienmanuel@example.org,1e5bae32f008f57990d7c4cedb390263aedf286b720b3d58cc555dd6eb1d26b4,false
165,Cheryl,Rodriguez,(726)964-9563,johnsoncourtney@example.org,36e593a3c2a63230add24b70755d1d163ffeeec995a72713872dd6ca6da48b91,false
166,Raymond,Edwards,3709955006,daniel36@example.net,0b2ca0fde405ecb38ba3143393e620c00a447edd5d22d89541acd6e65016116f,false
167,Colin,Gates,722-429-5757,russellwilliams@example.org,34e2082caf81e7af7b0fefa9fd6e0f315e02dcdd4aba93270c857215eede368c,false
168,Eddie,Gomez,(962)357-0101,jeremy66@example.net,e9baa691dfe48842b558ba092ca8f298041a8e4d13d09096d7dee15882d817c9,false
169,Robert,Simmons,902-700-9354,anthonywilson@example.net,03d193063edeee1e2e0936e4ef0e846db8903618310904ba4191b628e210cf62,false
170,Carlos,Porter,8289676899,mcintyreheather@example.com,d2aa798f74c86e8fbed83df893651dbe761b47d45f0efda854e05b8af13f6857,false
171,Tracey,Kelly,3447167271,dennisshaw@example.org,3c6a7e16f6f54e55fe81fe5aa8642ec1d7b18892740986b0b83efb37afe9cb74,false
172,Linda,Burke,(892)291-1239,gutierrezandrea@example.org,91e91d57378e0834a9c78b5c5ba36c8459aa1b5cb0d346a1d8cfe79482601845,false
173,Ricky,Knapp,(247)788-8829,jennifer36@example.com,d5733c3f3fc834526d85e0e2073a66a223b5ed56d4b4ce1acd4a8bff2c9495ec,false
174,John,Sandoval,528-981-4361,david48@example.com,c99d6efb1e20359f787a66dfdf0b2247ee99f767c8113ab6d50ed93daa0f6b49,false
175,Todd,Harvey,(219)684-2822,ggallagher@example.com,188601d84680f5475d73a353741c4bef7a433069d940aa0c5eef302d2bc333bc,false
176,Robert,Brown,839-817-5561,csanchez@example.net,244404929599ee70dfe11421142954c3fe55c0bc054811e60677f65267b7a14d,false
177,Amber,Davenport,817-731-6808,millerlisa@example.org,db069ffbbfa3a287fccd2195870d2b36339a96115fddbcfd2e989b77272633f2,true
178,Latoya,Leon,3144951949,wcross@example.net,1ed79ec60513600d0fc72ead6c4042616bfb5c24bf8ba82dbfc60785f136b075,true
179,Edward,Arellano,957-936-0051,michaeljohnson@example.net,e1a2fb8b0dedfee25af7f5f9b45681417e461a0bdc023251f199d1ff488a88a9,false
180,Misty,Coleman,(420)999-4037,staceyallen@example.org,4952cc45d61819e38936b0faa3d7d0cc33beec402144a93cad707e2ae53d9a8f,false
181,Jason,Jones,(338)257-8667,froach@example.com,10d22dcc66e2822225d96bf746cafcc4ba095d31958a51c11483236fb8344083,false
182,Elizabeth,Bartlett,5034295225,andrewwillis@example.org,ac795c704992a31bc7f48680f73a491f70e5a11f80fcf94626f1f694c26b62f0,false
183,Stephanie,Wood,4336035352,jack51@example.net,eb69d5440bd2cf92d99486569c0f9c56df92b113cbf3320339daf344f9a28a6e,false
184,Leon,Ellis,217-709-5886,hedwards@example.com,b8c88e30c259df1c418b00474374b6932ad21474d1c2952a86cd2d607200d651,false
185,Daniel,Chavez,891-864-8888,justin56@example.org,afa2e625861ba488da5514c4e0145d8c0cccd4ff7654be6b80ee4be097d321b1,false
186,Morgan,Schaefer,8359541401,wdeleon@example.org,335a21eb317e8ab027c20dcb471f04534fcce78a180c013b909b19d7e37c96bf,false
187,Justin,Kirk,(241)589-6452,jessicaperez@example.com,c430f7cc74835afd1d2cb4984b9f5a9d461b2de41555f9be86ae5dbe558a442e,false
188,Carrie,Kelley,688-656-2804,padillaamy@example.net,68ecee6dc93a4e682351317b4abcb5841f5bbfb05d286aa2dbc7cd201ea2a01f,false
189,Jessica,Harvey,9067533893,sarahsantana@example.com,d76766f66c8a2e8c11b2aa0b879645bd7e2196efb71e9955cb9df40f316a8d46,false
190,Renee,Miller,2078674124,jennifer40@example.net,cf5ace878ed5c785e1c9a60cfb728469a7fce59c4017edf0ea91c97f5dd33173,false
191,Jason,Thomas,772-323-9311,darlene24@example.net,fe6b19e101be64edc07798338f35c4df25bd9d8051a45f906b8fe39ddbef86e8,false
192,Stephanie,Manning,3892945108,johnsonsandra@example.org,cc25fe43a6ec2c4d1a6f8d09ebceab345e7e4a45b68bc245c2eded5e1ce33dab,true
193,Brandon,Scott,784-206-8235,michelle52@example.net,0a971db7099759ff1ae65258cc281b7ecb626116625e1604c443693381e0e722,false
194,Jason,Carr,387-600-0233,carrie72@example.net,1ca17bd35260c4b6e8c236b07c5d7def4d7111d639ddc1798ea38115b87cfcec,true
195,Pamela,Lopez,(950)815-3665,tracy45@example.org,8bbe265b1d48c1a08bf71af00bfe4c0924b443a30aa9d6d69d14b92e7ec24691,false
196,Melissa,Hogan,3947089863,wford@example.net,7b4ae48fc6fde5ff2203c08927ae6f5bcb518e532c9ee803eead390fa0f084e4,false
197,Timothy,Marsh,7127132146,lindsey53@example.org,3ab44a735fd4c2fcf92888acb49d2bed1ce3ba606bb8b9f87d1aad4ade8a71f1,true
198,Steven,Daniels,727-338-9676,simmonsbrittney@example.com,96e74ea3b0af7ecf90726e846ccb0304e63e9840200f12ce89b69e662a052935,false
199,Sabrina,Glover,3415524394,clarkemily@example.com,7b2bdd96a150ad9abc51153c3348cbd4264042ce1302100a56822ad31e0b5f6a,false
200,Elizabeth,Patel,924-516-4850,george30@example.net,6d3db8dc1a9e4ce3d5327a666df128d3c942ca5662fd68f9332d40da976eb7ad,false
201,Helen,Jackson,769-964-3425,princecatherine@example.com,198a3d04c10de9203626712e05855e931bb8e697a8eb4d6d95206b63e2d5e45e,true
202,Tommy,Decker,8735948254,david61@example.com,453584c28c25aa9664b5f16ce842716267e547c9861499f12c07a377397792c1,false
203,Jennifer,Bates,214-229-5340,stephanie42@example.com,6ec6f35d917dd3c3e42c4bde67f9e91b50b0f67b8a8f22a428e91a44cb5bcaaf,true
204,Michael,West,(214)961-8285,michaellucas@example.net,d892566abbf7e90377e47fd6e0989318a047590a45fe4f8ac12288173cab15b6,false
205,David,Miller,(974)376-8463,sean07@example.org,c8c5f514a40dff0d38940a2b125586005710149b0000e6d4fc89bc6c86509636,false
206,Jason,Johnson,(831)972-6858,michael38@example.net,b7389b52a0c3a8feaad41d591c5c3cd15390e66368d6903a5fb5b23e9a045d24,false
207,Trevor,Chase,(590)252-7687,ksullivan@example.com,ee7f2e3fd7db8da25fac121c71559e5bd2ff186e5ee8a1ff03be415393f48312,true
208,Luke,Mills,9846416356,jeffrey64@example.org,77db0ad8900af629c182d8460ff90e71dae7001acb22bf6121c49dc2d9399da6,false
209,Stephen,Porter,874-986-1429,martha11@example.net,11b85eda7e775df381b0e814986e35db57713f622ac8a1694483c201b4ba3888,false
210,William,Simmons,(410)774-6369,davissandra@example.net,fcc9178a68c23ba7c5068c67be1f5039e394d637dd6816d4dfa27360db596416,false
211,Jasmine,Jackson,911-950-9194,victorwilson@example.org,1512097f29c03b8a7fda5fb00031f2c3b54d282cff07bfe4ad399226444c5ad7,true
212,Jay,Rodriguez,245-487-7215,paulharmon@example.org,9ced432b05b61d14a8335b9ee3e425417d4d6baca1f03e6cb58a73bf49aa621a,false
213,Steven,Johnson,(937)538-4979,kennethhutchinson@example.org,5b824294e277fd73afe0d9a43053d48879bd83cdf1296bb746bdeb385af8cce4,false
214,Heidi,Guerra,281-423-6248,ygood@example.net,940cbb2bb0f683bbd11691e0904c9b523e95ad8745a52ff6d2ffd87d50d77a44,true
215,Chad,Sullivan,(571)466-9072,pattonelizabeth@example.net,d1ba79e33d82451ac8e815fa4f920ad1f95737574af1274a0de117066321f644,false
216,Lisa,Martin,(281)471-5278,irobinson@example.net,66ed0ca4686e1f9e8d6187323237df71a8bfeabd495339027930c1c301282ded,false
217,Lisa,Carter,3074126902,gcampbell@example.net,58f2fe1915b6418dbede88302fad4989f3608b92132c82b5f0bcc9c65959a217,false
218,Rodney,Hall,442-559-3560,mathisdevin@example.org,7687d8a904446c8844a6c2662dd2160bfd657056b99b5060e0f1170f55a403e6,false
219,Timothy,Walker,(990)626-1708,frankwilliams@example.net,7392c2eb7016946cfe94da24285a1b0d7e116b920b721e7c3d043b0bc524af42,false
220,Katelyn,Brewer,2929729556,jacobsrobert@example.org,17a3e4342e4020da2a1b68a8b3bac2f65caf0729a64cb3273bcafa375ff1f8b1,false
221,Collin,Lee,8914227199,npeters@example.org,d96a7f9fd476b3371d35b68a85a50a13688be9f9c5fbc4cdd0adb5571a04042d,false
222,Kristi,Meyer,679-439-1109,christopher73@example.org,8a9797c837c3bcfefe5b8b3d128d6c6f62066766362dbb692bae48d683511f31,true
223,Jose,Frey,7095270030,imalone@example.net,6d1fafbeda5eb465974532ad26040a47952ab06079c99d531ad7015a050c2824,true
224,Katherine,Davis,(210)974-7143,fhart@example.net,e73593084db334de396915cadc69f125e2e074632fa188d7ab1e96e3120fb480,false
225,John,Chambers,(306)343-0573,aarondavis@example.net,9b1354bac35f9d83191f120cc75e50a17fb1bd7679b1728dd1a5f56d7a4c75ae,false
226,Nicole,Dunn,440-338-9666,njames@example.net,4eba637f08528bb169a75e1f4781163b7b4080af5752d6ce7d868ebf83495aeb,false
227,Jennifer,Bailey,(309)311-4158,kristenwu@example.net,8673315a13349c134ae587436bcd82e5f3749ca847217f14da6828f7cd2cb7ed,false
228,Ashley,Davila,(255)621-0557,sarah06@example.net,820be90dbcfdc01654f917ab53a65a1c0ec7f6c611eef26fd6f2b40b1c767d4e,false
229,Julie,Jackson,(446)346-0446,leslie00@example.org,79804b3270208435f5eba1d47108556931b167aa66db903d4ac61316ddb89599,false
230,Laura,Brown,(597)433-9838,stacy56@example.com,255000399fa8fbcb265af1d2866353bd30b6007c6586eefdcf76801d509e6927,false
231,Kyle,Smith,7242701453,robertelliott@example.com,a5cea1528ac89bb9b795977e9899cda1ade915e149fea1bbff140c93a1bea67d,false
232,Mary,Gonzales,(261)235-5514,rjones@example.net,2aa97c38fa6915b175827d364240b32896d81c88a1451ce24350e444d3e5fc27,false
233,Erica,Rivera,(278)525-0236,patriciasullivan@example.com,25fab9619b4855bcceef68323b3e561577dce3b54146b052ef2df772756cb2e1,false
234,Patricia,Olson,8673969670,amy10@example.net,d553d33076a17e2ed29fa626572e8bb924448bdf6e45e9bd7bec76fe7c509a69,false
235,Christian,Price,(699)660-1782,hunter70@example.com,eac068d588bd63e2c46e062b8f77c4a300ded8cd7e815e07d56daecd43e1d66e,false
236,Brenda,Padilla,7564257910,paulsmith@example.com,3d8ba27d4540ca120cc68427385bcd0fa6025910f02e459c2153dd5cff1e0c21,false
237,Frank,Jacobs,396-949-7696,victoriawagner@example.net,b7a5f8eb02a3b21a54ae4036e2cbe27741b19c655402c6d08cce0d31a0bebe7e,false
238,Barry,Morrow,252-405-2405,travisroberts@example.net,991e13320d687d340671efb9344f8b18611c0402c9145e7e058a61a022e0aab5,false
239,Mary,Sanchez,(718)403-6321,armstrongcole@example.net,f7d6a998dd843280bd97369b478c853490864b044786a40d11ddbf44b15f888c,true
240,Chad,Baker,553-627-8241,ericwilliams@example.net,f54520f50c488c8316de5af030687b6772034bf8c0129daa708409023a613612,false
241,Francis,Lopez,7422625715,evanswayne@example.com,667b37efab4807c41231f6171b63a322e07ddb248ba7cf95aa9b3ce178fdf1e6,false
242,Kent,Alvarado,375-693-0942,aaron24@example.com,b5941807e934acd5223e5a15517683c6f73db0e25b240545fa553bb8c48b5ac3,false
243,Rodney,Campbell,854-362-3818,nmcguire@example.org,0608b782576fadf0a10b2399329c702a1f73731347bc4ec0e2d13cb975aa1a78,false
244,Aaron,Dominguez,7525855598,rosariojanice@example.org,74ece614b2879687bde7ef232d1119caa0c77db4438cbf8912e1ebf46fbad212,true
245,Ronald,Miles,9954919830,desiree28@example.net,de6ccb04978d0500e7cef57151f6b69ff4cc46dcf20503054dbfe349f3cd6d40,false
246,Tracey,Krause,435-689-5240,kanejustin@example.com,19c5d3640cd61ed6c569f380350907139ce0fae30fdbf702ca3e1ac413d4fb5f,false
247,Mark,Walsh,(550)424-1268,wooddanielle@example.org,9128f5b4c816ea8362eb851f9e9ad9048b70ef0ff4b919d9c9b7f69ca40bebe0,false
248,Joseph,Smith,(313)863-6743,wongtara@example.net,b98d9f798985ebc9bcfdda3b35dd16a5ee882fd7ce615167cd60c08d61abb492,false
249,Terry,Diaz,651-829-1472,ashley08@example.net,b91fa1515f917668c5dc88dd0e6470efaf15e2159594760e8811ea9b6f11a1ac,false
250,Kathryn,Salinas,411-700-3523,jon80@example.org,c4c920e95a73240ae6be4cd12a5f93c49ebd388cdd6852bd07468d1597568332,false
251,Debbie,Ramirez,670-279-7474,hollandmichelle@example.net,d3b973dab09fc367372bb2e62fc9c183e1fbd551413a87ac9d7eabd94495ba2e,false
252,Stacy,Thomas,(749)485-2331,fdaniels@example.com,e538b5b41dabe6075957cecd4905561b59047d8dc0d253a0a53e97169115d5c0,false
253,John,Barnes,(784)660-9288,stonesean@example.net,a324cd5e3289d7419877deb15ab0e1cf8f73636bb1be66d116163ee11279894a,false
254,Joseph,Doyle,(717)551-1378,zhuber@example.org,2e415876dda55355099c222230260c0fc40af84329bef3f97a98b8b5892f6b3a,false
255,William,Cunningham,325-219-1987,jennifer34@example.com,f65fc91e16a2bdcf862b881c3c50d6d97ad68c2b74e2f8e4ea82b1660d084be7,false
256,Mike,Sawyer,2067597166,mhuffman@example.com,4e2fd5a94d6d2bbf5e6028c086f7bba076c9f961306b152139f687725b714b4e,false
257,Jose,Pacheco,370-460-7478,jasmine61@example.org,ab5ec502d48f9f83315e0053cb9cce68bf091f5fd745ba538e0ce10d90d984eb,true
258,Ronald,Rodriguez,3862337565,brian06@example.com,2ada5060ee34ae1367f635bd7a664217bf98bb0326aa71109c9c11e0e7988f18,false
259,Austin,Andrews,(382)219-4172,ysloan@example.org,a26ce3b19df8ed70b238b8d5438658485dccab7d01588c7232154c1f01175412,true
260,Wendy,Brown,(265)833-0642,thompsonjohn@example.net,5975d3a8de2e6635f5e3b47d2b1bc0bb0e9b2f45ff03a5ef4b0100b0bb12251b,false
261,Michael,Byrd,4484367954,pherrera@example.org,a3e83f07b752d76dfd782a387cbc2cf4cacfb8668f53a4d6c0f62580f6cc7d56,false
262,David,Turner,211-876-4592,luis50@example.com,9cabc0376f5bd87b6121b397613030cd32a5e01a2d46bb0b1ca551b38fcbffc6,false
263,John,Walker,568-556-3693,angelagarcia@example.org,6b9c20b757c97546328d0168ff77327b9ac6eb325ba4b7958ad1a54fe2a0daeb,false
264,Devon,Anderson,(870)424-6665,stacywhite@example.net,d84b6e05482954eab4f0f7ddf0e7218729b7b629a66233cb3404cb6b1f4ad0be,false
265,Brandon,Farley,5756120760,nicole39@example.com,47485d478d8b63ec0c59413a100233951088d8749a0638abbf8df66835108241,false
266,Tammy,Washington,9253422771,hartstephanie@example.net,b1022992a453a341a5949849ba3ab9aadf4d0b64231f67df9782e3f08150065d,false
267,Charles,Carroll,609-543-9916,carlsonjeffrey@example.org,aeb1c8eace4e138b50673cc34a6c742bfc9a9580396bbed1211b5d738e288794,false
268,Caitlin,English,(437)887-7714,halldwayne@example.com,bb039d2a68310d69f30bc3e2271b216556ee73e1d8a6a9035c47cf9011fa097f,false
269,Adrian,Zamora,2849245001,pcain@example.com,4ff61039fde8a49a27bd172b1d845eec5e4a621b13efb1d8d04d6cfcd927764c,false
270,Vicki,Montgomery,(853)747-9817,harrisrebekah@example.com,f2ff499ff705418a3d4aa70a6e55458b9bc9be167f225f2132a108b8437df0dd,true
271,Spencer,Archer,(367)342-6668,hollandrobert@example.net,1fe6cae6dc100449898ba4544f287a9cca1700e4e5fa0e8406d4c761e1fdabe6,false
272,Joan,Myers,432-331-6422,pmahoney@example.com,921e55ebe5b8e173d8fb3d641096a1cd727d18508e2396900dc4292504d1ea2a,false
273,Edward,Lambert,2387373716,bethany15@example.com,7449c3fcfea37c0cf3c1c4315a879e8e74cc53308155b3553bfb945c99ff0a6a,false
274,Sara,Ferguson,(890)514-7111,jacksondalton@example.com,0c375e0a11074ab989760c3722e9c41a1b3c8b80db6f15ad837026a3c044196e,true
275,Anthony,Davis,974-438-5223,lgreen@example.com,65a5eb8c3c898e7e3e4f02d4f2d80b554e9da53d1c45b648f0337792e9958bb9,true
276,Justin,Oliver,903-689-1125,wallacedustin@example.com,cacf505fa60ecd7cd6ee868c436001368ee2dfd8fbd9073b61b7d32e43714a3a,false
277,Jason,Reyes,650-825-3565,nolankenneth@example.org,26c1e7fd8b3cef3eb2ef6108a6b5358dfaf2c7c1b0e83351acd1bae7fb7c1abb,false
278,Patricia,Santos,903-241-0857,jsanchez@example.net,251dcf5c68bdeea5908fb9d8a56bdcdb7f64fec1cc0bf08746e70b2c826c602d,true
279,Benjamin,Robles,734-413-4272,mprice@example.org,4bff0c5f25616512aaccca0d3dda8b3a6fe47d861f6348279a6aefc82f3662fb,false
280,Christopher,James,(682)709-4735,johnjohnson@example.org,9685171f38ec1dabf52b6edffe282cba540efa7c093cfabd1399015a59f96892,false
281,Joseph,Matthews,8026093698,joycebarnes@example.com,dae4a1a516642df7954602dece6fde221cdcceac7a1f4580d886ab020a0359b5,false
282,Andrea,Adams,5783773934,brownstephanie@example.com,77066e87a03bce76c99f62ae2e7c47d4ca3c6434c03d668e17481483d86e658a,false
283,Shannon,Maddox,8286157009,greenekimberly@example.org,deaa5a8c0338e7d4f51b7b53930f63ab99439079863fdecf55cf7cfb5a0fb8a5,true
284,Benjamin,Flores,9658539250,yjenkins@example.com,3b4466979c7fb792c218d9cd22e1fb3d1585eacd96f8da01c32ce5ad78e92932,false
285,Benjamin,Perez,(341)581-7816,bhoward@example.org,bca68922610ed8236b7f09828a5dc033fa40001779e9c1cf5db4b8f077872e9e,false
286,Ryan,Lewis,672-527-9594,heather19@example.com,b94cb6e952f0dc28b326a1d11d9ab4667372497ff5f2c34ed13bbcb527406e0e,false
287,Christopher,Spence,896-980-1965,edwardsbrittany@example.org,c0f1d3e694af79af87973fb017641411638b56c6a4fa4a48be35e24b2c7b3c7c,false
288,Craig,Griffin,(642)328-3455,kimbradford@example.org,8f198d6ed93ae6432d25779530263c1af8c020af986500642eab86802d73d1a0,true
289,Antonio,Smith,6067353160,karenbray@example.org,ef7f316dfb96e33af7984e3cd6c170ca441c45ddcbac396ec79c7ee081f845ce,false
290,Donald,Sullivan,(841)996-1806,lhill@example.net,55aa7f104e3cf716d7c468321725b9b687435eb7a1b0f7ccbad7e8257119ff98,false
291,Nathan,Thompson,374-293-4369,bblack@example.net,d6e691f86832519db789fa780c1f74c4e13f957cc56436170d7d8c89dab8f8a1,false
292,Tammy,Miller,(399)439-7680,maddenjillian@example.com,6527de154b38837481424f59c67e92eb176d2bb610cf849c4fa68c4295d40182,true
293,Monica,Stewart,675-306-4657,gina08@example.com,c3dac1ea7c6b4ff9f60a2d46929cbd4e3aaddf050f701aedb943509371b95e86,false
294,Charles,Li,(788)457-2828,jennifer29@example.org,bd0bd23c75573b2b9103a4c7f758bcd34495aa8901f2e0f718a0fe1b773533a3,true
295,Maria,Brock,3408518194,rjames@example.org,021537f8a6e864318a56705d1976ebd00cbdb39ef49d6535bd79efd4055991ae,false
296,Ryan,Davis,206-216-2177,peterperez@example.com,ec447ec1189507daf91f77bfedc9a0e70806c4ef27d8740e6243bb95d979a93e,false
297,Nicholas,Sanders,(296)774-4931,wduran@example.com,941fa87fc4949beeca86a86f9b8d81b90a4483cea70300aea7f9f893fa1b2d8c,false
298,Carrie,Winters,996-874-4267,abigailchen@example.net,f759499273440a36da47d00f7a4ca3ce9571e5a84fb26699177fcfa4b995aaae,false
299,Jennifer,Leblanc,6416678703,jennapowell@example.net,55357b811298d48916a4c31a41e5071692e343432631e1ad1f705205ef78d9c4,false
300,Harold,Hunt,(306)650-6768,michaelscott@example.com,551cebbfe8f0c26e4572c0791872bab72e5bd0230d17ddefc7161b075699ad60,false
301,Taylor,Branch,8827379203,kimberlybaldwin@example.org,63be8982950f02132d86d780c0ce42560532ae511a3235f5adb5c283e8152edd,true
302,Scott,Brennan,863-560-3989,epark@example.net,98cbefa1d02302479afaa2240ea34e48600e69733fddea0fcb0224efae1b1eb1,false
303,Christopher,Buckley,(660)927-0882,shorton@example.com,3ec710fecdd578c95266d8b46bbf64481bb1909f4524a29250293c52919888f4,false
304,Caitlin,West,7303601536,helenhansen@example.com,46ea7e1a8b6eed575cba8e8e8ec2198cc89026416bf0744effbd6443d82b5f0f,false
305,Kenneth,Hall,892-510-7748,kimberlydiaz@example.net,6d93b7ff7ec00328003b9a9c33ee1ecd4805e4fb12221ec3b71ad8f2aef53125,true
306,Joseph,Melendez,(472)322-7199,anna22@example.net,ea2826274701e39fc9d11823f13c029991533a2c18ba0b44578e1fc65d18e367,false
307,Veronica,Avila,682-440-6397,tracydougherty@example.net,c1d6174b5683679cd718cc41b8e98669d8eb15ec6ac509e4ab1bc0bc1fec1f90,false
308,Kristina,Mitchell,847-332-3781,georgetownsend@example.net,53595b23bc903d95623b382295f15ba14064274453d08ae36b367726c5cb52e3,false
309,Christopher,Campbell,3535393919,melissa04@example.org,bbfa6d08e53207463e5577c18c889fe16859e1548c2721e38ab80c3a80fba12f,false
310,Chris,Gonzalez,(826)587-9774,castrolisa@example.net,b0ff1fefa61c184b0864a2fac59031b73d32fab39c287f2bc8c8698eb32c8ec7,false
311,Jacob,Duke,(400)281-3082,jamesmcintosh@example.net,93fd34f269837574befb48b419026357772b4b0fb5e00f052cf342b4b7ffb1e4,false
312,Dustin,Johnson,6985532962,johnsonbridget@example.org,cff7a36f0a986046df5263fe056fd61305c3a9217b1beef5127373ebf77a4e95,false
313,Kenneth,Silva,4146177028,terry52@example.org,2aed687e25a239b710a9679d8fa32d52de450022e1a2da43e6a61ea03fbbcd7b,false
314,Sabrina,Kelly,2405485527,gina73@example.com,4763f7bc43c0af5742dee3e08d468d3f501d15fc89b017a7cc33825ca4d70e8a,false
315,Mark,Mcdonald,(427)451-9560,dylanyoung@example.com,97a22ca3b83b9a15b4c0081ae63e0c6c1fcd5f72208b698f7f9589cfc0606f5a,false
316,Nicole,Hicks,3394724552,bryan38@example.net,51b769c8cb2ef23bb540c37ab6fe201c17b8aeb065d127787951c3dd815ba9eb,false
317,Deborah,Hodge,8259628943,yhill@example.com,456457dbdfd6da6dd2db3b464fe2d15b3ad3b800a12735f6a02028a43c6a43c4,false
318,Roy,Gray,475-632-2221,ashley46@example.net,23c9d16cc08d0d4c6735945939c443795db0b7a59481219e79b44771a794c1b7,false
319,Nicholas,Hutchinson,6817844721,marie18@example.com,6db78167752436ca2069ebce55280663fb4a9bbcddc749a5dc9fa9608c6d6cd8,false
320,Jon,Lee,936-481-7020,psharp@example.org,954ffdc1f1ca0048c44f5abd61d7af107f76d71f8a485b9758e11d6f674a5c76,false
\.

-- producto
COPY public.producto (id, nombre, descripcion, precio, imagen) FROM stdin WITH (FORMAT CSV, DELIMITER ',');
1,Ability today,"Visit over simply attack back practice. Trouble spring only movement. Style issue bit style. Pm eye technology fire.
Understand concern necessary. Full boy system.",392.00,https://dummyimage.com/537x330
2,Firm enough,"Leave old hit whom agent market theory. Police fact into.
Early lead base.
Could hundred manage plant. Action city town add police amount view.",263.00,https://dummyimage.com/998x226
3,Before specific north,"Beat gun suffer political. Machine method property. Help suddenly modern light buy ready late wear.
Than box leave candidate sort act challenge. Government magazine food.",687.00,https://dummyimage.com/178x714
4,Magazine third,"Ten yeah past institution focus. Wind difficult eat produce.
Gun start line minute movie no morning use. Talk tree area car prepare help leader join.",631.00,https://dummyimage.com/570x252
5,Director room seek,"Win make cost movie new either brother. Water room individual.
Rather report take lay. Interesting meet care yet standard his sister area. Full job body race.",111.00,https://dummyimage.com/228x905
6,Customer,"Tax class ability not truth. Capital then card summer young of key.
Explain need result sell bring scene around. Base marriage minute my security cup. Key mind sort worry apply major.",858.00,https://dummyimage.com/573x438
7,However pay walk,"With take rich. Office network best director. Heart result like class after.
Land week head add.
Something sell never already fear various.",643.00,https://dummyimage.com/242x904
8,Enjoy reach officer,Daughter wish culture moment minute. Appear among water might garden feel ground. Card number difference hit president population. Vote benefit easy.,320.00,https://dummyimage.com/593x183
9,Rest month former opportunity,"Share general daughter art focus. Him matter series various. Red keep national pay find.
One either same I. Marriage fund food.",634.00,https://dummyimage.com/750x780
10,Here by oil move,"Few mother teacher center likely nature receive. Exactly join along training assume indicate. Along defense enjoy how law.
Since agree into officer project. Dark myself likely argue thousand.",583.00,https://dummyimage.com/530x504
11,Poor stage,Full two new garden meeting. Yard particular their energy order statement high which. Including grow front test movie production.,482.00,https://dummyimage.com/154x839
12,Guy people,"Bar recently look day for evening. Indicate next page that tell more leader available.
Plant stop between school boy. It ago gun respond fight. Life a buy drive at message.",392.00,https://dummyimage.com/812x115
13,Success certainly network,College ready media data. Avoid clear our yard member. Add standard challenge all very generation player.,992.00,https://dummyimage.com/148x437
14,Too take,"Teach agreement story history cup computer form. Cost class beautiful no middle do every.
Attention foreign mission. Civil effect foreign night fly. Stay force each grow per place.",735.00,https://dummyimage.com/550x308
15,Better compare,Training police until difficult meeting prove. Television doctor cover upon stock ok order.,957.00,https://dummyimage.com/970x446
16,Mean final,Officer will window last man discussion maybe population. Material risk from prevent. Fly we story win read.,422.00,https://dummyimage.com/543x810
17,Institution help imagine,Parent bit ago past its mother various. Government find free affect. Rich week arm agent word staff. Available recent degree arrive now should black.,835.00,https://dummyimage.com/361x634
18,Garden simply industry,"Forget feeling idea body. Early some watch arm actually but.
Ground base college season. Opportunity program travel project method improve. Beyond when ready important fact image.",890.00,https://dummyimage.com/727x762
19,Lay like stuff,Grow others technology land campaign strategy individual. Certain live prevent current protect nation source national.,247.00,https://dummyimage.com/596x111
20,Different everything across,"Better learn reality apply street. Remain behind fire. Defense discussion together her fill.
Film throughout key yet hotel. Scene dinner few Democrat determine idea remain.",201.00,https://dummyimage.com/971x992
21,Win nice certainly,"Trip deep later. Result case look recognize various billion article.
Source book believe.
Kind culture us five science who page. Particular I system.",756.00,https://dummyimage.com/646x172
22,Performance east,"Process another pressure commercial full bit teach. We line do character term in. Goal front other subject red.
Item bag chance soldier rich condition. Soldier hope mean production add around modern.",436.00,https://dummyimage.com/961x694
23,Leader contain book today,"Fund have even move later project. Seat long out. Office answer minute feel.
Care term property physical game word can include. Dinner marriage message party scene left health. He find mother thing.",483.00,https://dummyimage.com/771x967
24,Different many third,"Coach stuff money sport woman ahead. Itself sister evening set eight high interesting. Green box skin left require myself per.
Finally anyone note economic thought design. Thus college kind field.",591.00,https://dummyimage.com/314x149
25,Investment indeed hear,"Second season quality how. Serious remember weight discuss production.
Trade current mention receive we positive support. Hair may task former defense sister.",809.00,https://dummyimage.com/440x146
26,Single born to,"Thank manage first opportunity program including view. Operation interview computer kid adult size.
Beyond poor rock time charge themselves study.",997.00,https://dummyimage.com/670x792
27,Forward it important ok,"Law eight news. Least beat grow then simply. Local easy father value. Mr side could want but.
Figure national bar school receive protect great. Father cold west old bag until.",70.00,https://dummyimage.com/120x349
28,Stuff class,"Perhaps safe old real reality government training. Billion check specific investment continue agency.
Both especially better out process. Thus later son nearly military individual increase.",145.00,https://dummyimage.com/661x305
29,Option success call set,"Capital growth stop shoulder movie. Speech increase likely drive. Pay win father when stuff.
Different age new section single less. Total spring mission turn office.",396.00,https://dummyimage.com/944x628
30,Fly rest,"Expect budget would. Coach others care foot degree.
Chair tonight close military. Nature or eight probably issue even.",484.00,https://dummyimage.com/461x207
31,Candidate suffer dark,"Recent through give same song during place score. Yourself discuss drop agree.
A young international lose avoid address.
Husband choice art head. Radio else rate mother four.",261.00,https://dummyimage.com/180x670
32,Seek stage,Beat arm and hope material lawyer develop. Name side hand suddenly fill notice. Teacher success avoid kid play along evidence. Republican fine best nearly.,404.00,https://dummyimage.com/201x547
33,Two,"Others ago case writer race wall draw. Near everything place. May why affect thought. Seek live music usually interesting age miss attack.
Something budget yet. Since thousand statement throw memory.",242.00,https://dummyimage.com/819x635
34,Political wrong their three,Structure suddenly lawyer result hard tax. Speak safe skin raise probably again trouble. Never might any four resource light.,187.00,https://dummyimage.com/557x425
35,Article mother full,"Standard increase bag real miss half. Off star pretty leader go find above.
Home choose page. I set employee spring sit admit watch amount. Arm matter hot quality activity.",487.00,https://dummyimage.com/261x387
36,Defense blue,Go before give performance third travel. His unit month wind experience. Run voice street note.,772.00,https://dummyimage.com/366x850
37,Ten parent structure,Behavior work environment father nature. Pick suggest increase seek now make something. Provide beat common five quality chance.,127.00,https://dummyimage.com/228x473
38,Everything first,"Explain study hot it movement for. Bar federal focus dog involve.
Sister board seat feel mind. Feeling start put federal ten ten word along.",54.00,https://dummyimage.com/291x650
39,Music thousand,"Case free deal quality. Discuss wear social add usually always.
Near probably close responsibility. Begin subject recognize receive ready.",477.00,https://dummyimage.com/685x183
40,Among bar,Strategy stock always continue out must consumer. Determine company current born. Clear available risk mission should likely garden.,624.00,https://dummyimage.com/159x505
41,Player analysis,Two population audience these short become piece. Believe partner kind audience eight see democratic. And our allow commercial myself rise brother.,577.00,https://dummyimage.com/938x585
42,Light away benefit,"Rather offer news. Surface magazine great green live provide. Although modern even hold.
Strategy space charge above rate everyone. Father create sort level girl hold.",554.00,https://dummyimage.com/333x573
43,Try by pick,Example decade through tend above rich. Strategy deal environmental industry know do six. Yourself country risk consumer responsibility yourself. President law everything fly.,160.00,https://dummyimage.com/551x493
44,Wind them,Black forward adult throw so. Relationship real before or buy guy leader. Good from direction east blood cultural.,949.00,https://dummyimage.com/474x963
45,Within do,"Build off total have trouble rather beyond. Establish start people per. Get image policy mission.
Process reality candidate entire. There when inside ask trouble tree.",310.00,https://dummyimage.com/544x571
46,Measure issue stop,"Memory stand catch movie administration make use. Player chair stuff whom somebody.
Provide war loss along continue pick conference almost. List artist draw another.",851.00,https://dummyimage.com/599x285
47,Boy story,"Guy two respond prepare. However home southern nation. Hotel clearly wide.
Never because make so ground. Leg girl case eight response relationship.",237.00,https://dummyimage.com/181x974
48,Girl ahead,"Because himself manage thought house happen. Will country stock after shake left data surface.
Method radio player clearly at air.",563.00,https://dummyimage.com/128x322
49,Gun can address,"Box care know protect politics worker. Low line cut word story.
North up evening. Who civil ever rock fly scientist his.",570.00,https://dummyimage.com/594x154
50,Old project,"Look task tell.
Certain term Democrat finally hair fish. While hard most add way seek.
Investment sit indeed computer. Skin similar mind catch federal music.",973.00,https://dummyimage.com/289x554
51,Answer,Activity stuff financial particularly member also forward. Reveal carry organization send TV pattern yeah. Already sister present day very these.,985.00,https://dummyimage.com/501x736
52,Little today focus,"Rich once glass remain high provide. Campaign election in class catch nature.
Fund security tree direction. Pay student arm the report certain example.",333.00,https://dummyimage.com/875x337
53,General money,"Understand drive second offer chance. Little until despite bed.
Avoid discussion process price family green maintain. Send home build science article. Drop information hotel third.",894.00,https://dummyimage.com/327x669
54,How black board,Behind machine too just condition least. Check significant crime century consider book. Anything mind media rule against responsibility agent smile. Kind specific yourself radio than.,823.00,https://dummyimage.com/744x401
55,Check marriage,Campaign require full goal right none prepare reveal.,476.00,https://dummyimage.com/571x110
56,Allow smile visit,"Business inside two know. On site fill plan store. Hold chance ever wish doctor become them.
Government play good left record. Culture surface production up water various role.",650.00,https://dummyimage.com/572x605
57,Development dream long,Ever key boy third clearly herself reduce. Per test picture anyone suffer believe late.,245.00,https://dummyimage.com/340x134
58,Expert smile,"Hope tree subject leg down station. Have wrong style plant be. Perhaps purpose lot girl note too.
As cover believe ten. Hope area final suddenly knowledge. Cut food civil unit like together.",261.00,https://dummyimage.com/100x636
59,Coach,Go mission pull under blood trade star. Live some sport. Apply big top hit develop idea tell.,987.00,https://dummyimage.com/380x836
60,Rock modern baby,"Congress interesting very defense. Left see pass play.
Record forward wear measure loss trial. Less fire trial over play. Them support page style always summer unit budget.",786.00,https://dummyimage.com/445x383
61,Blue run often,Present successful raise our financial water off around. Thank professional over thing role opportunity. Play fly political board.,559.00,https://dummyimage.com/701x149
62,She prepare better,"Expect open fly imagine. Civil service such follow own. Simply one field main probably account.
Him east benefit act local. Goal those want here clear mean. Me since themselves center.",521.00,https://dummyimage.com/823x579
63,Large available,"Best score crime feel. Manage that simple west message. Executive field car before manager.
Employee management game gas apply federal. Wear range describe move bring fund marriage.",786.00,https://dummyimage.com/576x430
64,Network popular he,Company professor health dark. Why Congress consider if coach could center everything. Analysis successful yard. State single your feel.,346.00,https://dummyimage.com/394x710
65,Beyond side ball,Draw look address against lot economic day. Culture continue try hold director simply. Garden image image everything.,254.00,https://dummyimage.com/297x400
66,Write despite likely,View history travel then send kid rule. Tend record season let remember table prepare.,228.00,https://dummyimage.com/477x762
67,Really sit series,"Stand condition nation address raise green capital. Student glass growth nearly church local.
Call animal else available entire instead TV. Position common water game generation what physical.",721.00,https://dummyimage.com/248x720
68,Full many woman,Ago nor yeah. Five subject use must foot individual garden. Side east speak low project create.,957.00,https://dummyimage.com/426x851
69,Town entire,"Beyond about region. Write property great name road describe take. Relationship all provide condition.
Practice value join realize defense. Every authority history fund send professional assume.",996.00,https://dummyimage.com/191x894
70,Cut suffer,Word report great newspaper worry however research easy. Prepare everybody outside wait charge seem. Should apply capital team drug.,983.00,https://dummyimage.com/966x730
71,Sometimes knowledge wish,"Face likely must would cut. Scientist family wrong sometimes.
Explain everybody Republican. Center crime fly line analysis. Mean when dream financial anyone.",293.00,https://dummyimage.com/526x221
72,Term trouble challenge,Official family type home catch team. Laugh somebody according type have office condition. Fine can everything where realize wonder human.,894.00,https://dummyimage.com/916x383
73,Improve both professor,"City hospital cultural usually attorney. Two poor follow.
Compare draw fish speak child prove. Blue interesting itself you too. Indeed region share might our.",926.00,https://dummyimage.com/111x373
74,Base space same,"Season job fast enter right. Win service travel more offer level allow.
Focus candidate how follow. Thought cell building. Commercial sister experience material.",881.00,https://dummyimage.com/273x683
75,They than ever,"Boy future answer deep lead population. Risk nearly care lot young name. Talk whose practice can wide.
Live activity similar with can develop can. Process eye toward.",315.00,https://dummyimage.com/520x931
76,Yourself boy wear,"Your hot reflect road own goal. Around check letter. Dog discuss suggest effect.
Wish million father second. Chance research city seat others thousand right. Maybe say music suffer safe.",752.00,https://dummyimage.com/323x338
77,Magazine,"Thing news area early. Lose last up right forward help. Few bad try offer.
Join production fight true develop drug less apply.
Carry try performance maybe serve arrive. Ground give ago model country.",143.00,https://dummyimage.com/818x830
78,Mission indicate necessary,"Light mouth attorney claim from certain century. Point be word. Consumer over interesting real.
Pattern write too although. Glass sure law value child. Drive democratic agree sure nor.",390.00,https://dummyimage.com/614x260
79,About second pay,"Pay car arrive go. Mention get reduce discussion yeah tonight guy.
Opportunity bit lawyer method discover start build pattern. Whose later summer meeting. Production get economy away music.",644.00,https://dummyimage.com/284x158
80,Line white soon,"Include score charge rest pull to. Message sense floor Mr million. New ball cut party its rate.
Grow table marriage. Trouble including far picture international order there. Dinner power left and.",256.00,https://dummyimage.com/706x199
81,Member available per,"Season land full hope television wall remain. Travel by citizen available cover matter. Theory make establish compare.
Understand however writer increase thus southern. Name pull reach guess.",598.00,https://dummyimage.com/752x916
82,Security glass same,"Performance difficult husband keep pull action. Open culture something understand simple arm.
Enter forget stage style onto. Manager analysis perhaps instead authority poor door.",885.00,https://dummyimage.com/132x898
83,Local degree director,"Improve arm word edge class. Remain so than water little.
Bill bag yes concern miss. Serve hour practice. History letter check foot.",670.00,https://dummyimage.com/464x317
84,Stand full because training,He despite room information they them. Last onto school decision property. Chair indicate anything simple month any class fast.,968.00,https://dummyimage.com/848x787
85,Ball head,"Board citizen listen power whatever. Heavy seek watch light process though.
Floor school listen character. His citizen girl institution.",89.00,https://dummyimage.com/879x942
86,Enough American,"Understand reality step black. Lose teacher want wide sort. Development everything discuss evening way glass.
Guess win small instead stuff. Fish blood gun hot performance.",780.00,https://dummyimage.com/205x465
87,Stand simple nor,Audience news leg. Take tell war language. Take blue care bill east agreement themselves song.,718.00,https://dummyimage.com/656x498
88,Develop maintain,Exactly actually health major. Available focus these. Dark strong stock hair.,609.00,https://dummyimage.com/110x661
89,Firm growth,Protect goal blue effort play reflect. Want study big like point. Wrong base method know contain sound fill.,966.00,https://dummyimage.com/982x494
90,National attack whether,"Dark film through society choice. Teacher such energy official record dark rate.
Step also alone development set analysis. Bar somebody me care support.",300.00,https://dummyimage.com/507x683
91,Painting range try,"Boy fill industry teacher cell.
Fear middle be skill cover.
Dinner itself somebody end. Rest take focus have indicate. Range small open democratic gas man mouth.",50.00,https://dummyimage.com/563x151
92,Majority,Leader evidence why quite exist example. Operation old than. Audience nature return child part.,414.00,https://dummyimage.com/484x430
93,Stop like,"Learn particularly approach baby. Sell because woman work make.
Continue oil trip. Fish both impact citizen. Subject down item nation.",576.00,https://dummyimage.com/452x640
94,Thousand image,Not road return her build. Executive maybe dog recognize street. Total method ahead lead task service sort. Do western husband charge enjoy never cause.,397.00,https://dummyimage.com/253x310
95,Management full,Watch free traditional structure law prove bad. Lawyer page stage hit. Speech forget reflect expert occur know body daughter.,631.00,https://dummyimage.com/972x640
96,Hotel room,Involve animal tell serious customer shake. Professor view media fund page produce service. Around about financial have. Age always series chair.,831.00,https://dummyimage.com/901x607
97,Cost live pressure try,"Program cultural material for yourself cover increase. Entire kind language free hospital whether.
Coach office begin economy.
Behavior foot church somebody. Place art wife event enjoy group.",869.00,https://dummyimage.com/934x280
98,Join student agent,"Culture TV history sort drug. My both official attention democratic. Final season attention.
Effect much top young base.",109.00,https://dummyimage.com/277x705
99,Cut involve available market,After total be very. Stage television mouth mouth charge guess something. Example music political from staff.,603.00,https://dummyimage.com/941x399
100,Manager poor,"Window reach good later. Us sense whether study some low. Soon program current above.
Ten treatment address save about yourself image.",182.00,https://dummyimage.com/361x677
101,Population job,"Be amount reveal race upon. Beat watch argue commercial speak friend. Major follow ten bank perhaps.
Arm alone western still choose begin.",75.00,https://dummyimage.com/628x618
102,Real employee everybody,"Religious from a sea pull building when. Act down ok would force wait contain.
Although act kitchen of financial. Character history fund think.",572.00,https://dummyimage.com/985x897
103,Responsibility wide,"Republican risk series bill decision capital trouble common. Couple role fast model.
Win any personal leg industry purpose. Edge nature but public total raise wife. Hear course indicate until.",681.00,https://dummyimage.com/842x612
104,Recent marriage peace,"Say off alone artist collection collection. Mouth sister kitchen week measure region.
City entire whether. Who shoulder picture movie across.",572.00,https://dummyimage.com/162x844
105,Main send may,"With control child cold result break.
Economic choose box response walk marriage stop. Start only yourself increase position serve other.",880.00,https://dummyimage.com/861x487
106,Staff section care,"Safe red too half once common evidence. Happen thought understand share threat gun off would.
List democratic chair act. Couple really old. To win enjoy happy maybe require future international.",421.00,https://dummyimage.com/272x922
107,Doctor to,"Together require source create air raise.
Later as ready between growth inside night drive. Century prepare parent address.",189.00,https://dummyimage.com/320x316
108,Cut cause foreign future,"Defense simply ground course. Draw agent cost speech machine decision public. There everybody these hold make also soldier.
Knowledge event defense enjoy care. Raise hundred present billion meeting.",237.00,https://dummyimage.com/630x112
109,Mother their,"Prepare moment action drop benefit. Member much learn describe star house.
Truth difference anyone according. Lot media statement hold technology key.",185.00,https://dummyimage.com/940x454
110,Water me,Offer off black than often different. Approach dream toward area number serious. He for amount coach beyond change loss travel.,730.00,https://dummyimage.com/752x870
111,Exactly letter reality,"Short win responsibility. Choice support scene article.
Detail glass magazine popular. Artist say budget character toward.",610.00,https://dummyimage.com/583x146
112,Why can analysis,Yes teach room heart statement. Question left voice market. Thing wall recently later answer picture young ready.,96.00,https://dummyimage.com/776x353
113,Meeting individual single,Whatever opportunity almost surface. Fire those lead produce tonight. Create agree away direction yet game. Everyone only set sport light.,943.00,https://dummyimage.com/770x653
114,Door still officer,"Peace only middle wall. Who interest far become exactly skill back yes.
Item force very week card computer. Management challenge free study sort young conference.",945.00,https://dummyimage.com/748x923
115,First,"Add major detail national degree north form. Another able easy be performance I. Team action director maintain know service sit.
Three record whose share. Serve surface should wait because majority.",269.00,https://dummyimage.com/318x668
116,Out clear account,Spend town build. Agreement back home base least question. Different sea site wonder war identify foreign door.,214.00,https://dummyimage.com/231x703
117,Seven before,"Use produce however bar they eight. Rest party pay probably.
Happy suddenly follow nor possible computer through. Man society act might budget several.",137.00,https://dummyimage.com/855x109
118,Across if,"Process maintain apply. Community safe speech training. Guess thus produce.
Notice station watch wrong college. Language against contain official analysis might.
Reach tell wait.",993.00,https://dummyimage.com/122x809
119,Campaign wind,"Member painting girl fight serve. Western stage investment drive ever. Partner left dark team order necessary.
Tv admit would newspaper for central. Hope past cup. Government truth often by analysis.",964.00,https://dummyimage.com/316x379
120,Forget certain factor,"Adult letter well network he.
Employee Congress pretty wide able myself with decade. Ahead fall loss.
Nor care spend agree population our. Late sport sense learn security.",271.00,https://dummyimage.com/217x960
121,Small say walk go,"Leave over mother collection involve sound arm. Address itself trip indicate do.
Machine young traditional single Congress thus. Year writer eye his both measure true.",779.00,https://dummyimage.com/707x798
122,Sense,"Mind standard view imagine color century. Relationship even difference land. My realize gas.
Far either from take score themselves.
Good then affect realize century baby. Cup during not week bank.",634.00,https://dummyimage.com/767x934
123,Main way city,"Ready measure national top. Human direction understand street back into. Act which week rich music result.
Change right view behavior exist. Development window future admit suffer.",80.00,https://dummyimage.com/439x977
124,Impact reflect,Pm conference part speech away do follow interesting. Different cultural campaign should we by hour dream. Never southern quite upon college property.,837.00,https://dummyimage.com/902x588
125,Media rock,"Teacher answer yeah wide. Certainly where risk amount.
Interview thing many camera. Share yet explain trial never Congress no place.",97.00,https://dummyimage.com/542x719
126,Last sort,"Too message represent trouble this. Entire create top let already. Task attorney laugh west kind.
Thus ok international only. People operation sign require behavior hospital.",197.00,https://dummyimage.com/578x972
127,Whose,"Reality allow same relate support. Lot car outside store. Deep two likely single simple.
No rest tell popular. And Mr you turn imagine.",116.00,https://dummyimage.com/921x410
128,Always leader,"We four property. Good education college guy shake.
Born nothing hot. Car allow spring attack or. Tough enough role wife. Program perform item parent.",305.00,https://dummyimage.com/923x713
129,Measure pattern,"Mother nice though relationship kind easy speak. Company couple series about whose.
Off far catch serve church suddenly. Deep keep newspaper analysis.
Assume Congress analysis.",418.00,https://dummyimage.com/502x386
130,Fall us,"Hit prevent suddenly so maybe. Degree television production. Like common boy writer.
Decision support significant yeah. Identify four me front. General probably why rich great shake.",750.00,https://dummyimage.com/696x207
131,Own though reach,Himself often hotel friend main mention mind. Show teach least world democratic figure. Front ok federal manage white style job second.,664.00,https://dummyimage.com/353x994
132,About behavior,"Natural by use. Still themselves effect might. World which traditional walk.
Product how certainly agency others ground. Professional cover too night bit. Boy especially race check authority degree.",617.00,https://dummyimage.com/437x733
133,Far central,"Specific any serve myself. Thousand after fear show save shake music machine.
Quickly executive bag good political. New value beyond stand team.",705.00,https://dummyimage.com/321x180
134,Different factor not tell,"Full institution again enjoy west wide military.
Whether already instead sort today.",198.00,https://dummyimage.com/457x917
135,Leader parent have surface,"Song marriage crime travel. Your food audience whole.
Check goal allow page. Personal care animal because factor where charge use. First performance agency stay somebody figure do your.",473.00,https://dummyimage.com/600x342
136,Head look other,"Ahead individual put population believe information. Enter paper rock serve.
Rate interesting risk meeting visit focus. Against like someone stock son.",629.00,https://dummyimage.com/563x577
137,Environment me probably,"Environmental toward along approach where. Through sound bar test keep structure before. Standard happy us family talk that three number.
Recognize appear edge issue everyone.",387.00,https://dummyimage.com/321x198
138,Watch fear,Big war painting ago recent unit artist direction. Drop home between bag single deal family maintain. Street likely market support decide.,640.00,https://dummyimage.com/694x769
139,Vote already,"Fine each amount begin. They car environment hotel responsibility increase.
Health each group society sometimes yourself mouth. Writer deal follow little.",79.00,https://dummyimage.com/239x844
140,Hotel,"Agree rest term above. Toward defense everything box pressure. Particular give job yourself.
As total event you check. Prepare stop thought claim phone.",704.00,https://dummyimage.com/435x851
141,Your very professional,Safe low coach break management. Think woman analysis reach authority trouble parent avoid. Thousand product agree yet. Personal back issue safe full.,485.00,https://dummyimage.com/715x134
142,Agent,Keep check participant foot. Same pick analysis hear like relate. Alone important staff conference themselves from data. Control simple real human together.,541.00,https://dummyimage.com/540x397
143,Prepare center,"Rule test operation evidence mean single character official. Girl force situation grow side ever. Yet model feeling argue in record.
Main hour action young final number. Maintain pretty wall middle.",814.00,https://dummyimage.com/278x690
144,Worry author economic employee,Language your to these speech. Blood recent understand candidate share remember.,333.00,https://dummyimage.com/131x571
145,Fly specific,South relate successful over election allow big check. Eye dog box. Follow game education attorney people federal physical serve.,606.00,https://dummyimage.com/557x431
146,Already toward any,Son country science stop until. Prevent culture field cost day other project. Fine senior sometimes create challenge question reflect.,312.00,https://dummyimage.com/723x375
147,Democrat during drive,"Believe hot police impact make. Herself more check direction.
Evening bank table these knowledge.",473.00,https://dummyimage.com/820x150
148,Clearly newspaper,Maybe study trouble daughter his. Foreign statement a experience.,684.00,https://dummyimage.com/939x182
149,Offer interesting,"Tell end player forget. Hospital memory stop take. Visit give citizen under hair need art people. Stuff return near hope national manager.
Large remember song three. Consumer reason large media.",138.00,https://dummyimage.com/351x343
150,Within smile significant,Surface theory international nothing effort throughout why. Head benefit drop life lot condition. Citizen smile nor development everything claim.,652.00,https://dummyimage.com/564x359
151,History find,Will nor manager feel feel economy. Without what mind majority. Drive town road student. Career son expert product piece area property.,363.00,https://dummyimage.com/397x976
152,Hand country,"Feel attorney laugh campaign. Ability arm read tax single than.
Move recognize marriage onto design. Child really community citizen simply husband which. Environmental personal see green.",169.00,https://dummyimage.com/133x888
153,Indeed suggest fine,"President apply let official owner instead. South certain eat collection carry participant education. World design civil service carry mission collection.
Response buy tree hand agree.",607.00,https://dummyimage.com/874x917
154,Strategy attention,Data long number then young charge kind. Cost interesting under next nation newspaper. Force try list look.,974.00,https://dummyimage.com/122x496
155,Play will,"Nature three near few capital across. Writer note show Congress.
Again whole between someone magazine politics. Pattern provide leave one.
Back order response senior. Assume lawyer many career.",535.00,https://dummyimage.com/889x569
156,Do,"Someone simply trade reason. She radio poor once building make just.
Her enter film bill imagine son west. Employee behavior responsibility military. Guess large store market affect full beautiful.",164.00,https://dummyimage.com/825x871
157,Short agent door couple,Claim join low each. Heart people matter security surface mouth source. Bring yard friend crime. Lay mind most charge.,478.00,https://dummyimage.com/588x836
158,Above control someone,"Resource reflect particularly treatment. Perhaps boy us fall voice focus. Pressure order industry.
Security market bill different pull describe. Less standard describe sit.",632.00,https://dummyimage.com/660x528
159,Computer she mother population,"Probably they also detail stage yes notice. Case include someone same within. Give benefit matter alone future.
Page piece so key political provide mission. Everybody hope care sister.",155.00,https://dummyimage.com/698x870
160,Really plan natural,"Spring his then unit talk. Rich light doctor speak network sound event. Arm great matter player station say.
Newspaper another especially per thousand. Executive near hour avoid notice.",175.00,https://dummyimage.com/415x374
161,Language,Main husband here increase. Growth body operation reduce stock.,715.00,https://dummyimage.com/303x428
162,Trouble behavior anything,"Particular well statement environmental page nearly least. From travel let short. Purpose customer student line seek then bring return.
Religious never never bring skill. Apply light whom pay still.",453.00,https://dummyimage.com/129x768
163,Add future,"Would every reality picture machine traditional plant.
Especially writer the money thousand loss. Part democratic woman too.",751.00,https://dummyimage.com/456x878
164,Call girl,"Spend course white growth mean mention perhaps. Remember out social rule none national ground.
Before my voice guy respond bill. Two him different. Paper avoid Republican represent.",799.00,https://dummyimage.com/827x445
165,Half like true,"Worker left could though. Lay worker fire world response.
Enough red around personal economy low work.
Now candidate type film sell. Whole describe wear space.",916.00,https://dummyimage.com/652x947
166,Next goal,Along this society firm. Such challenge officer. Play large take you population by social.,429.00,https://dummyimage.com/915x738
167,Market along true,Watch affect country say short. View church dinner task sport treat. Answer billion forget tax front several do. Sense from well medical east could plant.,103.00,https://dummyimage.com/461x856
168,Want right design,"Impact since black successful drive. Goal sure art boy recently course bank.
Draw they increase walk see enter.",865.00,https://dummyimage.com/462x285
169,Mouth activity today,Despite cultural receive brother exist fill yet its. Responsibility card walk other evening citizen government. Example note close through rule relate international.,600.00,https://dummyimage.com/525x436
170,Industry plant various third,"House certainly PM debate sing race least pick. Lose size clear own positive ability late.
Debate customer popular dinner build. Available international know notice particular imagine fly.",944.00,https://dummyimage.com/948x619
171,Majority nothing,"Best business month account argue.
Miss worker rich contain itself. Eye message difficult consider goal really will.",839.00,https://dummyimage.com/690x792
172,Past fear across,"Approach company skin present. Maybe top budget subject occur.
Artist seven detail successful high cup system. Tax religious similar tough agree. Leave president affect begin claim win goal east.",717.00,https://dummyimage.com/697x943
173,Art less management,Across now let item item. Ever respond walk impact watch. Participant may head property occur reach.,604.00,https://dummyimage.com/899x466
174,People go,"Above card cell father. Compare several continue tax expect stop.
How of film anyone pretty which. Carry hour threat hotel. Data behind debate hold may reveal record.",703.00,https://dummyimage.com/681x988
175,Expect and,"Young determine large learn system rock identify. Mission team item. Allow care clearly me value number agreement. Spring specific read often describe.
Including keep know type effect friend final.",272.00,https://dummyimage.com/139x775
176,Certainly design fly,"Sure employee break sell enjoy product institution school. Purpose small culture military.
Together include visit country yes opportunity.",519.00,https://dummyimage.com/153x164
177,Career resource ask,"Skill expect after go government. Happen hold bill note store.
Build now offer. Sense need challenge new forget around color study.
Behavior color research lay. Thought everything serious forget.",628.00,https://dummyimage.com/661x892
178,Nothing standard her,"Entire church can. Fund east still theory challenge recognize these. Inside recognize explain series political ball. Goal bank process than feeling.
Run most building strong work friend.",934.00,https://dummyimage.com/470x423
179,Minute movement agent,"Guy within save couple imagine. Alone then tree month. Save program job rate.
Until see purpose individual draw. Ability method reality hundred toward get reduce. Summer side style his.",360.00,https://dummyimage.com/588x659
180,Interview between top,"Across morning speak great. Edge behavior leader realize teacher once must agent. Firm worker data bag join case.
Set tree popular agency.",899.00,https://dummyimage.com/795x148
181,Should I another,His door would door grow. Woman purpose worry institution car within treat. Analysis instead receive receive authority.,387.00,https://dummyimage.com/788x904
182,Pass,Style loss perhaps billion hand just board charge. Soldier Mrs give civil voice cover. Training challenge determine weight.,140.00,https://dummyimage.com/785x715
183,Field recent,"Cold attorney black create quickly knowledge. Cultural religious head onto question. Investment produce force.
Structure represent range draw. Instead fill letter. Discussion evidence under new.",375.00,https://dummyimage.com/987x973
184,Necessary leg increase,"First factor positive term.
Decision team certain table suggest. Service help left fill.",524.00,https://dummyimage.com/158x773
185,Or cold machine,"Nice policy third suddenly. Include room national base part compare like century.
Owner explain unit sense investment traditional. Alone must parent born expert program.",620.00,https://dummyimage.com/904x551
186,Discuss north option,Democratic hot item community. Middle structure what lay nation soon. Sort serious specific production member forget.,146.00,https://dummyimage.com/853x355
187,But set fall leave,"Remain large themselves them.
Positive what wife care against knowledge from. Stay economy sound suddenly bill worry.",715.00,https://dummyimage.com/253x894
188,Artist type,"Top take certain if art source skin.
Probably check bed should. Model Mrs trial cost chair.
Tree white stock. Free rise real approach series alone case.",797.00,https://dummyimage.com/689x276
189,Through hit,Catch soldier just structure agree. Success and hundred thank. Most class institution truth know get. Million four modern hundred.,588.00,https://dummyimage.com/172x352
190,Eye cell,Pull operation develop test plant recognize alone. Mr believe simple share easy somebody. Road authority home behind life.,555.00,https://dummyimage.com/918x623
191,Brother policy,"Field recently who and deal. My black yourself prove job citizen response. Than increase include.
Trouble even worker learn. Stock spend year support. Down whole program employee day front into.",543.00,https://dummyimage.com/324x945
192,Employee author because,Account writer stock again art song. Keep effect able sport social. Anything letter beat campaign newspaper movie house direction.,468.00,https://dummyimage.com/834x433
193,Against,"Professor beyond bill write suddenly recognize scene. Action piece determine.
Throw give later religious defense later. Sense line hear bar plan performance.",665.00,https://dummyimage.com/371x777
194,First community project,Population federal else. Right make once over movement yet mission. Nation man morning by agent PM.,60.00,https://dummyimage.com/301x827
195,Partner low whether stay,"Happy once factor play should. Often dinner people eight sort or. Heavy method occur hospital born.
Eight officer reach worker rate vote. Republican hour behind knowledge not later.",906.00,https://dummyimage.com/932x748
196,Raise race page,Husband talk democratic him collection. Soon right hand first message fear race. So job order reflect man. Different reduce yard develop.,711.00,https://dummyimage.com/338x884
197,Study glass next before,"Quite bag always PM anyone attorney will provide. Gun effect life out.
Soldier per Democrat wide party sometimes. Positive soon trade property.
Employee administration top seven as. Wish back full.",443.00,https://dummyimage.com/803x228
198,Enough sound,"Air determine quite. Rest now upon provide protect present reach player.
Garden hard spring soon near much. Room along economy. Born down training pretty.",911.00,https://dummyimage.com/710x437
199,Thank rather that,"Attorney item involve power. Interesting charge notice rule realize total. Land ready blue vote mean.
Run major which town. Court guy day doctor building this. Society those door strategy.",404.00,https://dummyimage.com/157x970
200,Value apply seem,"Themselves buy tonight. Early raise prevent.
Defense everything fact notice free. Buy hospital provide pattern. It why though same give upon finally media.",325.00,https://dummyimage.com/260x349
201,Do building indeed,"Along western consider.
Author both leave goal address school case only.
Until parent pay standard. Sea phone run concern machine move.",303.00,https://dummyimage.com/963x450
202,Believe natural,"Interest economy force coach pull. Detail tree kid necessary according cover.
American write suddenly. Night rate worker tell year.",831.00,https://dummyimage.com/997x908
203,Town because instead,"Point such floor star such very. Few old event unit both guy. Behavior radio cup interest major.
National win force position color. Consumer painting nice yourself international.",980.00,https://dummyimage.com/797x460
204,Nearly culture claim,"Call life television sort hit leave. On site they star prove issue late.
Certainly authority necessary form. National trial lead similar art less table.
Attention how seem kitchen second front but.",440.00,https://dummyimage.com/983x895
205,Leader save they,"Mission dinner source my win design try run. Prove ball sign.
Six add window successful. Who fire cell resource even create. Child over include analysis when.",685.00,https://dummyimage.com/845x694
206,Remember would range,Commercial student occur wide whether. Discussion interview meeting each anyone network material. Face enter official central yourself space. Throughout accept chance for fact amount.,135.00,https://dummyimage.com/523x539
207,Hundred across,"Several there receive. East herself morning recently seem.
Road police shoulder always direction it trial. Adult same instead tax face open try.",512.00,https://dummyimage.com/720x495
208,Deep job stock,Alone continue approach night there exactly action any. Worry marriage per because writer near stay. Dog best side section relationship. Long size different treat yeah.,790.00,https://dummyimage.com/896x118
209,Send everything reason,"Modern truth question why. Expert magazine fight care stock.
Technology final event interview. Respond common individual seem. Design serious board name.",809.00,https://dummyimage.com/508x396
210,Medical information,Region capital analysis which. Attorney carry authority owner health alone different. Glass month real produce center.,201.00,https://dummyimage.com/535x896
211,Indicate institution word,"Go account air system. Appear billion north arm easy ball guy. National history guy ago parent.
Two listen sell challenge ago. Hotel operation another write accept rule.",253.00,https://dummyimage.com/131x913
212,South support,"Cold so home sometimes. Today agency item painting. Front stuff also impact.
Own job happy local scene keep score.",335.00,https://dummyimage.com/407x567
213,Ask what land,"Mrs society girl. Hour less particularly organization out. Audience rise character impact ability this.
Fly mother pass off many at medical. Us nation add police stand.",167.00,https://dummyimage.com/639x226
214,Ever easy eat,"Property hear worry thus general.
Trip help interest skill letter raise reason. Center staff part.
Push us special hit next game. Through hotel yard American cultural.",215.00,https://dummyimage.com/923x778
215,Want attack read,Site different account shoulder throughout tough change. Character lose than power across main standard.,315.00,https://dummyimage.com/313x120
216,Attention benefit small,"Model news phone truth. Cup party style five film see.
Kid human southern chance. Close risk difference sell.",378.00,https://dummyimage.com/744x807
217,Series you,Start before upon trade pattern Mrs information wife. Among arrive loss set cut film such.,846.00,https://dummyimage.com/205x605
218,Consumer describe,Later early service though part. Kind measure learn lead good. Little price doctor. Certain husband dinner identify laugh art security.,198.00,https://dummyimage.com/684x832
219,Goal own,"Evidence result your key. Avoid describe oil Mr medical animal sign.
Cost lot range through rest. Color rest present too. Every way account among tax animal.",162.00,https://dummyimage.com/290x815
220,Size manager economic,Picture detail view instead with inside course cell. Seem network war. Writer day phone animal themselves program.,310.00,https://dummyimage.com/343x900
221,Behind save,"Interesting itself red this poor crime old. Present report also evening economic central.
Age religious region son loss.",316.00,https://dummyimage.com/795x453
222,Learn community,"Black mouth boy amount decade since.
Say pull never letter whose although. Among employee choice score.",972.00,https://dummyimage.com/388x252
223,Everything order,"Good college line benefit our tend.
Son perhaps week good. Such organization five red.",502.00,https://dummyimage.com/408x902
224,Market your simple,Recognize go black model. Arm box stock walk democratic ahead test but. Suffer if along good including.,594.00,https://dummyimage.com/401x595
225,Particular relationship job,Pattern network everything star large research. Black million require door foreign beat hotel. Different among read suddenly leave street boy.,1000.00,https://dummyimage.com/334x884
226,Method without then,"Soldier between degree few describe. Than consider central western include detail your.
Fall still admit fact history. Structure until say report fill guy.",834.00,https://dummyimage.com/818x109
227,Environment machine two,"Goal baby month risk difficult prepare. Bag once treat yeah garden. Into fund think blood.
West likely person recent oil.",424.00,https://dummyimage.com/390x723
228,Attention,"Decision bill system father east.
Finish standard lay skill generation oil foot. Finally really human best other stage people. Draw end job from food information.",159.00,https://dummyimage.com/548x711
229,Leave ahead task,"Tend result serious kid.
Easy ago simply.
Community there employee reflect fish. Learn that dog indeed would dream their get.",325.00,https://dummyimage.com/1000x975
230,Challenge because,"Difference you special teach often five manage there. Party deep seven everyone.
Morning outside tough along. Recently science life moment radio old room. Soon over over number.",808.00,https://dummyimage.com/341x747
264,Us west,"Exactly receive act mother coach. Majority reality toward thing. List these maybe data skin collection.
Audience hotel note reality sit. Modern purpose simple low.",875.00,https://dummyimage.com/347x683
231,Rest resource material,"Indicate hard beautiful contain certainly six fly agency. Standard letter save Mr cover suffer watch long.
Pull gun hospital system whom growth. Pressure new culture staff station home.",567.00,https://dummyimage.com/116x453
232,Fund clearly we,Thought force usually development sing social. Important nothing area anything current yes indicate.,489.00,https://dummyimage.com/587x436
233,Significant report,"Lead suffer apply stuff half sense catch. Recognize help up television model. Main account everyone under simply.
Painting mouth opportunity first now agree. Bit answer still even kind.",485.00,https://dummyimage.com/229x110
234,Base,"Realize help bill game. Build leave industry agree. Decision receive tough manager begin.
Yet reason relate see. Member per how police section. Idea energy body me.",158.00,https://dummyimage.com/829x136
235,Meet box quite,Travel safe wife among. Which century offer out close happen appear morning. While executive summer kind wife draw fund.,781.00,https://dummyimage.com/709x562
236,Early kind far,"Force its eat in morning dream.
Class if week back woman parent. Approach hard blue officer some organization single how. Officer need wait close president kind.",943.00,https://dummyimage.com/283x543
237,Design recognize however,Stock some until rate possible. Evening key time character purpose world.,905.00,https://dummyimage.com/335x278
238,Pm commercial,"Item what audience note sure. Herself name best race. Knowledge receive sign.
End law pressure before nothing movie I. Floor catch various rich point matter.",324.00,https://dummyimage.com/762x335
239,Evening miss magazine,"No politics discussion family reduce TV. Report allow effect man test. Fund adult some prepare.
Pressure teacher moment realize. Great officer remain tree.",585.00,https://dummyimage.com/680x749
240,Fire,Value board staff purpose energy measure hear strong. Program various student say. Far beat cause star among require.,137.00,https://dummyimage.com/626x171
241,To,"Board surface benefit establish cultural sort. Budget brother look speak investment defense.
National political forward eye level building data field. Check individual believe.",252.00,https://dummyimage.com/166x280
242,Product choice baby difference,"Too federal pass federal concern economic class.
Civil chance develop nature the project. One top visit friend true sport success past. Six in character behavior team be.",238.00,https://dummyimage.com/644x125
243,Night accept,"Close once color not top continue. Nearly almost treat five stock city.
This wonder realize likely have office.",229.00,https://dummyimage.com/539x931
244,Statement nation,"Most job expect. Too six nation. Bank likely six discover.
Ball start station floor. Answer parent particular child prepare.
Eight difference choice bit. Travel field imagine design art meet.",161.00,https://dummyimage.com/740x680
245,Most,"Administration work bill enough simple ready employee. Growth edge suggest ball last free will size. Method think doctor charge decision exist newspaper.
Notice road building two face.",283.00,https://dummyimage.com/125x842
246,Send difficult,"Water can whatever goal seat. Benefit continue practice six happen marriage. Show method score become with whether dream.
Republican significant dark actually great. Father court among.",873.00,https://dummyimage.com/590x343
247,Each summer job,Win indicate onto high. Media leader movie join. Attention feeling total chance.,839.00,https://dummyimage.com/429x768
248,Own whether,Half couple discover picture mind. Stay prove story more yes talk ahead. Else after page clearly travel.,880.00,https://dummyimage.com/468x920
249,Development health,Type art expert bit sea deal almost. Young clear production million eye alone minute line. Improve reflect onto policy little.,508.00,https://dummyimage.com/474x440
250,Her identify,Whatever practice history life without. Mrs it care hot analysis community him. Particular economy executive you less catch rate. Expert give offer name important performance his.,496.00,https://dummyimage.com/318x573
251,Stop yourself,"Would follow little wait. Kind physical reach talk.
Parent figure southern moment end spring. Fall however be what very door. Still would true market.",244.00,https://dummyimage.com/808x353
252,Environmental dog name,"Perhaps manager clear feel short. Water small democratic space analysis girl.
Challenge yard long realize physical moment short could. Idea morning four lawyer raise.",992.00,https://dummyimage.com/858x903
253,Wind up,"Those project nation director future.
Each decision reduce dark. Carry member talk sound.
And protect thus television. Whole do week.",738.00,https://dummyimage.com/196x246
254,Public spring,"Send citizen network nearly example. Picture respond beyond prevent defense government. Education travel news account suffer other. Share exactly artist a test effort.
Carry low detail wrong.",779.00,https://dummyimage.com/402x227
255,Decision strong,Party employee prepare from something group different. For Democrat myself. Mention none charge treat.,467.00,https://dummyimage.com/628x425
256,May left,"Left though receive responsibility. Not very boy sort. Drive military seem recently.
Town note place mind upon. Some add another someone form oil table. Visit same direction seat my.",860.00,https://dummyimage.com/538x384
257,Charge,Bed no science attention face who agent land. None prepare radio wall. Kitchen purpose rather that.,702.00,https://dummyimage.com/849x544
258,Certain who sure join,Reveal personal example most. Two today pattern response kitchen focus budget. It across training able become.,928.00,https://dummyimage.com/476x925
259,Sell reality,"Hard me law official.
Glass expert measure economy provide avoid long. Personal top court.
Model bag power serve dream across. Goal garden bag know prepare month ready.",745.00,https://dummyimage.com/1000x164
260,Yet look opportunity,"High happy ahead share. Sit least itself. Above yourself stay despite standard.
Every land son special. West worry day almost.",252.00,https://dummyimage.com/913x178
261,Consumer also international,"School often truth about reach.
Prove leader forward thousand memory central. Special for loss hit account where. Draw prove hold unit discuss well international. State large wind week become girl.",416.00,https://dummyimage.com/125x142
262,With room,Family board here green gun represent wind. According left religious seem. Right include reveal method chair beautiful paper.,541.00,https://dummyimage.com/269x715
263,Decide born,"Song site determine talk speak blood very.
Offer almost fall score serious road. Professional much step matter.
Appear example education expert voice him spring.",661.00,https://dummyimage.com/190x189
265,Point,Character along civil strategy agent. Wear nearly turn stop parent drop civil.,673.00,https://dummyimage.com/929x267
266,Avoid million analysis life,Sell expert fall organization happy stock discover beyond. Majority price region. Matter avoid PM cover time free.,519.00,https://dummyimage.com/654x808
267,Husband difference,"Product news kind staff future environment.
Save ever body board stuff wide. Read parent despite development heart change.",256.00,https://dummyimage.com/888x785
268,Series challenge,"About make safe ball year. Answer little special walk product.
Us you conference mean group range. Fight course public resource.",319.00,https://dummyimage.com/592x135
269,National animal father,Where tell light condition decision use size. Well central break cut east.,943.00,https://dummyimage.com/102x429
270,Try entire out score,Now probably create agency. Subject ago true upon perform. Market college election note nation fact environmental.,702.00,https://dummyimage.com/196x712
271,Case detail green,"People actually turn miss five believe. Party drug agreement.
Those everyone range election hard. Western once industry commercial daughter growth sit. Way happen international hotel some along.",472.00,https://dummyimage.com/162x139
272,Hand commercial,Situation notice behind trial. Future into college kind even. Conference training TV begin future capital.,769.00,https://dummyimage.com/199x844
273,Remain child eat,"Remember find enjoy write. Piece church remember measure. Wind nice newspaper site.
Race able term same three develop.
Debate read bag eight. Third them challenge far.",810.00,https://dummyimage.com/129x140
274,Room local,Question month former few. Arm movement high amount. Hospital price before Mr however enter.,218.00,https://dummyimage.com/506x594
275,Because away system,"Say left different stand place entire increase. Apply Democrat program foot.
Strategy government medical example respond. Here fear each vote its occur. Buy could Republican campaign enter explain.",869.00,https://dummyimage.com/974x516
276,Yes yet box,"Cover bank look page image. Morning long without huge trouble go imagine financial.
Staff history fight environment. Agreement scene wait outside phone ask. Light produce across seek difficult.",569.00,https://dummyimage.com/121x267
277,Government push,Produce want many assume third. Large care science less recently trip now. Firm include bank around player goal.,961.00,https://dummyimage.com/586x495
278,Statement upon,"Defense indicate player method buy player. Pm drop score owner leader base. Approach parent get anything provide pretty.
For artist foreign mind admit affect. Everyone painting necessary likely.",975.00,https://dummyimage.com/510x253
279,More put,Good watch information maybe others soldier town gun. Culture return argue statement seat similar issue. Attorney return language skin. Prove vote he education receive across smile.,744.00,https://dummyimage.com/199x151
280,Agree project always,"Parent hot bad offer physical. Doctor require clearly save energy. Throughout board baby drug increase image statement.
Mr stay wall life.",786.00,https://dummyimage.com/802x522
281,Study rather huge,"Campaign get leg factor.
Police cell discuss speech value great stage blood. Head safe team. Pick media it today central we.
Floor reality practice already member. Down husband try market notice.",969.00,https://dummyimage.com/694x714
282,Develop help,Drug begin fine fight stuff. Particular physical contain step hair at. Old against discuss source. Remain assume meeting site set determine.,244.00,https://dummyimage.com/809x130
283,Matter,Increase cut mean still activity. Party keep hope believe follow worker. That without under drive approach follow.,842.00,https://dummyimage.com/442x759
284,Kind nice partner,"Evidence growth artist western church.
Something nature participant program. Mrs training experience give.
Should affect movie. Speech single start course daughter cover.",873.00,https://dummyimage.com/755x579
285,Grow car debate,"Produce event concern matter. Culture across marriage how.
Glass best whom table everyone none. Officer prevent government want thus try. Believe tree true five beyond discussion let.",423.00,https://dummyimage.com/226x224
286,Free lead work,"Score bank entire do out.
Bill simply live one avoid receive natural spend.
Personal voice most customer. Enough break teach business customer way that. Cultural measure its body put.",974.00,https://dummyimage.com/800x406
287,Middle drug although act,"Camera read blood cold air they. Type such same look.
Subject alone side. Stuff rise claim attorney read argue.
Value court two seat at cup chance who. Anything become direction always.",473.00,https://dummyimage.com/464x206
288,Stage others pass,"Music lot political wide. Summer more garden around nothing Congress up student.
Chance rate might. Author kitchen not best challenge however Mr.",583.00,https://dummyimage.com/170x894
289,Realize difficult remember,Base away country project yes front baby. Really magazine easy cell job response. Hit baby open environment national personal all.,910.00,https://dummyimage.com/636x436
290,Later Democrat teacher,"Look away kind news bill. Year war resource. Listen safe first identify.
Foot drug quality send such cold nation. Pull particularly country. Customer rate nature music reduce teach artist.",599.00,https://dummyimage.com/799x573
291,Somebody put,Both believe world control part. Know class bar year at good financial try. Service American share several hard lot have.,613.00,https://dummyimage.com/131x144
292,Page situation material authority,"Voice son analysis activity degree which everyone. Oil author factor perhaps.
Recognize and subject apply shake low forward. Degree sit relate sign shoulder forget. Whom central here debate across.",865.00,https://dummyimage.com/791x272
293,Standard all add question,"Color while amount best. Speech to necessary service natural first.
Final film knowledge great make include him senior. Should science really front indeed star. Campaign concern hand learn.",841.00,https://dummyimage.com/579x861
294,Cell wrong,Economy bring act agency perform for clearly themselves. Use machine image wrong of reason.,614.00,https://dummyimage.com/428x410
295,Product light,Food capital page memory. Science score woman own room early. Suggest allow travel financial. Buy exactly short whatever must often.,990.00,https://dummyimage.com/143x530
296,Design early where religious,Father everything or remember job campaign main. Air raise red himself experience best. Detail within door air with training.,706.00,https://dummyimage.com/433x189
297,Strong,"Week alone why mind feeling. Purpose garden mouth home language two body. Expert church food drug sound.
Modern bit politics mind knowledge actually all. Break provide Congress sure.",422.00,https://dummyimage.com/640x494
429,Catch nor,Condition city language arm around certainly. Music market huge again both might. Over score forward.,524.00,https://dummyimage.com/948x572
298,Officer,"So mind story born else week. Church quality represent team collection study.
Side also develop fast along. Marriage school go response. Positive position off.",857.00,https://dummyimage.com/659x484
299,Product,"Next something special. Street happen fly type.
Feeling son court when quite anyone. Family sit purpose Mr.
None financial age issue interview know.",179.00,https://dummyimage.com/277x767
300,Similar herself,Central data radio win popular conference teach. However lose parent force doctor between he site. Leader born now tax design. Chair interest free recent than wife task.,920.00,https://dummyimage.com/615x852
301,Reason home just,"Upon data would become could. Short support game during last manage best. Unit draw level their still tend. Finally bill have.
Game doctor impact beat decade while security.",735.00,https://dummyimage.com/538x510
302,Buy network subject local,"We yeah production news follow tax voice. Claim together task.
Important national term. Clear no media without pick home character Mrs.",902.00,https://dummyimage.com/496x577
303,Some answer story,Need available break as edge. Response business everyone truth between according knowledge. Consider form under.,971.00,https://dummyimage.com/129x923
304,Agreement each,"Choice activity act some shake lead. Party week reason everybody garden.
Stop staff student positive election word bit. See along service state guy them kind. Rich speech within site company street.",792.00,https://dummyimage.com/149x800
305,Film during participant,"Chair rich phone beautiful.
Take two our value toward. Available grow eight easy them dark particularly.
Throw strategy manager threat. Consider audience left officer wide accept.",722.00,https://dummyimage.com/933x727
306,Visit,"Country similar happen five past focus. Toward among first become dog must the company.
Including court pick magazine. If treat speech strong rock care treatment next. Box unit share while source.",793.00,https://dummyimage.com/127x906
307,Season economy coach about,"Sport charge avoid reason analysis. Throw machine evidence decade. Stay see Democrat relationship opportunity team.
Child third entire think interview often. Pattern participant push program.",805.00,https://dummyimage.com/742x563
308,Our,"Determine meeting system of what claim kind. Feeling opportunity let throughout her go career.
Foot nothing education nothing. Event cut PM school still. Important all another actually.",755.00,https://dummyimage.com/716x418
309,Church network consumer,Born rise television model bag include. Quickly million coach win. Ability short always say probably plant walk.,90.00,https://dummyimage.com/258x797
310,Choice medical activity,"Up rich somebody alone. Mrs relate hotel between thing yeah value.
Anything development plan think over include article. Fact energy piece research.
Seem partner trouble meet fast attack.",855.00,https://dummyimage.com/119x441
311,Will table south,Lawyer boy strategy worry economic quality. Still condition business everything this threat officer owner.,617.00,https://dummyimage.com/709x222
312,Mother treatment,"Traditional your author theory every word. Throw produce type wrong two happen.
Traditional success throw it coach dream own. All those soon red region author oil.",64.00,https://dummyimage.com/278x423
313,Federal final care,"Approach around other although cold person such daughter. Sister my price kid here yourself. Off rest finally four until many.
Guess hope less. Happy capital maintain tell expect leader.",527.00,https://dummyimage.com/721x941
314,View difference brother,Business attack keep institution. Case account type run meeting family require.,702.00,https://dummyimage.com/922x454
315,Throughout would article,"Car clearly staff thus rich. Argue strategy type budget together. Before agency market above surface throughout.
Green discussion better understand site try. Probably food series the live which.",844.00,https://dummyimage.com/539x377
316,None south free,In sometimes protect south. Choose hot kind author represent. Economy however none field front form board.,696.00,https://dummyimage.com/451x327
317,Suggest rate,Tv his career last budget operation. Play individual strategy.,856.00,https://dummyimage.com/768x448
318,Kitchen science expect,"Leave say third themselves huge effect market. Behavior skin dark view add surface never blood.
Probably performance attack current material by leave theory. Low pattern allow mother million eight.",546.00,https://dummyimage.com/657x934
319,Stop camera,Know hotel short everyone technology who agency. Blood sound talk question teacher third house. Environment program condition money.,893.00,https://dummyimage.com/686x133
320,Before bit across,"Response read how agree live learn. Simply buy ago nearly large.
Thing leader stage feeling human executive must. Court blue total unit live.",140.00,https://dummyimage.com/645x770
321,Key magazine probably,"Art painting politics drug national professional my analysis. Research seven class agreement.
Control important guess activity bar parent if. Piece own alone.",577.00,https://dummyimage.com/550x205
322,Oil different western,"Meet it spend budget behavior level positive. Cost very serve that always least. Look purpose space listen.
Work pick trial two. Edge away might lead hand material hope.",284.00,https://dummyimage.com/252x482
323,Future there set,"Social beautiful rock certain.
Series begin soon Democrat work continue agent. Rise visit modern politics himself buy.",675.00,https://dummyimage.com/184x642
324,First by,Cover detail natural base sister wall night group. Win compare impact wrong drug force. Either how message measure.,128.00,https://dummyimage.com/841x655
325,Own seven,"Say these maintain produce word. Order five material year.
Soon response finally.
Follow light newspaper. When big wonder play.",266.00,https://dummyimage.com/886x292
326,Hospital well child,"Executive that company. Floor short very add.
Smile catch someone personal address. Ten hour responsibility send clearly compare.",705.00,https://dummyimage.com/637x696
327,Matter across,"Say impact hold yes us defense color. Budget government prove site everything training. Short sure take near.
Dark quite summer unit surface. Scientist together town improve yourself public health.",809.00,https://dummyimage.com/256x931
328,Degree leader real,"Federal appear one to.
Read which once so example. Amount prepare dinner painting until fine decision. Budget society me enough family law.",790.00,https://dummyimage.com/297x487
329,Force adult rather,"Machine mean outside your matter. Congress product drop build difference. About manager whatever power live push.
Republican story option fear. Enough direction space protect office.",577.00,https://dummyimage.com/209x567
330,There draw article,"Party the group mission care us seven. Address true pressure sea paper table suffer. Catch keep everybody price long.
Thing write suddenly. Rest remember dinner husband.",750.00,https://dummyimage.com/156x567
331,For already evening tree,His college alone poor last magazine hit. Minute site skill know. Structure simple than happy civil form. Local garden security stage her form.,281.00,https://dummyimage.com/287x764
332,Price by,"Amount defense part whose party class how fire.
Worry employee you. Girl entire right value use president time.
Ago car feeling Mr force reality majority. Tax art purpose nation daughter.",325.00,https://dummyimage.com/868x831
333,Necessary store yes,"Detail interview mean ability answer. His sign her blue. Cause then part attack card check more. Thing baby attention end.
Less fight establish himself parent. Lot theory poor have.",273.00,https://dummyimage.com/964x518
334,Realize service,"Free action become financial allow present young. Middle one result technology song.
Economy health return today whole century.",774.00,https://dummyimage.com/214x128
335,Drop strong,Up because leader into consider bag drive medical. Fill stage among our short economy town politics. High send create collection give manage information less. Fine no pressure fly.,612.00,https://dummyimage.com/894x686
336,Lay total bed man,Near seek less church finally law. School since remain once everybody sea out. Plant current away account administration so.,812.00,https://dummyimage.com/193x757
337,Present organization role,"Sometimes nearly east design throw. American road face land. Building top all series.
Country building unit meeting sign. Main plant it mind form theory. Now enough wife against care glass lay.",830.00,https://dummyimage.com/952x917
338,Institution sell,"Age person only reflect center home. Bad hand possible. Young point past.
Entire Congress fish country forward thousand. Particularly let prevent suffer interview.",905.00,https://dummyimage.com/531x975
339,Under federal,Down picture he see customer reason. Issue how notice same hold. Notice worker you hand. But up set point rate truth.,847.00,https://dummyimage.com/119x644
340,Both,"Remain east Republican big hotel bad. Region when economy.
Fear return may evidence past low. Notice prevent art rise mention structure.",742.00,https://dummyimage.com/289x585
341,Well time,Fact simply beautiful within page term production while. Pay dog standard bring. Exist man standard yard modern.,136.00,https://dummyimage.com/954x302
342,Raise identify,"Hand minute region air which ago. Vote toward argue current inside hard fill.
Ready wide until have policy detail. Hundred sister listen history they international.",867.00,https://dummyimage.com/423x615
343,Head four watch,"Education argue for economic. Third save voice section.
Program why require in race mean song style. Catch agency rest including.",764.00,https://dummyimage.com/122x570
344,Animal much sit ahead,"Couple large eight. Place though serve think common.
Different base police than. Still weight thing. Maybe white scene or until.",358.00,https://dummyimage.com/271x588
345,Catch support,"Doctor friend late position. Special full concern do health professor everything. Very add million civil really hotel close.
Western appear wind where. Character conference involve still treat thank.",490.00,https://dummyimage.com/482x609
346,Build American,"Trip article brother read something.
Only my hot could. Blood health source forward writer would forget. Subject sing set social.",327.00,https://dummyimage.com/130x472
347,Factor even present,"American help against day. Half young size great.
Stage leader door culture course. Seat to new rate student.",878.00,https://dummyimage.com/469x524
348,Final activity,"Experience talk choice prove quite season.
Through exactly value nice go hospital. Short road think especially hospital yet.",882.00,https://dummyimage.com/523x549
349,Successful big where,Off letter brother news figure staff none special. Pretty table skin body. Plan expert everybody example life if able.,188.00,https://dummyimage.com/831x295
350,Probably war bag present,In American should amount because story thousand. Amount bar central blue subject. Sing whose memory knowledge concern once. Account exist main often try picture.,251.00,https://dummyimage.com/241x589
351,Decade soon most,"Design morning total style during blue recent those. Political TV pull student.
Ask so conference bill.
Spring sing approach reflect down staff. Officer knowledge cause affect quickly.",713.00,https://dummyimage.com/649x862
352,Hot good,"Professor response anything official. Individual gas food become woman. Meet discussion first score participant professor.
Care Congress drop think mean red. Structure wife six education.",205.00,https://dummyimage.com/315x474
353,Interest brother,Mission party no collection ability bar. Push history local store nearly who person. Drive few however how treat three left.,832.00,https://dummyimage.com/129x291
354,Mr professional miss,"Shake energy live special official must amount. His among also have back.
Those space surface common reduce lead. To least drug mouth. Religious place wait business.",487.00,https://dummyimage.com/262x809
355,Training impact near,"Truth book certainly soon somebody not including. Store hear exactly ball themselves forward pull.
Food fire model last sort. Especially go industry message national never.",547.00,https://dummyimage.com/464x250
356,Attorney seven,Must happen occur land special a court. House where call effort activity learn investment these. Myself evidence city policy woman upon.,755.00,https://dummyimage.com/109x585
357,Appear million yourself second,"General body behavior head no card subject. Artist it yes how. Human man morning bank product still whose.
Once again home lay loss gun. Pick check stop scientist call source.",269.00,https://dummyimage.com/771x305
358,Trial Democrat,Teach issue TV act different student. Drop open exactly major ever these kitchen. Consider whether pretty wind bad front.,939.00,https://dummyimage.com/400x812
359,Between responsibility law,"Style couple take short sell. Thing feel leader official outside cut scene. Left current adult often.
Skill suffer site page book task live. Crime direction staff.",390.00,https://dummyimage.com/858x752
360,Teacher practice contain,"Team scientist grow all event arm rule. Head upon why arrive.
Population enjoy structure. Break vote open clearly. Free production together program.",938.00,https://dummyimage.com/242x853
361,May fly however,Eat long white world. Wind public author live. Together cause bar travel situation report film.,145.00,https://dummyimage.com/983x485
362,Record cold,Fight treat former state growth kitchen. Involve easy material yet research.,293.00,https://dummyimage.com/406x559
363,West back old,Wife off run again. Happen condition section prevent explain.,749.00,https://dummyimage.com/557x643
364,Skin whatever evening,"Table fire mean carry agree anyone decide continue. Six prevent hour well suffer thank really.
Then lawyer want travel. Treat stage do call past teacher range. Congress support hold.",504.00,https://dummyimage.com/431x784
365,Position,"On half thing. Probably decision every myself. Option many should fact consumer kid who it.
Onto brother let four in idea try bill. Much fight training trial. Them card car process.",234.00,https://dummyimage.com/700x632
366,Instead smile,"Reality course see whether leg respond prevent low.
Trip brother everything notice certain police name. Police deep war.
Western full nearly there cell better.",939.00,https://dummyimage.com/765x137
367,Generation game,Attorney give course administration many city language. End throughout share writer seat modern. Animal main wide air indicate.,945.00,https://dummyimage.com/768x721
368,Foreign face at,"Wall mission figure. Agreement service bad institution Democrat.
Treat focus wall eat side wall sign. Talk our though its. No life billion development short firm call.",549.00,https://dummyimage.com/875x819
369,Sing act,"Though without beyond. Material next general style region kid. South culture family else attack mind.
Person great nice. Model movement once matter consumer most.",416.00,https://dummyimage.com/936x666
370,Action artist business,Remember near glass center central cup try benefit. From hold hour structure break. Recent how society place between then a reason.,495.00,https://dummyimage.com/119x666
371,Group air,"Natural watch final. Song law white ask where field woman. Growth face raise base cut hundred experience.
Parent player its per wait. Ready step everybody argue hold month.",211.00,https://dummyimage.com/860x458
372,Up,"Prevent accept idea staff. Team ever indeed story. Late all seat need manage television.
Begin style see floor road people. Everything discuss politics management time ahead.",283.00,https://dummyimage.com/230x962
373,Discover collection,Condition night everyone present. Language hot here opportunity total. Whose knowledge read air most show blood. That chair laugh though themselves.,486.00,https://dummyimage.com/604x871
374,Public for,"Must growth computer safe top build. Prepare drug usually case speech. Travel effort individual white draw skin.
Subject send instead stage.",663.00,https://dummyimage.com/985x998
375,Movement west,Father significant factor five reason score serious receive. Defense agency animal author south Congress enough assume.,498.00,https://dummyimage.com/310x332
376,Team although from,"Technology money already forward. Responsibility environment west exist total seem whether. Line process civil lot world.
That open determine get red mouth. Enter create avoid history life.",883.00,https://dummyimage.com/844x147
377,Less large bad,"Magazine sister quickly try free sister. Certainly mission such nature.
If build firm beyond score how. Push local news on together notice. Indeed increase finish professor personal.",488.00,https://dummyimage.com/835x488
378,West maybe,"Attorney compare smile chair each. State back movement example floor.
Best management court fly sure explain. Add report new trip option floor country.",409.00,https://dummyimage.com/646x561
379,Information center,"Yard sea window it. At few bad business we. Guess fact seven consider relate.
Here something wall voice relate determine part behavior. Just office store country professor create play out.",836.00,https://dummyimage.com/952x825
380,Happen adult,"Conference recent assume campaign dream over commercial. Find hard series middle little former.
Whom street read analysis sound. Capital week about data. Sea approach use standard rich join involve.",499.00,https://dummyimage.com/920x905
381,Interesting once heart,Hospital media trade glass dinner simple. Experience expert not involve right card use. During free its eight age piece.,457.00,https://dummyimage.com/306x591
382,Course bar,Often look American. Successful poor local mission this upon. Of political else by condition list feeling.,230.00,https://dummyimage.com/856x567
383,Hard oil major,"Region difficult simply total serve information.
Fear will husband interview game week light. First learn concern cup. Others me record set than protect. Break style type decade your account police.",276.00,https://dummyimage.com/548x796
384,Full should,"Let room source next sound. Speak chair first morning significant at.
Look life care may. Election draw eight we worry. Give change respond camera board.",604.00,https://dummyimage.com/193x440
385,Because member approach,"Administration Mr star news describe. Say enter less throw appear establish try.
Something recognize but per attorney a. Investment national training history leg trade. Fact sing former.",151.00,https://dummyimage.com/272x912
386,Always behind,"Air term power few recognize north take. Painting year century difficult himself. Develop turn sense.
Consider decide real.
Choice test many well direction color. Window customer section city.",182.00,https://dummyimage.com/767x525
387,Area open,"Among election upon hard there. Develop boy discuss guess bit.
Whom anyone mean interesting so local identify front. Property long blood keep do. Keep common who part per.",675.00,https://dummyimage.com/149x433
388,Finally drop,"Red tree remember five. Surface large need machine. Entire environmental my style.
Do apply believe determine story. Woman particularly education become those series.",79.00,https://dummyimage.com/490x488
389,End let your,Common quality answer action measure discover almost. Woman any record computer reason dark every. Near modern chair participant rise tell on.,797.00,https://dummyimage.com/650x236
390,Poor thus glass,"In small reality reality. Candidate compare able music.
Cold ahead administration fly board.
How popular oil common. Bed region design security face. Hand authority police radio technology.",494.00,https://dummyimage.com/478x623
391,Action even,"All machine Republican time wait. Next camera will.
Better each special list administration. Front year still science this thus. Seem understand try since do apply.",610.00,https://dummyimage.com/248x578
392,History six,"East stage picture man house benefit especially. Assume memory management low activity.
Ok color eye important. Produce so west arrive.",315.00,https://dummyimage.com/403x579
393,Middle after,Yourself however ability I my travel. Pass room memory feeling could may begin board.,983.00,https://dummyimage.com/542x603
394,Decade without heavy,"Near far together every bag discussion goal occur. Evening about understand.
Left loss economic policy against before often. Country both customer only whatever.",348.00,https://dummyimage.com/238x896
395,Low network,"Fast seek information little feeling else store. Health peace herself how candidate defense control. Hit agency others Republican seek cause themselves time.
Career gun front onto PM defense.",426.00,https://dummyimage.com/787x365
396,Light person,"Accept executive hit thank. Black easy many. Soldier western item speech stay wish black arm.
Ever management lay stuff. Music pressure approach gas none.",294.00,https://dummyimage.com/376x154
397,Add partner,Relate officer hotel sea public. Week under especially even. Management of protect career.,685.00,https://dummyimage.com/655x306
398,Any budget writer,"Oil west standard structure. System change until song edge more fight prove. State important mind why.
Year major example hand. Hour yes picture near speak.",601.00,https://dummyimage.com/534x275
399,Improve method back,Life different machine record green source cover. See affect discuss entire show. Two control federal perform put.,435.00,https://dummyimage.com/296x763
400,Perform pretty,"Turn budget along. Item level finish us pressure build. Girl site with alone attorney talk.
Party own apply behavior political middle college. Course measure month up. Color sing fire.",888.00,https://dummyimage.com/644x991
401,Over also economy,Mother computer happy these near. Owner fund look throw party three book yard. Fish movement focus answer include.,957.00,https://dummyimage.com/641x145
402,Cut any southern,"Little but again this clearly. Set protect control job. Address million per smile national cost base.
Girl number operation expect. Candidate blood while character later type.",337.00,https://dummyimage.com/649x326
403,Behavior,"Reason what build. Material exactly long.
Much century such entire again site. Spend edge majority act series group poor compare. Various although write central side significant matter start.",330.00,https://dummyimage.com/381x605
404,Impact conference audience,"And minute nation would. Attorney direction call quality eye nearly.
Program choice professor never staff. Same however public different. Despite increase ok director its include.",853.00,https://dummyimage.com/872x598
405,Prevent put,"Line continue political yourself news.
Thank kid base pressure try. Part where daughter since music although trial.
Mouth as place. Ask left author decide class instead. Treatment wide benefit price.",743.00,https://dummyimage.com/701x440
406,Benefit usually message,"Tend door himself yet member marriage budget less. Prove team especially.
Nearly kitchen seem magazine nation begin. Recently conference common organization respond believe.",906.00,https://dummyimage.com/928x658
407,Really land,"Cost care old agree.
Hot effort car cost television agree. Professional prepare avoid seem. How ahead nothing grow.",97.00,https://dummyimage.com/476x711
408,Cut himself,"Rate hold develop. Material follow truth long rest its. Page fast middle. East weight system action project improve win develop.
Camera common place present prepare imagine. Conference own door may.",478.00,https://dummyimage.com/286x116
409,Possible,"Central this interview a future culture white. Relationship floor form easy. Character her society forward fire drug score seat.
Sister century those effect me. Require lose morning itself.",448.00,https://dummyimage.com/844x135
410,Though focus responsibility,"Moment start direction health. Feel order government fall teach what. Ball agree indeed pick.
Loss often specific try natural ask save. Position another win administration citizen address big enough.",672.00,https://dummyimage.com/788x337
411,Support thought box,Forward out little family attention set. Nature talk mouth allow mean physical. Green story American step player.,309.00,https://dummyimage.com/857x930
412,Agreement partner factor,"Many hear heavy good financial way.
Fine face century knowledge. Voice morning particular act performance open area. Send again situation with.",117.00,https://dummyimage.com/804x400
413,Fall,"Miss mind science point real station policy. Tell culture mind without all theory.
Position hundred on. Dinner school authority accept.",335.00,https://dummyimage.com/999x491
414,Product my item,"Simply age speech cost. Cup wide out common season life describe. Sister plan degree outside.
Street night end. Design beat many student suggest involve vote.",924.00,https://dummyimage.com/505x791
415,Follow,"Few often degree party. Nor stock line.
Type future the sign subject. North our effort would fill. Sometimes culture drive base statement professional.",902.00,https://dummyimage.com/351x732
416,Believe social,Five fine fine series measure. Purpose training form structure white Mrs scene street. Right reduce money subject suffer law.,595.00,https://dummyimage.com/1000x673
417,Analysis minute,"Employee house such add former far. Hotel collection probably hair shoulder century color beyond.
Run age current agreement own. Wonder one within against claim budget. Explain wrong pretty if sound.",124.00,https://dummyimage.com/676x170
418,Seven executive,"Cold help career never. Thus boy drop happen.
Business car little there modern nice. Treat campaign write only that very brother.",598.00,https://dummyimage.com/598x895
419,Require address Democrat,Hair run reveal guy score home its. Sort while home fly eight security for understand. Time sell set major question police.,798.00,https://dummyimage.com/955x134
420,Capital letter,"Receive prevent apply realize month natural. Eat police few how nature.
Account new without specific. Keep management sort former.",53.00,https://dummyimage.com/839x930
421,Bill night fight,"Allow issue decade. Note as test record safe know. Something set social camera.
Owner him walk image could compare. Could throw answer eye.
May itself military soon. Treat since scientist medical.",813.00,https://dummyimage.com/535x962
422,Conference participant,Remain like standard. Dark culture citizen stand build such eat. Article between experience easy three Mr.,168.00,https://dummyimage.com/779x243
423,Cell door,"Individual professional pressure. Sign teach hot series source present spend.
Commercial white world. Organization become lose house under.",670.00,https://dummyimage.com/463x476
424,Begin democratic,Close specific defense wind mention national despite former. First just new college determine.,475.00,https://dummyimage.com/600x382
425,Information character nearly,"Take traditional include important voice board. Room fast economy present save.
Threat article field tell collection. Bring style gas age I key where even.",664.00,https://dummyimage.com/228x157
426,Democratic near painting,Live recent allow laugh. Yourself son what night once here mind floor. Value add yet oil scientist.,697.00,https://dummyimage.com/262x744
427,Here own,Thousand state compare successful reveal tough young also. Fear place control place. Child security point write. Left across truth reach myself together itself field.,950.00,https://dummyimage.com/495x725
428,Return she,Have control be week. Sort recently give year role section ready operation. Herself take quite rich all lay.,617.00,https://dummyimage.com/208x534
430,Front white as,"Bed when management believe. Several budget letter particular.
None hand medical source right role social attorney. Let start study difference big.
Number piece art officer price throw.",262.00,https://dummyimage.com/469x426
431,Child carry before,"Training manage magazine. Movie way visit throw star reason piece better.
Mention themselves should red red owner. Security open remember party few society.",430.00,https://dummyimage.com/129x536
432,Firm somebody forget he,"Campaign within herself Congress. Still level management story nation organization. Resource poor sea local American girl.
Play those employee then.",102.00,https://dummyimage.com/833x337
433,Dream fill cover,"Listen itself event green.
Charge bag thank fine tree person well report. Fine method by international continue Republican.",53.00,https://dummyimage.com/470x999
434,Blue,"Learn manage ready room realize. Game book away top little risk third manage.
Worker enter yard determine world particular debate way.",861.00,https://dummyimage.com/789x268
435,Economy understand,"Consumer cost cold ball girl believe. Pass of call do join tonight.
Big institution food look. Development green situation hard.",564.00,https://dummyimage.com/856x458
436,Game role one,"To them first sign certainly.
Painting artist boy. Often then occur democratic rise usually. Treat network spring eye real wind.",602.00,https://dummyimage.com/146x486
437,Then rest future television,"Service central miss represent personal threat discuss. Purpose week owner effort can.
Prepare goal tough rate set people. Dog girl population.",833.00,https://dummyimage.com/815x572
438,Do provide we,"Issue inside major pretty. Style trade eye. Last establish successful.
Deal financial sound whatever also whole. Record stand national practice record relate.",469.00,https://dummyimage.com/679x357
439,Tonight worry,"Child sure affect action baby moment alone.
Call point gun either little. Serious which position build.
Describe sit visit school pattern industry fight. Year senior air relationship.",240.00,https://dummyimage.com/638x594
440,Large house forward,"Past effect situation range say pass degree. Light note bring.
Rock brother Mrs marriage opportunity door evening. Off require different challenge.",702.00,https://dummyimage.com/811x270
441,Hospital management we,"Forward establish finish total matter. Floor worry every couple clear other.
View wish young voice. Important house treatment decade. Building something your serious happen. Boy machine better.",475.00,https://dummyimage.com/311x562
442,So current,Onto respond institution include indeed. Today south stop play true study despite. East able paper.,791.00,https://dummyimage.com/306x202
443,Analysis,Book red read free most break. Him while reduce pay page mouth. Possible action television thing parent age personal.,967.00,https://dummyimage.com/613x843
444,Southern guess,"Western yourself maybe. Else door inside discuss young smile. Sign hear dark deal.
Finish outside happen treat dinner scientist. Full loss prevent pattern. Push vote community story land.",946.00,https://dummyimage.com/462x764
445,Player usually,"Heart travel thing enjoy already institution without.
Pressure sport friend field worker inside. Scientist five generation political sing. Picture part develop beyond writer.",184.00,https://dummyimage.com/175x765
446,Although street,Degree mention TV development part whatever. Including put give strategy ask. Yourself high hundred plan respond song.,256.00,https://dummyimage.com/291x526
447,Soon audience,"Economic value why morning. Middle process treatment commercial sure president movie.
Sing really cut drop amount garden. Especially small within design figure.",667.00,https://dummyimage.com/609x451
448,Mrs citizen answer,"Evening under hour guess another even front. Detail check democratic issue.
Million ahead myself director. Use politics lead describe rule.
Born those whom your important. Cell social cultural air.",410.00,https://dummyimage.com/385x904
449,Professional affect rate city,"Local wear not world performance stand. Lose job raise culture push after. Positive once sell use keep.
Outside officer check call get hospital economic. Man course nothing.",290.00,https://dummyimage.com/895x581
450,Pull test,"Home within single conference list also. Listen former throw raise bag might fund.
Grow avoid product care over east tree. Nothing hospital together name customer.",405.00,https://dummyimage.com/929x430
451,Adult lot rather expert,"Model your financial note onto. Game article after institution old.
Certainly like treatment few blue own. Officer admit pattern people. Carry true everyone relate wall include nation.",999.00,https://dummyimage.com/213x881
452,Positive goal today,"Big remember action near four.
Break resource consider agency environment oil.
Effect rich paper will official. Yet rule student chance pretty assume. Century happy party.",630.00,https://dummyimage.com/105x529
453,Top hour true small,"Energy issue report improve. Upon he particular let. Just authority night figure.
Bit order always believe government find. Bit owner past. In event modern rather short.",529.00,https://dummyimage.com/281x201
454,Believe resource best,Plan of soldier black agent. Yes consumer address old across. Maintain too picture cup that course ready. Range time event.,542.00,https://dummyimage.com/256x956
455,Size quickly,"Mouth across leader strong person across adult director. Hour issue direction upon.
Design economic himself yeah interest. Manage full evening increase specific size.",962.00,https://dummyimage.com/553x537
456,Story public really,"Wall power more. Bed fill education two itself important.
Easy paper control walk party sing sound. Near material service sign. Interview exactly across nor soon American. Available very detail.",187.00,https://dummyimage.com/617x691
457,Visit despite,"Offer herself remain mind leg keep. Gun various fill candidate ahead. Network similar choice control model.
Choice major help skill station together allow.",516.00,https://dummyimage.com/990x998
458,Meet despite,"Enough almost ok. Real resource professional product compare local catch.
Skin off though in politics poor pick. Leg way person take. Accept meet reveal attention system tax.",63.00,https://dummyimage.com/392x528
459,Clearly player bed,"Two either build year. Available though record court group mother real ever.
Level page forget require ability success. Owner main important heavy reach under.",484.00,https://dummyimage.com/998x844
460,Apply someone doctor,"Keep read brother let beautiful. Everything in style message rule final name current. Hotel benefit card.
Manage coach reduce sense safe mind. Pick summer reason. Opportunity project police.",60.00,https://dummyimage.com/520x371
461,Remember without,"Security worry which bring ever training chair. Political every down call.
Call be class national town perhaps. Kitchen try least check chair thing.",489.00,https://dummyimage.com/363x532
462,South should,"Hold kid source always discussion push exist. Similar specific memory pretty upon exist collection. Could would each person head note.
School blood on relate.",749.00,https://dummyimage.com/409x974
463,However involve lose,"Respond receive particularly service compare present worry.
Expect certainly research start make should. Laugh concern up director growth find.",940.00,https://dummyimage.com/761x298
464,Hotel voice,Thousand three high spend future size himself. Stay various next not. Every office watch attorney measure.,628.00,https://dummyimage.com/842x647
465,Issue dinner,Major law treatment room. Short value red series. Dream street growth clearly fish compare. Operation understand around ground important.,607.00,https://dummyimage.com/590x136
466,Watch fire,"Yeah something despite sometimes instead color idea. Up range morning tough.
Body nearly fly finally kind instead policy west. Record agency left ready section cold.",823.00,https://dummyimage.com/890x236
467,End military prepare,Military make peace world. Vote when hold future.,298.00,https://dummyimage.com/202x429
468,Investment just candidate prevent,"Because three easy.
Couple run consider house market discussion baby. Exactly science third card whole decision newspaper.",952.00,https://dummyimage.com/680x768
469,Program throughout from reason,"Event fear job trial long. Pm word produce level occur agent. Maintain good rich care truth material their.
Door probably base. Science base born avoid various.",79.00,https://dummyimage.com/264x840
470,Help have,"International another stop say boy east.
A any successful defense structure morning matter. Note yet general center say short human. Reveal over suggest.",721.00,https://dummyimage.com/463x393
471,Deal body,"Maybe deep bank once. Skill actually get. Picture town public catch need nothing seat.
Person hard record imagine man. Behavior order face support.",503.00,https://dummyimage.com/613x266
472,Anything according economy,"Manager watch more. Require between movement. Home have beautiful such.
Yard city picture dog type enough. Fine people cause beat no. Set again whose difficult amount cut.",727.00,https://dummyimage.com/666x904
473,Serious environment,"Treat tax remember task ready. Security shoulder evidence child become let.
Exist though now simple much common. Suggest simply financial among argue until everyone.",150.00,https://dummyimage.com/400x195
474,Voice behavior,"Work city scientist. Hot audience finally already.
Generation write stock successful until practice. Physical pattern each yard grow.
Six bring set right. Evening who home military to cell.",545.00,https://dummyimage.com/858x401
475,Drug various,"Break cup agreement no college pass everyone. Significant interesting board from. Opportunity wide admit.
Drug piece me executive. Down some which their.
Best discuss while. Top factor without might.",607.00,https://dummyimage.com/665x116
476,Night although,"Beat front get throughout. Station budget develop call positive child. And report fall us.
Investment collection authority worry identify save theory. Hot care nature.",885.00,https://dummyimage.com/632x594
477,Spring concern,"Require stock degree idea.
Little enjoy city audience per what. Economic throughout child body relationship would.",74.00,https://dummyimage.com/815x590
478,Cost allow,"Rather policy sign piece hold suffer. Boy image toward member billion.
Town if property light. Open however expert half cause have.",566.00,https://dummyimage.com/905x801
479,Own,Type east yes crime. Natural soon business tell nation. Discuss history court than call discuss.,906.00,https://dummyimage.com/856x989
480,Set so give,Something second this like realize difference. Card time old affect. Method choice camera follow girl.,638.00,https://dummyimage.com/500x742
481,Movement others develop,Memory talk central purpose reality investment quickly. Your thought way thing. Sort crime watch save consumer news.,849.00,https://dummyimage.com/549x246
482,Cultural song page another,"Knowledge this available then month black peace skill. Program toward officer agent deep our will. Simple drive necessary box.
Accept purpose big last. Though per enter system.",58.00,https://dummyimage.com/177x912
483,Natural Mr,Across partner direction mention. Amount kind despite two military media. Interest authority usually power drop arrive old heavy.,117.00,https://dummyimage.com/891x565
484,Open myself about,"Nice majority far film capital talk. Item care full whose senior when trade. Here great company time piece bit be other.
Television how various let. Body although student night onto.",461.00,https://dummyimage.com/195x393
485,Region level available,How fly long loss. Century actually time speak will about. Table lot interest future source yourself.,267.00,https://dummyimage.com/280x276
486,Model push,Then as remain road. So successful throughout someone minute guess food piece. Together series happy election run draw system.,271.00,https://dummyimage.com/319x736
487,Before but his,Wide country understand everything save their. Market plant begin draw born. Most final because tonight president arm create between.,74.00,https://dummyimage.com/656x580
488,Think ground speak,Paper civil organization best rich. Three modern kind writer medical each. Just enough although finally suffer. Pm maintain least.,306.00,https://dummyimage.com/614x228
489,Night specific former,Notice ahead prevent call pull office general. Majority else talk boy. Population science cultural. Modern fire person difficult body else.,561.00,https://dummyimage.com/427x200
490,Inside among some,"Create sure fast road nearly partner personal unit. Argue better quality because.
Hot fight four necessary either listen process. Artist sell nothing language bed phone ground.",107.00,https://dummyimage.com/258x223
491,Too memory inside store,"Employee herself human. Choice discuss bed simply once of.
Cost or list cost along central. Various kid policy make.",794.00,https://dummyimage.com/949x933
492,Figure three,"Top participant close radio. Property director near. Let top seven clearly after.
Edge early system state themselves. Health reduce indicate century technology last after citizen.",355.00,https://dummyimage.com/879x847
493,Go something,Station shake production personal trouble. Voice audience series change wrong sit. Firm age suffer company nice.,776.00,https://dummyimage.com/373x544
494,Choice north,"Financial live need at reality rest down. Dark yeah blood hair health cut out. Style tonight economic. Officer east second coach image attention.
Order whose blood.",141.00,https://dummyimage.com/110x968
495,Affect travel,"Set girl century participant. Material have student sure involve.
Travel none together end name. Clearly run lot whatever garden among you practice.",808.00,https://dummyimage.com/264x701
496,Building their,"Color strong establish audience though. Civil base federal town. Language physical agent collection camera go.
Such think artist good.
Black parent throw. Other toward many develop live.",184.00,https://dummyimage.com/338x795
497,Image here another,"Share team find couple support. Institution thank skill cover even second chance.
Court statement administration modern add remain collection. While quickly marriage sound law.",537.00,https://dummyimage.com/504x925
498,Popular again public,Party hold once under mouth. Else medical job chair game analysis. Increase past themselves region.,709.00,https://dummyimage.com/626x727
499,Discussion color story,"Event employee term personal want continue. Know any culture now court close bit. While ahead official factor.
Leader claim sound. Anyone call American matter type.",267.00,https://dummyimage.com/484x666
500,Of people against,"Leg put they capital possible.
Up statement become address. Million direction how happen argue hotel evening left.
Would whole reality. Account miss specific. Teach enjoy choose daughter save hot.",350.00,https://dummyimage.com/926x859
501,Book area most,"Section level beyond who civil. Decide statement hard relationship fact.
Service them thank know.",345.00,https://dummyimage.com/234x340
502,You fly,"Huge baby black call treatment church Mrs training. Little above science opportunity result.
Individual Democrat board still glass.
No region discuss speech walk.",486.00,https://dummyimage.com/295x747
503,Central common behavior tax,"Rule choose along bad agent specific loss. Indeed read again short trial.
Hot strategy who improve your hold leave. Mind year oil mind away kid.",584.00,https://dummyimage.com/730x345
504,Window common,"Fill lose the sing recent television seven. Food body political media. Act manage real carry these decide.
Fly property paper spend. Share edge three hand true. Owner oil century edge under issue.",96.00,https://dummyimage.com/502x750
505,American close join,"Federal culture base police data. Government tree north north president some.
Stage store close check commercial respond. Truth interest decade their by.",137.00,https://dummyimage.com/131x456
506,Evening office,"Return word somebody billion training billion wrong.
Issue dinner particularly. Case allow situation that road heart.
Reflect within really star technology where situation.",805.00,https://dummyimage.com/363x393
507,Street skill drive,"Near choose plant again.
Recent role performance way experience consider occur. Past we while laugh.
Claim sort personal there office possible. Really front high off. Explain interesting country.",84.00,https://dummyimage.com/412x823
508,How power leave,"Article these each individual successful. Total up official fine. Trial majority dark type instead.
Table citizen production late board someone. Young firm nearly learn PM main space.",232.00,https://dummyimage.com/947x147
509,Under value exactly,While color available stock push plant foot. Into determine might worry interest if wear. Well cultural nice official fear situation either.,665.00,https://dummyimage.com/567x341
510,Change,Indeed standard thought join former community. Democratic community establish. Effort leg manager. Meeting state today would cup.,721.00,https://dummyimage.com/787x268
511,Team whole,"Mention often upon also hot early. Single consumer site their already expert hear area.
Rise else admit member. Dog pressure hair when listen allow a which.",968.00,https://dummyimage.com/719x896
512,Necessary finish,"Woman analysis later.
Happy fill drug drop situation. Book me structure news easy throughout current. Third east song wife rise no.
Design response player. Rise at area claim either leg power.",334.00,https://dummyimage.com/513x618
513,Late finish factor,"Investment stay morning section process.
Issue choose teacher country candidate. Common capital consumer senior party high others rate.
Responsibility will none training.",853.00,https://dummyimage.com/700x894
514,Race attorney north,"Central kid always or. Reflect meeting significant treat.
Call health activity. Before hair avoid property defense technology rest. Politics trade than piece debate ready.",94.00,https://dummyimage.com/999x854
515,Leg simple trial,Force woman anyone they. Institution play common human. New after attorney listen. Certainly morning hear physical still on may though.,462.00,https://dummyimage.com/746x522
516,Seat born,"Half control agree put never leg card. Bank whatever leave bit.
Environmental field dream tell sea lose part. Guy fight later guess.",526.00,https://dummyimage.com/181x814
517,Still something yet woman,"Pick mind during prevent when debate. Realize body region seat. Let sister out agree past.
Much lose just health goal. Sea help water imagine.",114.00,https://dummyimage.com/144x361
518,Go management dream,Us us how reveal seven imagine. Section hit force resource know company outside. Change hair turn wall eat.,832.00,https://dummyimage.com/951x727
519,News,"Religious watch appear. Television major cause human rule model affect.
Artist sing window. Me then soon something.
Life thousand want trouble. Product standard guy site garden discussion talk.",108.00,https://dummyimage.com/644x228
520,Sign difference score,"Actually close machine case someone. Staff receive between name which environmental nearly.
Event physical drop good. Continue its form agreement.",834.00,https://dummyimage.com/255x727
521,Another agree,"Air yet address nation notice. Threat time possible early last stock interview. Shoulder year tonight serve college. Keep newspaper total energy expect official their.
Money focus billion key.",67.00,https://dummyimage.com/368x151
522,Surface country difference,"Operation wear attorney claim like chair itself.
Enter why heart hotel. Good subject huge father radio feeling authority. In color family head page civil job.",746.00,https://dummyimage.com/523x416
523,Somebody sister media,Certainly subject sell cup. Model father for small pick phone debate single. Ahead physical skill decision choose.,161.00,https://dummyimage.com/522x167
524,Model exist,"End activity remain natural. Any simple act hot mouth two.
Writer face someone. Perhaps difference cause result everybody.",423.00,https://dummyimage.com/256x953
525,And edge,Statement share decide strategy thousand discover daughter. Statement far provide because same. Major thousand gun notice teacher more teach.,295.00,https://dummyimage.com/343x165
526,Wish away,"Full worker hair. Research within perform trouble produce. Station television piece fish. Agency day rest effort focus.
Hard individual drop huge act do. Mind may hair could.",213.00,https://dummyimage.com/857x105
527,Maybe computer,"Base represent I. Wrong person social.
Nearly interest receive cause attack. Without soon begin something spend avoid ever.",174.00,https://dummyimage.com/349x751
528,Threat manage history general,Sing music more enter. Cultural up decade to lawyer usually information. Camera course each central understand them.,136.00,https://dummyimage.com/645x938
529,Sometimes view not,"Reveal serve mission whose. Chance through scene best your American town.
Yet customer table. Food financial wind.",858.00,https://dummyimage.com/451x150
530,My should spring,"Mr home weight itself sort up. Responsibility return close fall total public newspaper.
Practice thank hope food. Happy week end understand stay discussion. White trade bank others.",824.00,https://dummyimage.com/725x429
\.

-- orden
COPY public.orden (id, fecha_creacion, fecha_entrega, direccion_entrega, usuario_id) FROM stdin WITH (FORMAT CSV, DELIMITER ',', FORCE_NULL (fecha_entrega));
1,2015-02-15 02:49:23.807671 +00:00,2015-05-15 06:49:23.807671 +00:00,"5460 Ellis View Shannonburgh, TN 49985",1
2,2020-02-11 16:58:44.490026 +00:00,2020-02-16 11:58:44.490026 +00:00,"2679 Karen Green Suite 783 East Jennifer, PW 21130",2
3,2025-08-30 09:11:13.094262 +00:00,2025-09-24 19:11:13.094262 +00:00,"PSC 3758, Box 9248 APO AP 84244",2
4,2017-10-25 13:57:51.539760 +00:00,2017-12-14 08:57:51.539760 +00:00,"963 Hubbard Lock West William, PA 83745",2
5,2025-08-24 06:29:18.010454 +00:00,,"5460 Ellis View Shannonburgh, TN 49985",2
6,2025-07-17 18:34:37.416858 +00:00,2025-08-28 10:34:37.416858 +00:00,"25536 Gutierrez Knoll Jamesburgh, RI 68494",2
7,2011-10-08 20:45:09.378441 +00:00,2011-10-30 22:45:09.378441 +00:00,"81482 Daniel Drive South Amandashire, LA 88306",2
8,2020-05-22 10:54:50.644772 +00:00,2020-08-02 07:54:50.644772 +00:00,"72938 Sean Island Suite 046 Richardland, OR 81504",2
9,2018-01-27 20:06:26.105401 +00:00,2018-04-23 11:06:26.105401 +00:00,USCGC Walsh FPO AE 11366,2
10,2023-11-10 04:29:36.069182 +00:00,2024-02-10 11:29:36.069182 +00:00,"8885 Michael Place Wrightchester, WA 32699",3
11,2025-09-11 16:14:44.998371 +00:00,,Unit 6351 Box 1823 DPO AE 32292,3
12,2023-02-15 23:10:40.981880 +00:00,2023-02-23 01:10:40.981880 +00:00,"PSC 2643, Box 5872 APO AA 12490",3
13,2017-04-18 18:37:19.227494 +00:00,2017-06-12 08:37:19.227494 +00:00,Unit 5926 Box 0209 DPO AP 22365,3
14,2010-05-21 01:49:27.916885 +00:00,2010-08-09 11:49:27.916885 +00:00,"03041 Castaneda Mews Apt. 532 Jeffreymouth, TX 66784",3
15,2019-10-29 02:10:39.220099 +00:00,2019-12-09 03:10:39.220099 +00:00,"336 Jimenez Valley Apt. 471 Port Curtis, KY 06471",3
16,2019-08-03 13:45:25.648873 +00:00,2019-09-08 14:45:25.648873 +00:00,"8791 Leslie Burgs Apt. 138 South Jennifer, NC 78365",4
17,2025-07-12 16:02:19.011547 +00:00,2025-09-06 22:02:19.011547 +00:00,"5235 Yang Villages Apt. 266 Davidborough, MD 12822",4
18,2023-10-04 14:20:19.542081 +00:00,2023-11-19 15:20:19.542081 +00:00,"4283 Meyer Junctions Suite 485 New Kyle, MO 37347",4
19,2025-07-15 05:26:37.306251 +00:00,2025-07-24 09:26:37.306251 +00:00,"153 Ashley Walk Apt. 870 West Ryan, VI 41068",4
20,2025-09-20 14:06:59.024677 +00:00,,"68718 William Bypass Nicoleside, TX 64010",4
21,2025-08-23 04:09:21.873680 +00:00,,"60896 Daniels Throughway Jameschester, ND 08798",4
22,2017-03-07 22:31:36.006528 +00:00,2017-05-31 02:31:36.006528 +00:00,"3728 Christine Flats Suite 482 Elizabethbury, IN 83851",5
23,2011-04-14 07:15:11.910396 +00:00,2011-06-30 19:15:11.910396 +00:00,"43050 Corey Route Apt. 150 East Aliciahaven, GA 68069",5
24,2017-02-14 16:07:23.277939 +00:00,2017-03-01 11:07:23.277939 +00:00,"1132 Combs Meadows New Matthewmouth, IA 61515",5
25,2019-04-07 07:59:28.655590 +00:00,2019-07-10 16:59:28.655590 +00:00,"276 Mark Union Baileystad, PR 98594",5
26,2025-09-14 06:54:18.206010 +00:00,,"4272 Turner Mountains Lake Joshuamouth, MD 05877",6
27,2022-11-02 09:05:36.207011 +00:00,2023-01-23 01:05:36.207011 +00:00,"76299 Erik Flats Suttonstad, NM 01505",6
28,2020-02-24 22:29:51.236554 +00:00,2020-05-20 13:29:51.236554 +00:00,Unit 2541 Box 5336 DPO AA 40289,6
29,2022-02-18 10:42:27.534178 +00:00,2022-02-28 20:42:27.534178 +00:00,"573 Romero Junction South Williamberg, MH 71910",6
30,2025-08-08 06:09:20.965884 +00:00,2025-09-11 00:09:20.965884 +00:00,"33257 Thomas Park Suite 377 Coxville, MP 56654",6
31,2014-10-07 11:49:51.511103 +00:00,2015-01-14 00:49:51.511103 +00:00,"5339 Michael Avenue Murrayshire, AL 72445",6
32,2025-08-29 02:07:32.006122 +00:00,2025-10-02 16:07:32.006122 +00:00,"50574 Theresa Center Suite 233 Jordanport, TN 61490",6
33,2025-09-25 02:42:47.478038 +00:00,,"50567 Richard Meadow New Bradystad, NC 37490",7
34,2023-06-17 07:33:13.049260 +00:00,2023-07-13 03:33:13.049260 +00:00,"0016 Sara Keys New Julieborough, IL 77926",8
35,2019-12-24 18:19:50.327383 +00:00,2020-01-01 16:19:50.327383 +00:00,"096 Justin Courts Apt. 921 East David, KS 42542",9
36,2025-08-22 02:34:45.215590 +00:00,2025-09-26 02:34:45.215590 +00:00,"0225 Catherine Ranch Jenniferview, ME 92854",9
37,2022-04-06 10:59:35.809143 +00:00,2022-05-06 05:59:35.809143 +00:00,"227 Huber Mews Davidmouth, IN 02730",9
38,2018-07-26 22:58:46.060460 +00:00,2018-09-07 05:58:46.060460 +00:00,"20197 Beverly Unions Port Angela, FL 62208",9
39,2025-08-09 00:29:49.500717 +00:00,2025-09-20 02:29:49.500717 +00:00,"6377 Pope Greens North Ritaburgh, MN 61612",10
40,2025-09-20 20:46:29.887271 +00:00,,"81952 Ryan Ports Schneiderfort, NC 13567",10
41,2015-07-10 07:07:59.785722 +00:00,2015-08-03 01:07:59.785722 +00:00,"2063 Boyd Estate Apt. 945 Lake Keithport, AL 92567",10
42,2025-07-11 18:45:07.462559 +00:00,,USCGC Ramirez FPO AP 14343,10
43,2016-03-31 23:28:16.694020 +00:00,2016-07-09 18:28:16.694020 +00:00,"4988 Johnson Circles Lake Troy, WA 99292",10
44,2025-08-03 04:14:14.655516 +00:00,,"52850 Anna Lake Hamptonport, NV 37829",11
45,2011-09-24 14:07:14.210017 +00:00,2011-12-17 08:07:14.210017 +00:00,"9131 Dustin Isle Apt. 527 East Connieberg, WA 67292",11
46,2025-07-04 14:35:22.367821 +00:00,2025-08-06 02:35:22.367821 +00:00,"9010 Kimberly Street Suite 211 Keithberg, MO 30684",11
47,2015-12-07 01:02:51.475794 +00:00,2016-03-05 15:02:51.475794 +00:00,USNS Walker FPO AA 36971,11
48,2012-09-16 09:21:27.770251 +00:00,2012-11-19 03:21:27.770251 +00:00,"52500 Hall Cliff Apt. 525 Port Wendyfurt, VA 86178",11
49,2025-07-05 11:12:14.714470 +00:00,2025-08-24 11:12:14.714470 +00:00,"63810 Rosales Viaduct Mirandashire, NV 83398",11
50,2013-04-28 01:23:08.586861 +00:00,2013-05-15 13:23:08.586861 +00:00,"431 Joshua Drive South Jesse, DE 14230",12
51,2025-08-15 09:19:35.584740 +00:00,2025-09-25 15:19:35.584740 +00:00,"9129 Fox Shore Apt. 471 Timothymouth, OH 43813",12
52,2019-06-16 12:37:19.977874 +00:00,2019-07-22 13:37:19.977874 +00:00,"9227 David Lake Suite 847 Chenville, FL 24358",12
53,2011-01-29 23:22:22.316824 +00:00,2011-02-13 18:22:22.316824 +00:00,"986 Smith Oval Apt. 665 North Kimberly, WI 13056",12
54,2018-09-16 23:49:27.610761 +00:00,2018-10-04 16:49:27.610761 +00:00,"PSC 2062, Box 7217 APO AP 83015",12
55,2013-07-24 14:04:18.238228 +00:00,2013-10-29 16:04:18.238228 +00:00,"314 Romero Tunnel Apt. 213 North Alan, VT 07065",12
56,2025-07-11 02:01:41.914514 +00:00,2025-08-08 20:01:41.914514 +00:00,"8500 Horn Fields Suite 631 Ramseyfurt, WI 00954",12
57,2018-07-13 10:45:33.863378 +00:00,2018-08-09 02:45:33.863378 +00:00,"562 Torres Pass Apt. 619 Codyfort, PA 09550",13
58,2014-02-21 20:41:41.381572 +00:00,2014-03-13 00:41:41.381572 +00:00,"8046 Herrera Ports Michaelburgh, FM 91950",13
59,2025-07-20 21:19:41.232618 +00:00,,"84413 Tammy Fork Apt. 921 Amyshire, NM 36562",14
60,2022-04-28 13:45:24.185671 +00:00,2022-05-24 04:45:24.185671 +00:00,"439 Andrew Club Apt. 057 North Michaeltown, MS 50183",14
61,2015-02-07 11:25:12.914748 +00:00,2015-02-11 10:25:12.914748 +00:00,"61965 Michelle Square West Kelsey, ND 74864",14
62,2019-04-26 00:40:53.855361 +00:00,2019-07-07 07:40:53.855361 +00:00,"9903 Hansen Circle Suite 084 South Brandy, AS 89962",14
63,2021-03-22 09:16:40.914548 +00:00,2021-04-01 19:16:40.914548 +00:00,USS Solomon FPO AA 10240,15
64,2012-12-19 03:26:26.470878 +00:00,2013-01-20 15:26:26.470878 +00:00,"343 Williams Gardens East Rachelhaven, AK 08480",15
65,2025-08-09 23:59:35.929286 +00:00,2025-10-01 21:59:35.929286 +00:00,"848 Beck Knolls Suite 218 Montesmouth, AK 85488",15
66,2018-04-08 05:22:57.700617 +00:00,2018-06-06 19:22:57.700617 +00:00,"17557 Warren Unions Yvetteborough, ME 55786",15
67,2025-09-02 20:40:08.821370 +00:00,,"595 Dwayne Path Suite 706 Lake Laura, ME 17833",15
68,2010-02-06 10:17:02.958155 +00:00,2010-02-17 11:17:02.958155 +00:00,"29002 Kellie Throughway Apt. 415 New Meganshire, MS 29236",15
69,2025-09-15 13:45:34.366861 +00:00,,"3490 Johnson Village Apt. 549 Port Jacob, CO 65642",16
70,2019-12-13 06:16:26.019054 +00:00,2020-01-31 05:16:26.019054 +00:00,"0555 Deanna Stravenue Suite 991 Lake Jamesfort, AL 41694",16
71,2025-09-23 23:05:50.819410 +00:00,,"7627 Jennifer Trail Apt. 578 Port Krystalbury, VI 34703",16
72,2023-07-27 09:47:38.351927 +00:00,2023-09-29 08:47:38.351927 +00:00,"7174 Jones Curve Suite 562 Bensonberg, AK 44413",16
73,2025-07-12 22:01:18.836859 +00:00,2025-08-09 05:01:18.836859 +00:00,"3877 Copeland Crossing Donaldfurt, WI 82875",16
74,2020-12-24 21:30:14.702737 +00:00,2021-01-11 19:30:14.702737 +00:00,"70019 Spencer Grove Apt. 509 West Michaelside, HI 11010",16
75,2025-08-25 05:41:27.504384 +00:00,,"365 Jamie Corners Andrewstown, KY 99433",17
76,2022-07-21 12:26:45.950989 +00:00,2022-08-30 17:26:45.950989 +00:00,"PSC 4288, Box 6678 APO AP 33268",17
77,2016-09-10 20:32:03.195741 +00:00,2016-09-22 22:32:03.195741 +00:00,"18486 Baldwin Plaza Suite 187 New Josephhaven, WY 67625",17
78,2021-10-22 15:32:14.092951 +00:00,2022-01-13 13:32:14.092951 +00:00,"244 Higgins Crossroad Peterhaven, VA 94019",17
79,2025-05-03 14:38:47.865580 +00:00,2025-08-10 13:38:47.865580 +00:00,"562 Wong Orchard Donaldshire, ME 62970",18
80,2015-05-30 18:23:23.240602 +00:00,2015-06-04 23:23:23.240602 +00:00,"64162 Bradley Rapids Suite 448 West Melissashire, NM 96681",18
81,2013-10-26 04:23:46.936800 +00:00,2013-11-15 19:23:46.936800 +00:00,"15026 Joseph Ports Apt. 935 New Oscarport, PR 51696",18
82,2019-02-21 22:26:09.704965 +00:00,2019-04-16 01:26:09.704965 +00:00,"88448 Crystal Green Apt. 419 East Megan, AK 92094",18
83,2025-07-15 02:49:57.801521 +00:00,2025-07-22 19:49:57.801521 +00:00,"80969 Jeffery Curve Suite 687 Amandastad, NH 84430",18
84,2010-01-15 15:20:24.348014 +00:00,2010-02-01 02:20:24.348014 +00:00,"PSC 5702, Box 7093 APO AP 65493",19
85,2025-07-25 00:12:01.312175 +00:00,,"1772 Armstrong Mill Apt. 809 Smithside, IN 54524",19
86,2025-09-26 16:14:14.508222 +00:00,,"536 Gerald Lane Port Michaelmouth, DC 70335",19
87,2022-04-18 17:01:11.563260 +00:00,2022-05-03 07:01:11.563260 +00:00,"98032 Tammie Springs Hubbardburgh, SC 93318",19
88,2025-07-28 23:28:40.024205 +00:00,,"495 Theresa Estate Apt. 572 West Marcus, IL 04601",19
89,2013-06-30 11:44:17.700993 +00:00,2013-08-26 08:44:17.700993 +00:00,"213 Mccall Brook Baldwinhaven, CT 20431",20
90,2025-07-30 21:22:29.403136 +00:00,2025-08-11 03:22:29.403136 +00:00,"289 Mcbride Burgs Apt. 066 Melissatown, VA 76648",20
91,2025-07-02 06:23:01.179452 +00:00,2025-08-09 14:23:01.179452 +00:00,"71320 Charles Grove Apt. 710 New Lee, NV 07474",20
92,2015-05-19 03:51:28.909842 +00:00,2015-07-21 16:51:28.909842 +00:00,"2059 Christine Center North Nathaniel, WI 21998",20
93,2025-08-22 00:32:36.960116 +00:00,2025-09-13 07:32:36.960116 +00:00,"8111 Mckinney Motorway Suite 425 Caseyland, AL 03303",20
94,2025-09-27 15:16:23.410451 +00:00,,"928 Shea Valley Gwendolynborough, NJ 34976",20
95,2013-04-25 14:08:53.981423 +00:00,2013-05-12 11:08:53.981423 +00:00,"377 Schmidt Shoals Suite 067 Garzabury, CO 47601",21
96,2021-08-20 09:31:14.527822 +00:00,2021-09-04 04:31:14.527822 +00:00,"3878 Hansen Crescent Apt. 705 Lake Andrew, IL 56553",22
97,2020-10-18 04:08:41.901877 +00:00,2020-10-30 11:08:41.901877 +00:00,"2127 Leslie Inlet Lake Ellenville, MD 77112",22
98,2025-08-12 12:48:30.951783 +00:00,,"0953 Howell Throughway West Helen, LA 92205",22
99,2017-12-19 04:15:33.770583 +00:00,2018-03-17 02:15:33.770583 +00:00,"17707 Snyder Vista Ericton, PW 99588",22
100,2010-11-23 08:52:55.355332 +00:00,2011-02-11 18:52:55.355332 +00:00,"80409 Teresa Spur Apt. 020 West Erica, OK 91898",22
101,2018-06-10 06:06:58.136713 +00:00,2018-09-11 14:06:58.136713 +00:00,"188 Dorothy Dam Suite 795 Port Erik, KS 53767",22
102,2012-10-20 04:15:52.296023 +00:00,2012-12-12 22:15:52.296023 +00:00,Unit 8777 Box 9030 DPO AE 68407,23
103,2016-11-24 04:47:27.515013 +00:00,2016-11-26 01:47:27.515013 +00:00,"660 Austin Wall New Emilystad, MS 23361",23
104,2020-09-15 21:19:36.013015 +00:00,2020-12-22 19:19:36.013015 +00:00,"62737 Richard Ramp West Davidfort, DE 12257",23
105,2024-11-14 19:02:49.666387 +00:00,2025-02-11 18:02:49.666387 +00:00,"26602 Aaron Way Pageton, ND 52486",23
106,2018-12-30 06:57:12.824601 +00:00,2019-03-30 16:57:12.824601 +00:00,"92849 Swanson Knolls Gallaghershire, NC 90474",23
107,2016-02-24 07:58:20.427950 +00:00,2016-03-26 03:58:20.427950 +00:00,"662 Mcguire Union Apt. 932 West Hannah, PW 03729",24
108,2012-01-16 16:30:32.344521 +00:00,2012-03-06 16:30:32.344521 +00:00,Unit 0018 Box 9499 DPO AE 85022,24
109,2011-10-23 13:25:30.816166 +00:00,2011-12-04 00:25:30.816166 +00:00,"59758 Brown Ridge Apt. 559 Williamschester, AZ 07251",25
110,2010-01-03 11:29:28.811241 +00:00,2010-01-07 05:29:28.811241 +00:00,"5887 Amy Forge Williamsmouth, FM 16644",25
111,2018-03-21 10:41:59.601815 +00:00,2018-04-12 07:41:59.601815 +00:00,"486 Johnson Mountain Annaland, NY 91408",25
112,2025-07-19 15:20:15.290169 +00:00,,"37586 Carr Valley Heatherton, NV 93647",25
113,2019-07-31 10:53:07.168323 +00:00,2019-10-29 10:53:07.168323 +00:00,"78645 Brittany Bridge West Sheila, NM 83714",25
114,2025-09-11 20:03:12.688355 +00:00,,"043 Meza Viaduct Suite 230 Flemingfort, MT 45645",26
115,2021-06-14 10:03:20.844590 +00:00,2021-08-29 01:03:20.844590 +00:00,"5227 Walker Fork Alexandraville, DE 67038",26
116,2020-11-22 15:09:38.808411 +00:00,2021-01-24 03:09:38.808411 +00:00,"550 Gerald Mills Suite 488 South Norman, DC 95653",26
117,2013-07-08 12:52:23.564971 +00:00,2013-08-12 07:52:23.564971 +00:00,"852 Lowe River Hendrixshire, CA 23174",26
118,2020-05-06 13:24:28.240556 +00:00,2020-08-06 05:24:28.240556 +00:00,"661 Lowery Run Apt. 844 New Richardbury, IN 56065",26
119,2016-08-11 22:36:45.081752 +00:00,2016-09-04 11:36:45.081752 +00:00,"462 Oconnor View Antonioshire, PW 74911",26
120,2011-12-23 07:58:49.439993 +00:00,2012-03-03 08:58:49.439993 +00:00,"03047 Wilson Stream Barkermouth, MD 51538",27
121,2019-09-12 05:13:48.252769 +00:00,2019-11-11 15:13:48.252769 +00:00,"39150 Edward Point Suite 963 New Natalie, FL 64143",27
122,2014-12-20 22:18:13.859351 +00:00,2015-03-10 12:18:13.859351 +00:00,"165 Mark Wells Port Rachel, SD 75142",27
123,2025-09-27 04:19:53.575703 +00:00,,"911 Berger Circle Campbellborough, UT 10591",28
124,2013-08-02 10:45:28.337233 +00:00,2013-10-12 01:45:28.337233 +00:00,"6377 Pope Greens North Ritaburgh, MN 61612",28
125,2025-09-16 19:24:28.316891 +00:00,,"70481 Candace Fields North Matthewberg, GA 14563",28
126,2018-05-30 06:57:56.882188 +00:00,2018-07-29 16:57:56.882188 +00:00,Unit 0247 Box 9307 DPO AP 90069,28
127,2025-09-25 22:49:03.486933 +00:00,,"2276 Graham Circle Mcdowellville, CA 48787",28
128,2015-07-30 13:03:46.738642 +00:00,2015-09-19 04:03:46.738642 +00:00,"PSC 5586, Box 5989 APO AA 28374",28
129,2012-12-05 10:51:58.412035 +00:00,2013-02-12 19:51:58.412035 +00:00,"72819 Smith Square South Shawnshire, ME 87710",29
130,2025-08-28 17:31:43.059117 +00:00,,"36097 Roberts Summit Apt. 186 New Stephanie, LA 45613",29
131,2019-08-13 23:16:40.986010 +00:00,2019-09-21 22:16:40.986010 +00:00,"707 Raymond Keys Apt. 061 Tonyaborough, WV 90782",29
132,2023-12-01 05:18:53.039773 +00:00,2024-01-16 16:18:53.039773 +00:00,"01085 Fields Expressway Apt. 999 Luishaven, WY 30489",29
133,2018-07-17 05:57:11.344809 +00:00,2018-09-16 16:57:11.344809 +00:00,"441 Anthony Trace Kelleyport, VA 01581",29
134,2020-05-25 01:30:14.607268 +00:00,2020-07-17 09:30:14.607268 +00:00,"53137 James Courts Kimmouth, FM 08140",30
135,2011-01-30 18:48:09.489437 +00:00,2011-02-06 00:48:09.489437 +00:00,"08165 Richard View Lisaland, MO 09253",30
136,2014-12-02 23:51:14.059506 +00:00,2015-01-12 14:51:14.059506 +00:00,"02992 Johnson Mill Apt. 952 Deniseberg, MD 88541",30
137,2017-01-03 13:52:14.429632 +00:00,2017-03-25 04:52:14.429632 +00:00,"188 Valencia Grove New Patrick, NM 19091",30
138,2014-07-10 06:13:37.376799 +00:00,2014-07-22 03:13:37.376799 +00:00,"831 Edwards Flats Apt. 868 East Deanna, ME 35126",30
139,2024-09-22 19:18:24.199824 +00:00,2024-11-16 19:18:24.199824 +00:00,"54324 Watkins Mountains Spencerton, MS 45736",31
140,2012-08-02 13:17:42.313757 +00:00,2012-10-22 14:17:42.313757 +00:00,"9678 Glenn Lodge Apt. 260 Port Patriciamouth, WV 88847",31
141,2019-09-07 10:19:25.332142 +00:00,2019-10-22 00:19:25.332142 +00:00,"193 Morgan Centers Apt. 140 Martinezside, KS 55016",31
142,2015-07-09 02:59:44.078885 +00:00,2015-08-26 20:59:44.078885 +00:00,"0111 Harper Key South Jasonchester, UT 54383",31
143,2025-08-04 07:59:46.355513 +00:00,,"503 Adams Ville North Angela, NC 71702",31
144,2020-10-28 01:12:53.999639 +00:00,2021-01-29 09:12:53.999639 +00:00,"36940 Robert Lodge Suite 155 North Joel, RI 79343",31
145,2020-08-23 20:59:03.359447 +00:00,2020-09-28 16:59:03.359447 +00:00,"4904 Amy Dam Suite 204 South Susan, MP 99652",31
146,2025-04-03 01:57:48.796939 +00:00,2025-05-04 07:57:48.796939 +00:00,"44875 Amanda Mountains Apt. 738 Jonestown, GU 11668",31
147,2017-08-09 18:45:59.678174 +00:00,2017-10-04 19:45:59.678174 +00:00,"5046 Rios Heights Suite 311 North Crystalton, PR 80752",32
148,2012-01-04 05:07:52.339551 +00:00,2012-01-20 06:07:52.339551 +00:00,"72149 Lisa Knoll Apt. 184 Darlenemouth, MI 07694",32
149,2014-04-04 16:22:18.708127 +00:00,2014-05-03 15:22:18.708127 +00:00,"808 William Roads South Rebeccatown, PA 17599",32
150,2011-11-30 16:32:02.980565 +00:00,2012-02-17 00:32:02.980565 +00:00,"51814 Michelle Valley Apt. 968 Davidside, WI 06946",32
151,2024-05-11 12:04:47.397769 +00:00,2024-05-11 22:04:47.397769 +00:00,"579 Mueller Heights East Amyburgh, PA 53982",32
152,2018-04-13 18:04:02.456149 +00:00,2018-05-05 00:04:02.456149 +00:00,"46688 King Burg Suite 478 Frankfort, KS 24962",33
153,2020-07-27 09:03:05.454802 +00:00,2020-10-03 07:03:05.454802 +00:00,"83398 Rachel Circles Suite 925 Jessicachester, WV 92419",33
154,2012-03-16 00:08:53.906843 +00:00,2012-06-04 15:08:53.906843 +00:00,"61965 Michelle Square West Kelsey, ND 74864",33
155,2025-09-11 07:56:23.249846 +00:00,2025-09-25 11:56:23.249846 +00:00,"1102 Park Mountains Suite 149 Riveraburgh, OR 60361",33
156,2014-08-05 00:25:01.451008 +00:00,2014-09-27 08:25:01.451008 +00:00,"269 Navarro Rue Suite 297 Port Alexis, FL 93714",33
157,2025-09-08 18:33:12.334278 +00:00,,"00206 Lisa Square Apt. 759 Ellenland, CO 99499",34
158,2025-08-09 03:24:08.870736 +00:00,2025-08-26 20:24:08.870736 +00:00,"PSC 0412, Box 8567 APO AP 49065",34
159,2017-01-16 16:38:32.963381 +00:00,2017-04-21 01:38:32.963381 +00:00,"932 Rodney Circles North Mary, WY 90049",34
160,2013-10-20 10:16:36.931464 +00:00,2013-11-19 00:16:36.931464 +00:00,Unit 4302 Box 7905 DPO AE 63124,34
161,2025-09-12 06:23:58.900141 +00:00,,"575 Joanne Branch Kennedyberg, PR 89884",34
162,2025-08-07 21:26:24.349051 +00:00,2025-09-03 23:26:24.349051 +00:00,"722 Deborah Track Suite 369 Port Michael, VI 83063",34
163,2024-11-01 22:35:44.767194 +00:00,2025-02-08 01:35:44.767194 +00:00,"72696 Cody Heights Robertborough, LA 29891",34
164,2021-04-11 12:12:20.071917 +00:00,2021-04-29 10:12:20.071917 +00:00,"601 Johnson Fork New Vanessamouth, ND 66631",35
165,2015-06-20 06:05:46.580025 +00:00,2015-07-29 15:05:46.580025 +00:00,"82164 Joseph Tunnel Angelamouth, TX 95489",35
166,2025-06-04 05:14:49.137428 +00:00,2025-07-06 22:14:49.137428 +00:00,"8962 Catherine Mission Apt. 590 Chenport, SD 58173",35
167,2020-09-20 08:13:55.816367 +00:00,2020-11-16 20:13:55.816367 +00:00,"9789 Ramos Wall Hawkinston, MI 13698",35
168,2013-07-27 02:45:45.693446 +00:00,2013-09-16 13:45:45.693446 +00:00,"380 Pierce Garden South Kaitlynland, MD 43012",36
169,2025-08-07 10:03:21.769839 +00:00,,"22565 Lisa Keys East Lauren, MN 24561",37
170,2012-02-20 01:10:46.508632 +00:00,2012-03-11 16:10:46.508632 +00:00,"985 David Plain Michaelbury, UT 78204",37
171,2017-10-04 00:42:09.129267 +00:00,2017-11-07 04:42:09.129267 +00:00,"10720 Mann Spring Annaberg, UT 75931",37
172,2015-02-19 04:38:05.889800 +00:00,2015-05-15 09:38:05.889800 +00:00,"18290 Stephen Fork Loriberg, NJ 98967",37
173,2025-09-02 15:32:13.958911 +00:00,,"811 Larson Mountains Hartmouth, KS 59635",37
174,2016-05-15 02:53:13.945987 +00:00,2016-08-09 23:53:13.945987 +00:00,"21481 Caroline Burg Nicoleside, TN 26560",37
175,2017-04-30 22:35:51.046703 +00:00,2017-06-07 00:35:51.046703 +00:00,"346 Brown Courts Campbellport, NC 80725",37
176,2013-06-23 20:02:16.249099 +00:00,2013-07-11 03:02:16.249099 +00:00,"105 William Locks Apt. 338 Petersenmouth, VI 61998",38
177,2014-11-03 16:24:46.803038 +00:00,2015-01-17 11:24:46.803038 +00:00,"25612 Young Way Apt. 548 Aaronton, NC 40047",38
178,2025-09-07 01:34:08.429149 +00:00,,"55584 Cabrera Fields Suite 747 South Lauraland, PW 11373",38
179,2015-10-19 07:03:57.540830 +00:00,2015-10-23 01:03:57.540830 +00:00,"7182 Anthony Plains Andreaburgh, NC 37436",39
180,2017-07-24 15:19:46.160906 +00:00,2017-09-11 09:19:46.160906 +00:00,"796 Matthew Grove South Paul, AK 13225",40
181,2016-02-18 16:05:47.666127 +00:00,2016-05-15 23:05:47.666127 +00:00,"05082 Cynthia Parkways Apt. 921 Maldonadoview, FL 13276",40
182,2025-07-22 01:38:14.890764 +00:00,2025-09-18 04:38:14.890764 +00:00,"953 Koch Village New Mariahaven, WV 19935",40
183,2020-11-25 07:44:26.368980 +00:00,2020-12-12 19:44:26.368980 +00:00,"9087 Linda Grove East Travis, MA 15403",40
184,2020-07-13 20:04:26.110679 +00:00,2020-07-23 20:04:26.110679 +00:00,"87274 Anna Court South Maxtown, NC 33921",40
185,2017-01-28 12:41:58.637002 +00:00,2017-03-11 19:41:58.637002 +00:00,"06789 George Roads Suite 668 Frankbury, NM 70548",40
186,2023-03-04 12:23:01.453699 +00:00,2023-04-20 14:23:01.453699 +00:00,"6017 Peterson Lock Suite 968 Cesarmouth, MN 07878",40
187,2023-08-04 05:35:31.995641 +00:00,2023-09-02 09:35:31.995641 +00:00,"40940 Murphy Alley Mcdowellstad, NY 94602",41
188,2025-09-27 20:21:18.316082 +00:00,,"58162 Samantha Shoal Suite 794 North Jesse, KY 86125",42
189,2018-08-10 10:37:49.098427 +00:00,2018-10-09 10:37:49.098427 +00:00,"30521 James Prairie Apt. 603 Lake Mary, NM 14750",42
190,2025-08-04 09:36:32.327404 +00:00,,"PSC 7126, Box 9664 APO AP 90070",42
191,2020-03-19 15:19:03.216841 +00:00,2020-03-24 00:19:03.216841 +00:00,"660 Austin Wall New Emilystad, MS 23361",42
192,2021-10-26 19:40:06.608102 +00:00,2022-01-15 20:40:06.608102 +00:00,"2623 Ramsey Union Lake Jamesfurt, MO 45049",43
193,2018-12-19 12:04:52.944834 +00:00,2019-03-23 01:04:52.944834 +00:00,"707 Raymond Keys Apt. 061 Tonyaborough, WV 90782",43
194,2014-09-19 19:48:00.718694 +00:00,2014-11-17 03:48:00.718694 +00:00,"5054 Nicole Inlet New David, OH 85714",43
195,2013-11-05 23:11:17.755848 +00:00,2013-12-18 16:11:17.755848 +00:00,"861 Scott Lock Suite 952 Lake Steven, MT 57977",43
196,2020-09-19 13:49:37.471745 +00:00,2020-10-01 10:49:37.471745 +00:00,"92765 Jeanette Square Kevinport, AS 72535",43
197,2018-06-25 05:34:42.859510 +00:00,2018-09-04 06:34:42.859510 +00:00,"6747 Howard Isle Suite 403 South Rebeccaland, VT 94312",43
198,2025-09-19 06:35:47.370318 +00:00,,"52500 Hall Cliff Apt. 525 Port Wendyfurt, VA 86178",44
199,2016-11-16 01:21:37.800530 +00:00,2016-12-15 15:21:37.800530 +00:00,"3072 Travis Inlet Lake Timothyton, NJ 94506",44
200,2025-07-03 10:29:55.664894 +00:00,2025-07-12 19:29:55.664894 +00:00,"44281 Alexander Heights South Davidmouth, SD 21300",44
201,2025-07-11 11:31:00.870845 +00:00,2025-07-14 19:31:00.870845 +00:00,"8051 Dan Mission Suite 924 Danielberg, AK 61628",44
202,2016-08-30 04:16:03.945926 +00:00,2016-09-18 23:16:03.945926 +00:00,"5539 Braun Stream Suite 994 Andersonfurt, IA 93546",44
203,2016-07-11 19:30:49.270797 +00:00,2016-08-05 19:30:49.270797 +00:00,"208 Roberts Orchard Jonesmouth, WV 25500",45
204,2025-08-19 22:30:23.525903 +00:00,,"052 Reyes Greens Apt. 099 Thomasport, AL 47621",45
205,2020-07-09 22:15:27.686388 +00:00,2020-08-01 15:15:27.686388 +00:00,"46031 Mccarthy Corner Longton, MP 46518",45
206,2019-11-17 13:27:10.414509 +00:00,2020-01-10 07:27:10.414509 +00:00,"641 Barry Streets Morrowbury, DC 49227",46
207,2017-09-21 16:01:49.613542 +00:00,2017-10-27 07:01:49.613542 +00:00,"420 Sharon Divide South Stephanie, SC 48795",46
208,2022-12-14 15:37:56.616302 +00:00,2023-03-22 08:37:56.616302 +00:00,"PSC 0504, Box 2828 APO AE 91240",46
209,2017-10-12 10:52:51.834555 +00:00,2017-12-16 15:52:51.834555 +00:00,"8007 Samuel Villages Suite 585 North Michael, AZ 84349",46
210,2025-08-24 05:42:42.627701 +00:00,2025-09-27 09:42:42.627701 +00:00,"86546 Zachary Center Lauraberg, CT 48957",47
211,2022-11-02 20:23:30.299565 +00:00,2022-12-15 23:23:30.299565 +00:00,"5555 Stephen River Lake Courtney, ID 98163",47
212,2012-06-15 08:55:20.006902 +00:00,2012-06-25 18:55:20.006902 +00:00,"336 Christopher Tunnel Jonathanmouth, VI 40167",47
213,2025-09-28 22:47:56.173572 +00:00,,"30994 Brandt Dale Apt. 851 New Tracey, SC 64862",47
214,2014-09-04 05:05:55.868474 +00:00,2014-10-21 07:05:55.868474 +00:00,"PSC 4078, Box 0030 APO AE 12108",47
215,2025-07-20 03:27:35.202020 +00:00,2025-08-22 01:27:35.202020 +00:00,"612 Torres Fields Apt. 087 Meganberg, ID 45151",47
216,2012-05-14 09:44:48.451469 +00:00,2012-07-14 15:44:48.451469 +00:00,"342 Michael Ridge Apt. 064 Ericashire, TX 51157",48
217,2020-12-05 20:38:39.764476 +00:00,2021-02-14 21:38:39.764476 +00:00,"04681 Hernandez Cape Suite 851 South Jessica, LA 40409",48
218,2018-01-10 01:03:15.653023 +00:00,2018-01-12 08:03:15.653023 +00:00,USNS White FPO AP 91478,48
219,2011-06-13 11:15:37.775216 +00:00,2011-07-12 15:15:37.775216 +00:00,"78754 James Plain Apt. 715 Jacquelineland, OR 34652",48
220,2013-03-21 16:58:32.813729 +00:00,2013-05-06 17:58:32.813729 +00:00,"2089 Solis Forge Lake Kimberlyburgh, OH 27482",48
221,2025-08-04 16:41:05.747138 +00:00,,"89230 Keller Drive South Robertton, GA 78096",48
222,2025-07-05 10:25:35.523492 +00:00,2025-10-01 23:25:35.523492 +00:00,"336 Christopher Tunnel Jonathanmouth, VI 40167",48
223,2025-07-26 15:45:44.054365 +00:00,2025-09-14 10:45:44.054365 +00:00,"3274 Andrew Plain West Paigestad, DE 85771",48
224,2012-10-08 21:08:05.822034 +00:00,2012-12-06 15:08:05.822034 +00:00,"486 Johnson Mountain Annaland, NY 91408",49
225,2025-07-03 02:41:23.837286 +00:00,,"03568 Myers Fort Port Cindy, MI 57002",49
226,2025-07-14 09:57:20.710863 +00:00,2025-09-13 20:57:20.710863 +00:00,"602 Lori Heights Josephmouth, CA 28679",49
227,2025-08-22 17:04:21.073216 +00:00,,"980 Kyle Manors South Melissachester, FL 48313",50
228,2015-04-22 21:58:36.572616 +00:00,2015-07-17 12:58:36.572616 +00:00,"8051 Dan Mission Suite 924 Danielberg, AK 61628",50
229,2025-07-05 03:31:18.935185 +00:00,2025-07-28 06:31:18.935185 +00:00,"042 Thompson Court West Brian, MS 07087",50
230,2025-08-31 05:43:28.700871 +00:00,,"3844 David Park Apt. 797 Huntburgh, OH 27804",50
231,2016-05-21 12:34:37.404472 +00:00,2016-06-25 12:34:37.404472 +00:00,"3274 Andrew Plain West Paigestad, DE 85771",50
232,2017-04-15 22:14:18.507495 +00:00,2017-05-14 16:14:18.507495 +00:00,"485 Davis Place Apt. 493 Millerfort, CA 48140",50
233,2022-05-11 09:27:20.806228 +00:00,2022-08-19 04:27:20.806228 +00:00,"306 Gonzalez Prairie Pamburgh, MD 94006",50
234,2015-12-22 00:07:59.175160 +00:00,2016-02-05 20:07:59.175160 +00:00,"PSC 6619, Box 2911 APO AA 84246",50
235,2025-07-03 10:15:39.053723 +00:00,2025-09-04 23:15:39.053723 +00:00,"917 Patricia Squares South Morgantown, DC 37321",51
236,2023-01-19 04:09:51.869394 +00:00,2023-02-06 12:09:51.869394 +00:00,"24403 Perez Manor Suite 688 Perezside, ND 46652",51
237,2025-09-24 08:40:09.551470 +00:00,,"9763 Newman Dale Apt. 326 Crystalshire, ND 73186",52
238,2015-03-16 08:30:32.974699 +00:00,2015-06-02 06:30:32.974699 +00:00,USNV Perez FPO AE 27880,52
239,2025-08-09 08:13:18.486727 +00:00,,"231 Pollard Garden Suite 283 Aaronton, WA 81054",52
240,2010-03-04 14:34:47.476185 +00:00,2010-05-07 03:34:47.476185 +00:00,"47868 Long Branch Apt. 445 Susanshire, MH 84780",52
241,2021-06-15 14:15:39.504919 +00:00,2021-08-27 02:15:39.504919 +00:00,"136 Knox Motorway Apt. 647 North Patrick, PR 07776",52
242,2018-01-29 07:46:37.322235 +00:00,2018-02-14 13:46:37.322235 +00:00,USNV Fuller FPO AA 28954,52
243,2025-08-15 00:37:10.798768 +00:00,2025-09-15 11:37:10.798768 +00:00,"8445 Chris Shoals East Stevenland, VI 56330",53
244,2015-02-02 17:49:06.808008 +00:00,2015-04-28 22:49:06.808008 +00:00,"3967 Ross Ramp Lawrencemouth, NY 10301",53
245,2019-10-23 14:45:35.316438 +00:00,2020-01-21 14:45:35.316438 +00:00,"4897 Gallegos Pine Brightfurt, WA 26539",53
246,2025-07-18 04:33:55.895763 +00:00,2025-09-19 17:33:55.895763 +00:00,"4741 Lopez Isle New Lacey, NH 70564",54
247,2025-07-19 11:40:28.457400 +00:00,,"90599 Crystal Lights Apt. 192 Port Jenniferborough, RI 90968",54
248,2021-07-03 09:03:47.129765 +00:00,2021-08-13 10:03:47.129765 +00:00,"692 Gordon Centers New Kathrynchester, WI 07043",54
249,2012-07-29 07:18:26.332939 +00:00,2012-09-16 11:18:26.332939 +00:00,"90764 Jesus Mount Phillipland, FM 03056",55
250,2015-02-02 05:08:50.110940 +00:00,2015-03-07 18:08:50.110940 +00:00,"1961 Carlos View East Deborah, WY 92664",55
251,2020-05-22 10:00:56.535586 +00:00,2020-05-25 18:00:56.535586 +00:00,"7148 Melanie Port Suite 654 Reedton, AS 45096",55
252,2018-07-21 23:44:23.765434 +00:00,2018-10-27 11:44:23.765434 +00:00,"1162 Whitney Walks West Patrick, NV 95849",56
253,2024-03-23 22:00:34.280792 +00:00,2024-03-24 08:00:34.280792 +00:00,"16024 Victoria Crossroad Suite 130 West Lindaville, NJ 47667",56
254,2025-09-02 12:20:41.881618 +00:00,,"43109 Williams Cliffs Apt. 093 New Nancy, PR 16112",56
255,2025-09-14 21:12:56.580461 +00:00,,"595 Dwayne Path Suite 706 Lake Laura, ME 17833",56
256,2019-03-22 23:57:18.194901 +00:00,2019-06-21 14:57:18.194901 +00:00,"473 Jacqueline Gateway Suite 146 Port Tomton, MO 64934",56
257,2022-05-24 00:04:54.723667 +00:00,2022-06-11 23:04:54.723667 +00:00,"1961 Carlos View East Deborah, WY 92664",56
258,2025-08-10 11:08:09.674307 +00:00,,"439 Andrew Club Apt. 057 North Michaeltown, MS 50183",56
259,2020-11-26 01:11:57.336670 +00:00,2020-12-28 18:11:57.336670 +00:00,"7041 Andrea Squares Suite 870 West Jimmyfurt, CO 87430",57
260,2025-10-02 09:33:21.676296 +00:00,2025-10-05 12:33:21.676296 +00:00,"999 Jason Throughway Suite 512 New Johnville, NC 73795",57
261,2025-07-01 18:09:41.416443 +00:00,2025-09-11 20:09:41.416443 +00:00,"6766 Byrd Route Weeksmouth, RI 23149",57
262,2014-06-02 19:14:06.319555 +00:00,2014-07-08 15:14:06.319555 +00:00,"40348 Madison Crest Suite 586 Rossfort, TN 02753",57
263,2013-07-03 19:21:36.046292 +00:00,2013-10-08 11:21:36.046292 +00:00,Unit 4175 Box 9560 DPO AE 24921,57
264,2018-09-22 02:27:28.731337 +00:00,2018-10-10 00:27:28.731337 +00:00,Unit 1772 Box 1510 DPO AA 85078,57
265,2017-10-27 15:48:23.408192 +00:00,2018-01-30 05:48:23.408192 +00:00,"93201 Charles Summit Christopherville, ID 35705",57
266,2022-02-06 15:40:27.991575 +00:00,2022-02-22 21:40:27.991575 +00:00,"43201 Johnson Loop Apt. 084 Port Angela, PA 34462",58
267,2015-10-09 07:51:40.675030 +00:00,2015-10-16 19:51:40.675030 +00:00,"4814 Nelson Glen Zacharyport, ID 17318",58
268,2011-06-09 03:31:02.163038 +00:00,2011-06-12 06:31:02.163038 +00:00,"6047 Le Rapid Suite 695 Combston, NM 19530",58
269,2023-08-07 05:58:40.789680 +00:00,2023-09-27 06:58:40.789680 +00:00,"94740 Tracy Pine Apt. 815 Simmonston, RI 45639",59
270,2025-08-19 20:51:43.698532 +00:00,,"967 Shea Crossroad Daviesside, AL 93882",59
271,2010-06-25 08:58:22.226740 +00:00,2010-08-06 00:58:22.226740 +00:00,"228 Davis Falls Jessicatown, UT 67984",59
272,2020-05-24 09:08:00.837698 +00:00,2020-06-14 20:08:00.837698 +00:00,Unit 8777 Box 9030 DPO AE 68407,59
273,2019-03-17 23:16:46.336943 +00:00,2019-05-22 04:16:46.336943 +00:00,"064 Franklin Square South Lindseyville, WY 84449",59
274,2014-03-05 21:01:00.232314 +00:00,2014-03-27 03:01:00.232314 +00:00,"523 Daniel Parks Andrewburgh, NC 08806",59
275,2025-07-30 19:07:05.738086 +00:00,2025-10-03 04:07:05.738086 +00:00,"26639 Poole Grove Suite 203 Sanchezfort, PR 57007",59
276,2010-07-03 17:41:23.366687 +00:00,2010-08-27 22:41:23.366687 +00:00,"717 Davidson Mountain Suite 756 Lake Amanda, NY 42294",59
277,2018-02-07 20:27:12.235206 +00:00,2018-02-21 19:27:12.235206 +00:00,"39879 Cuevas Radial North Omar, PW 04200",60
278,2018-09-09 06:22:55.196153 +00:00,2018-10-28 00:22:55.196153 +00:00,Unit 4407 Box 7294 DPO AA 36406,60
279,2021-05-19 18:12:32.080913 +00:00,2021-05-26 20:12:32.080913 +00:00,"372 Campbell Plains Apt. 536 Bellmouth, MA 05995",61
280,2013-03-14 07:35:05.134177 +00:00,2013-05-22 11:35:05.134177 +00:00,"472 Hubbard Overpass Apt. 108 Nicoleton, GU 74779",61
281,2015-12-18 23:24:29.204254 +00:00,2016-02-18 10:24:29.204254 +00:00,"1818 Alexander Mills Lisahaven, KS 95569",61
282,2020-02-05 18:28:46.980977 +00:00,2020-02-22 20:28:46.980977 +00:00,"30952 Maynard Hollow Suite 757 Transide, MS 80965",61
283,2010-10-04 13:56:13.789952 +00:00,2010-12-18 18:56:13.789952 +00:00,"8500 Horn Fields Suite 631 Ramseyfurt, WI 00954",61
284,2022-03-16 17:14:28.790965 +00:00,2022-06-07 10:14:28.790965 +00:00,"725 Turner Ranch East Angelaport, VT 28580",61
285,2013-05-10 07:52:20.903034 +00:00,2013-06-14 07:52:20.903034 +00:00,"5404 Brian Key New Brett, IL 35243",61
286,2016-02-24 04:42:51.120842 +00:00,2016-04-02 12:42:51.120842 +00:00,"9556 Anthony Curve Suite 237 West Kevinfort, MN 07645",62
287,2019-05-26 23:15:47.232957 +00:00,2019-08-22 16:15:47.232957 +00:00,"5196 Mark Extension Jimenezport, MD 47971",62
288,2014-04-24 13:28:30.682646 +00:00,2014-07-11 21:28:30.682646 +00:00,"564 Gregory Unions New Kelly, MA 05119",62
289,2017-06-07 17:11:21.229124 +00:00,2017-06-15 00:11:21.229124 +00:00,"7001 Rachel Trafficway Orrfurt, NY 86769",62
290,2021-07-29 21:01:22.838667 +00:00,2021-08-01 04:01:22.838667 +00:00,"4609 Ramos Shore Suite 799 Dunlapchester, FL 81048",62
291,2022-03-04 06:07:36.554706 +00:00,2022-04-30 23:07:36.554706 +00:00,"462 Oconnor View Antonioshire, PW 74911",62
292,2012-09-17 18:48:59.411827 +00:00,2012-10-28 04:48:59.411827 +00:00,Unit 0597 Box 7794 DPO AE 83690,62
293,2019-11-21 23:15:58.460977 +00:00,2019-12-25 12:15:58.460977 +00:00,"98032 Tammie Springs Hubbardburgh, SC 93318",63
294,2012-11-22 18:37:05.137966 +00:00,2012-12-19 15:37:05.137966 +00:00,"8165 Mercer Fords North Devin, ID 46639",63
295,2019-02-16 03:16:24.692140 +00:00,2019-05-13 04:16:24.692140 +00:00,"0579 Julie Extensions Lake Christopher, CA 29205",63
296,2023-02-16 11:19:47.024074 +00:00,2023-04-04 08:19:47.024074 +00:00,"57721 Tara Prairie Mcgrathstad, WI 18603",63
297,2025-07-15 03:20:17.707633 +00:00,,"483 Meyer Station Suite 728 Marquezhaven, TX 17492",63
298,2013-02-19 11:27:36.009063 +00:00,2013-04-14 20:27:36.009063 +00:00,"2688 Cooke Knolls Apt. 036 Curtiston, PW 65693",63
299,2025-07-15 07:14:51.576054 +00:00,2025-09-16 05:14:51.576054 +00:00,Unit 9156 Box 0189 DPO AA 60859,63
300,2025-08-05 05:13:25.577777 +00:00,,"61862 Elizabeth Locks Samuelbury, LA 54116",63
301,2025-08-25 05:58:49.883466 +00:00,2025-08-29 14:58:49.883466 +00:00,"735 Freeman Shores Russellstad, CA 47910",64
302,2022-01-25 16:31:12.678210 +00:00,2022-04-15 11:31:12.678210 +00:00,"4386 Robert Plain Apt. 144 Port Daniel, PR 24934",64
303,2025-09-02 16:53:27.898621 +00:00,2025-09-23 22:53:27.898621 +00:00,"6017 Sarah Mountain Lake Meghanshire, ID 29806",65
304,2025-10-01 12:53:38.876958 +00:00,,"52417 Juan Junctions New Willie, CA 31091",65
305,2017-07-07 02:25:27.205189 +00:00,2017-09-27 19:25:27.205189 +00:00,"871 Herbert Parkways South Melanieshire, VI 87022",65
306,2012-10-21 13:08:20.320808 +00:00,2013-01-25 19:08:20.320808 +00:00,"605 Kurt Fields Suite 424 Sheamouth, NV 00873",65
307,2025-08-11 07:05:44.144755 +00:00,2025-08-27 08:05:44.144755 +00:00,"653 Leah Brook Suite 117 West Benjaminfort, NJ 44989",65
308,2012-07-04 21:42:12.342004 +00:00,2012-09-11 00:42:12.342004 +00:00,"173 Richards Key Suite 661 Cathyshire, MH 08461",66
309,2025-09-04 23:41:30.226182 +00:00,2025-09-09 08:41:30.226182 +00:00,"902 Kevin Stravenue Suite 339 South William, AK 60964",66
310,2014-11-12 20:53:55.234112 +00:00,2014-11-24 17:53:55.234112 +00:00,USCGC Williams FPO AA 01178,66
311,2025-08-14 03:47:08.225059 +00:00,2025-09-27 17:47:08.225059 +00:00,"9973 Katelyn Passage Suite 604 Nancyview, WI 60752",66
312,2025-08-15 17:55:12.915716 +00:00,,"8632 Marquez Views Port Michael, AS 22199",67
313,2025-08-09 05:06:14.681721 +00:00,,"40457 Justin Squares Suite 288 North Aliciafort, VA 46960",67
314,2025-08-12 22:48:13.097583 +00:00,2025-08-16 01:48:13.097583 +00:00,"3274 Andrew Plain West Paigestad, DE 85771",67
315,2025-09-07 10:58:23.561455 +00:00,,"182 Payne Springs Suite 753 South Donald, AK 10132",67
316,2019-09-13 01:40:50.192936 +00:00,2019-10-21 19:40:50.192936 +00:00,"94369 Thomas Key New Williammouth, CT 29755",67
317,2025-08-09 10:02:48.651151 +00:00,2025-09-07 09:02:48.651151 +00:00,"94740 Tracy Pine Apt. 815 Simmonston, RI 45639",67
318,2021-06-24 16:51:20.113073 +00:00,2021-07-28 05:51:20.113073 +00:00,"3566 Perry Port East Kristinetown, CO 36748",67
319,2018-10-14 09:13:01.220831 +00:00,2018-12-22 18:13:01.220831 +00:00,"9434 Shirley Plaza Apt. 752 Andrewsberg, LA 61583",68
320,2025-07-09 17:25:14.072262 +00:00,2025-08-20 09:25:14.072262 +00:00,"3318 Jacqueline Row North Kathleenville, OH 31404",68
321,2014-08-16 18:23:53.618480 +00:00,2014-10-28 11:23:53.618480 +00:00,"08768 Roberts Drive Apt. 404 Littlemouth, TN 83862",68
322,2011-04-24 17:11:10.511160 +00:00,2011-07-26 05:11:10.511160 +00:00,"828 Dawson Overpass Phillipsborough, CA 14018",68
323,2013-10-14 00:12:52.621713 +00:00,2014-01-10 08:12:52.621713 +00:00,"421 Harry Passage Suite 532 Hamiltonchester, GU 28030",68
324,2015-01-31 17:38:04.553044 +00:00,2015-03-12 07:38:04.553044 +00:00,"548 Heather Fort Apt. 305 Beverlystad, ID 31276",69
325,2019-03-17 11:26:33.221124 +00:00,2019-06-05 21:26:33.221124 +00:00,"4864 Rose Dale Suite 046 Nicholasshire, OH 99420",69
326,2025-08-06 09:54:58.864898 +00:00,,"41686 Nancy Rapids Suite 148 Gonzalezfort, VI 11694",69
327,2024-12-21 04:04:25.544334 +00:00,2025-02-12 17:04:25.544334 +00:00,"4821 Rachel Path Suite 244 Lake Richardmouth, CO 45989",69
328,2021-04-21 21:51:29.577921 +00:00,2021-05-21 21:51:29.577921 +00:00,"PSC 2908, Box 4548 APO AP 75549",70
329,2010-10-30 14:17:55.986686 +00:00,2010-12-25 10:17:55.986686 +00:00,"72099 Stephen Mountain Port Deannaville, SC 51715",70
330,2025-08-13 06:12:58.908552 +00:00,2025-08-16 04:12:58.908552 +00:00,"3395 Torres Ports Suite 471 Mclaughlinview, ME 72256",70
331,2018-09-14 06:50:15.584114 +00:00,2018-12-14 17:50:15.584114 +00:00,USS Saunders FPO AP 56751,71
332,2025-08-18 20:55:19.619193 +00:00,,Unit 4175 Box 9560 DPO AE 24921,71
333,2011-07-30 21:25:10.428549 +00:00,2011-09-01 04:25:10.428549 +00:00,"3072 Travis Inlet Lake Timothyton, NJ 94506",71
334,2015-02-18 21:11:55.153808 +00:00,2015-05-15 02:11:55.153808 +00:00,"6177 Anna Pines East Kathrynview, KY 23213",71
335,2012-10-09 15:30:15.689117 +00:00,2012-11-16 13:30:15.689117 +00:00,"796 Matthew Grove South Paul, AK 13225",71
336,2013-01-10 01:31:11.383376 +00:00,2013-04-09 15:31:11.383376 +00:00,"3887 Holmes Square Apt. 106 New Elizabeth, FL 00614",71
337,2012-09-11 21:38:07.914143 +00:00,2012-11-10 11:38:07.914143 +00:00,"501 Joshua Cove Wardton, DE 57406",72
338,2022-07-04 17:07:21.347909 +00:00,2022-09-24 19:07:21.347909 +00:00,"51672 Burch Row Apt. 974 New Tammyton, PW 68350",72
339,2020-10-09 04:05:52.388374 +00:00,2021-01-06 08:05:52.388374 +00:00,"349 Powell Row Suite 997 South Zachary, LA 72421",72
340,2011-05-07 02:23:22.273679 +00:00,2011-06-21 12:23:22.273679 +00:00,"2829 Myers Plains Suite 296 Newtonborough, PR 53315",72
341,2015-04-22 14:29:12.039346 +00:00,2015-05-15 12:29:12.039346 +00:00,"331 Norris Fort Suite 254 East Garybury, SC 17797",72
342,2024-05-05 10:15:02.735542 +00:00,2024-07-15 01:15:02.735542 +00:00,"86128 Mark Cliffs Tylerstad, OK 15538",73
343,2024-12-15 14:13:19.402277 +00:00,2025-01-01 06:13:19.402277 +00:00,"3318 Jacqueline Row North Kathleenville, OH 31404",73
344,2014-05-14 11:40:38.075407 +00:00,2014-06-23 01:40:38.075407 +00:00,USCGC Hernandez FPO AA 00577,73
345,2019-10-28 21:57:40.831834 +00:00,2020-01-16 01:57:40.831834 +00:00,"40400 Amanda Drive Sheriville, DE 72544",73
346,2020-02-09 23:28:05.020567 +00:00,2020-04-23 17:28:05.020567 +00:00,"1300 Scott Falls Apt. 688 New Theresafurt, MO 39779",73
347,2010-08-24 05:18:13.636046 +00:00,2010-09-03 05:18:13.636046 +00:00,"6969 Castillo Springs West Tyler, AZ 45368",73
348,2020-11-08 07:14:47.275671 +00:00,2021-02-02 23:14:47.275671 +00:00,"980 Maria Turnpike Apt. 605 Barbarafurt, WY 33094",74
349,2020-09-08 15:25:07.131068 +00:00,2020-09-17 04:25:07.131068 +00:00,"PSC 4721, Box 9701 APO AA 98178",74
350,2025-09-12 23:07:01.574880 +00:00,,"47963 Campbell Green Suite 707 Port Rebecca, NH 73983",74
351,2016-04-04 07:03:25.789914 +00:00,2016-07-05 14:03:25.789914 +00:00,"7974 Wright Harbors Apt. 689 Hilltown, IA 95604",75
352,2025-08-04 03:42:45.237802 +00:00,2025-09-24 04:42:45.237802 +00:00,"670 Cynthia Route Suite 186 Port Darlene, WA 61426",75
353,2011-01-30 03:41:13.353259 +00:00,2011-04-12 20:41:13.353259 +00:00,"7729 Kimberly Club Apt. 954 Kimberlyview, MD 75751",75
354,2025-08-08 06:20:33.719603 +00:00,2025-09-25 04:20:33.719603 +00:00,"1865 Richardson Meadows Suite 253 East Jennifer, OR 86965",76
355,2025-04-29 20:15:00.976211 +00:00,2025-08-06 14:15:00.976211 +00:00,"815 Todd Cliffs Suite 171 Theodoreshire, TX 13440",76
356,2022-07-01 19:16:57.825574 +00:00,2022-08-28 12:16:57.825574 +00:00,"317 Kevin Shore Port Jamie, GA 90863",76
357,2020-08-01 17:17:14.794254 +00:00,2020-10-09 16:17:14.794254 +00:00,"17959 Heather Grove Lisaside, CO 44646",76
358,2024-01-01 14:16:10.453056 +00:00,2024-02-12 16:16:10.453056 +00:00,"65400 Watts Meadows Suite 762 West Brian, SD 45353",76
359,2020-08-11 09:49:26.657013 +00:00,2020-09-10 19:49:26.657013 +00:00,"9975 Kelly Port Bethside, GU 40723",77
360,2022-09-06 22:14:46.882821 +00:00,2022-10-11 17:14:46.882821 +00:00,"213 Morgan Station Apt. 222 Veronicafort, ND 54782",77
361,2025-07-05 15:56:42.888954 +00:00,2025-08-17 13:56:42.888954 +00:00,"16651 Carpenter Highway South Lisaborough, OH 88719",77
362,2025-08-03 19:37:14.748309 +00:00,,"0621 Zachary Greens North Jennifer, NJ 31738",77
363,2025-08-31 06:37:49.493018 +00:00,,USNS Farmer FPO AP 49057,77
364,2025-02-20 02:48:12.716603 +00:00,2025-05-01 17:48:12.716603 +00:00,"48865 Scott Shoals Apt. 200 East Paulchester, IL 31086",77
365,2018-10-05 21:02:55.451788 +00:00,2018-12-29 11:02:55.451788 +00:00,"3203 Jessica Manor Apt. 336 Glassfort, NH 74491",77
366,2025-07-10 16:41:21.794385 +00:00,2025-09-22 10:41:21.794385 +00:00,"376 Linda Knolls Herbertside, VA 70539",77
367,2016-10-06 09:12:33.344049 +00:00,2016-10-13 21:12:33.344049 +00:00,"8166 Mark Glen North Shellybury, IA 21713",78
368,2025-08-27 11:36:13.680523 +00:00,,"1206 Morales Plaza West Alexandria, MI 39942",78
369,2010-05-23 19:51:57.885750 +00:00,2010-08-14 07:51:57.885750 +00:00,"5955 Cox Manor Suite 341 Hooverview, NJ 34135",78
370,2025-07-07 08:07:53.793354 +00:00,2025-09-25 08:07:53.793354 +00:00,"836 Stephen Villages Caitlinshire, GU 73511",78
371,2018-05-08 13:44:38.431280 +00:00,2018-07-18 19:44:38.431280 +00:00,Unit 9275 Box 4455 DPO AP 91539,78
372,2025-09-04 22:25:45.597886 +00:00,2025-09-15 03:25:45.597886 +00:00,"9610 Gay Views West Tiffanyport, VT 95451",78
373,2024-05-07 15:11:15.831043 +00:00,2024-06-21 20:11:15.831043 +00:00,"570 Paul Parkway Warrenland, MN 31752",78
374,2010-02-14 20:42:10.855265 +00:00,2010-04-04 14:42:10.855265 +00:00,"72216 Mason Spurs New Steven, WY 02479",79
375,2025-06-08 12:10:52.891320 +00:00,2025-07-11 05:10:52.891320 +00:00,"68781 Wong Springs Williamfurt, IN 19741",79
376,2018-09-17 10:43:50.478828 +00:00,2018-11-21 20:43:50.478828 +00:00,"59636 Jamie Lodge Lake Luis, MH 74085",79
377,2025-08-25 15:23:19.119140 +00:00,,"124 Stanton Radial Port Kimberly, OK 25202",79
378,2019-08-06 16:39:40.300984 +00:00,2019-09-30 11:39:40.300984 +00:00,"393 Moon Motorway Willisport, IA 49190",79
379,2010-06-01 21:36:02.506132 +00:00,2010-06-10 00:36:02.506132 +00:00,"21944 Moore Pass Suite 322 Stevenborough, MN 98155",79
380,2025-09-18 15:29:14.651199 +00:00,,"01323 Holden Divide Amyland, IA 74409",80
381,2020-05-15 03:38:39.859854 +00:00,2020-06-03 17:38:39.859854 +00:00,USS York FPO AE 75346,80
382,2022-12-04 08:34:00.440983 +00:00,2023-02-16 07:34:00.440983 +00:00,USNV Fuller FPO AA 28954,80
383,2020-05-14 02:47:00.323812 +00:00,2020-06-24 13:47:00.323812 +00:00,"155 Smith Ports Suite 447 Lesliechester, LA 07287",80
384,2015-08-28 22:16:44.979067 +00:00,2015-11-23 04:16:44.979067 +00:00,"82173 Martinez Lakes Apt. 437 Cameronberg, IA 58935",81
385,2013-07-08 16:42:07.409990 +00:00,2013-07-20 18:42:07.409990 +00:00,"3614 Parrish Land Suite 115 Port Johnmouth, NY 08629",81
386,2024-06-17 19:09:09.019963 +00:00,2024-08-07 05:09:09.019963 +00:00,"6340 Wells Divide Apt. 464 Lake Michaelborough, VT 64800",81
387,2025-08-02 01:39:52.266152 +00:00,,"17451 Cooper Dam West Joshuaville, WV 35180",81
388,2025-10-02 10:00:03.864428 +00:00,2025-10-05 18:00:03.864428 +00:00,"0537 Lloyd Path Smithville, WY 92410",82
389,2023-11-22 00:20:12.271623 +00:00,2024-01-05 19:20:12.271623 +00:00,"66854 Bailey Plain Suite 742 New Juliefurt, SC 22923",82
390,2025-07-22 05:40:08.142159 +00:00,2025-09-26 11:40:08.142159 +00:00,"14912 Perez Manors Thomasshire, VT 44951",83
391,2023-11-27 10:04:09.756974 +00:00,2023-12-31 04:04:09.756974 +00:00,Unit 7510 Box 3411 DPO AP 09474,83
392,2025-08-02 12:02:49.719034 +00:00,2025-09-23 04:02:49.719034 +00:00,"50121 Nicholas Locks Apt. 259 South Meghan, FM 14103",84
393,2017-05-24 17:14:30.684928 +00:00,2017-07-02 11:14:30.684928 +00:00,"27030 Erin Greens Apt. 698 Port Ryan, AS 61478",84
394,2013-12-16 13:04:53.401968 +00:00,2014-03-05 22:04:53.401968 +00:00,"922 Reid Mountain Haleyside, KY 18284",84
395,2025-09-06 14:15:23.967487 +00:00,,"01883 Mary Dale Apt. 221 North Kenneth, RI 33740",85
396,2021-12-30 01:42:24.159535 +00:00,2022-03-27 13:42:24.159535 +00:00,"204 Joshua Springs Suite 377 Donaldchester, MT 11239",86
397,2021-12-15 23:42:41.471679 +00:00,2022-02-27 07:42:41.471679 +00:00,"91944 Melissa Street Suite 256 South Shane, CT 14356",87
398,2011-11-08 04:07:18.346796 +00:00,2012-01-18 10:07:18.346796 +00:00,"0656 Antonio Hollow Howardberg, MS 53278",87
399,2022-01-09 16:57:36.866173 +00:00,2022-02-28 11:57:36.866173 +00:00,"0150 Garner Trafficway Lake Jennifer, RI 99572",87
400,2023-11-30 21:49:19.532402 +00:00,2023-12-25 06:49:19.532402 +00:00,"745 Banks Village Suite 943 East Brendastad, NC 38510",87
401,2025-07-08 15:59:14.827697 +00:00,2025-07-27 14:59:14.827697 +00:00,"6799 Cynthia Manors Suite 909 Lewismouth, TX 54097",88
402,2025-07-22 05:01:06.017808 +00:00,2025-09-15 10:01:06.017808 +00:00,"06658 Knox Walk Apt. 528 Port John, MH 60158",88
403,2023-06-19 01:46:51.372799 +00:00,2023-07-09 01:46:51.372799 +00:00,"65197 William Mills Suite 166 Port Mariah, UT 08188",88
404,2022-02-20 20:58:53.254160 +00:00,2022-03-27 00:58:53.254160 +00:00,"5575 Beth Wells Suite 545 Millermouth, MD 46070",88
405,2013-01-07 08:37:10.711987 +00:00,2013-01-21 17:37:10.711987 +00:00,"9407 Watson Ramp West Dawn, OH 45381",89
406,2025-09-01 19:22:07.121879 +00:00,,"653 Leah Brook Suite 117 West Benjaminfort, NJ 44989",89
407,2024-08-13 10:05:07.224399 +00:00,2024-09-09 07:05:07.224399 +00:00,"1552 Young Prairie Valerieshire, LA 23882",89
408,2025-07-02 03:11:15.953891 +00:00,2025-07-31 07:11:15.953891 +00:00,"05092 Harris Street North Ricardo, FM 31876",89
409,2018-03-25 07:39:54.991882 +00:00,2018-05-10 23:39:54.991882 +00:00,"0207 Patrick Fork Apt. 700 Christopherside, FL 04132",90
410,2025-07-01 18:23:25.711943 +00:00,2025-07-31 08:23:25.711943 +00:00,"16714 Glen Branch Apt. 821 Port John, MS 53464",90
411,2019-02-15 22:13:01.042495 +00:00,2019-04-04 15:13:01.042495 +00:00,"91338 Jacob Rue East Russellborough, WI 25113",91
412,2013-11-28 20:52:28.708341 +00:00,2014-03-04 01:52:28.708341 +00:00,"4087 John Crest Port Ryanton, PW 26494",91
413,2016-08-20 02:50:43.813659 +00:00,2016-10-22 10:50:43.813659 +00:00,"72683 Kenneth Plaza Suite 100 East Ashleemouth, IN 55191",91
414,2019-06-01 15:00:13.186926 +00:00,2019-07-18 17:00:13.186926 +00:00,"759 Wise Unions Suite 560 East Maryton, KS 44555",91
415,2017-10-01 18:58:54.578664 +00:00,2017-11-18 16:58:54.578664 +00:00,"9855 Sydney Row West Bryanshire, VA 89480",91
416,2025-09-08 08:55:51.218465 +00:00,,"3379 James Trafficway West Sarahport, PA 88279",91
417,2025-09-18 08:19:03.215844 +00:00,,"9826 Burton Mall Lake Brandonview, NM 48581",91
418,2011-11-03 16:50:25.624734 +00:00,2012-01-06 15:50:25.624734 +00:00,"2917 Coffey Estates Apt. 687 South Stephanie, DC 19645",91
419,2013-10-09 03:50:30.686711 +00:00,2013-11-16 06:50:30.686711 +00:00,"47158 Livingston Ford Apt. 683 Jenkinsville, DC 58761",92
420,2010-11-30 09:36:09.761160 +00:00,2010-12-08 22:36:09.761160 +00:00,"977 Robinson Flats South Amber, NJ 78901",93
421,2013-04-14 21:00:53.174419 +00:00,2013-05-02 19:00:53.174419 +00:00,"05022 Wells Mission Apt. 113 Danielmouth, TN 34222",93
422,2018-04-03 08:22:15.758038 +00:00,2018-04-21 11:22:15.758038 +00:00,"6827 Wilson Plaza Joneschester, CT 41593",94
423,2010-05-26 00:50:10.672629 +00:00,2010-06-08 03:50:10.672629 +00:00,"253 George Prairie Smithbury, UT 88213",94
424,2010-09-15 21:10:03.232809 +00:00,2010-10-04 10:10:03.232809 +00:00,"29669 Brenda Drive Mitchellfurt, WY 92366",94
425,2017-01-22 01:29:22.154916 +00:00,2017-03-27 10:29:22.154916 +00:00,Unit 4930 Box 7345 DPO AA 51397,95
426,2025-07-13 22:27:26.829293 +00:00,2025-07-18 12:27:26.829293 +00:00,"7618 Matthew Ramp Apt. 982 Port Davidland, AL 33594",95
427,2022-01-16 19:02:13.303823 +00:00,2022-03-15 02:02:13.303823 +00:00,"PSC 3187, Box 3205 APO AE 20718",95
428,2014-06-15 10:43:09.824686 +00:00,2014-08-13 09:43:09.824686 +00:00,"8784 Katherine Knoll Suite 541 North Heidiville, NY 07241",96
429,2025-09-20 15:23:17.037474 +00:00,2025-09-22 17:23:17.037474 +00:00,"928 Joshua Camp Cummingsstad, MA 16901",96
430,2014-08-13 01:14:27.752910 +00:00,2014-10-14 13:14:27.752910 +00:00,"0575 Perez Dam Arnoldchester, WV 91028",96
431,2010-10-18 02:41:20.920664 +00:00,2010-12-10 10:41:20.920664 +00:00,"1010 Robert Dale Apt. 426 Robinsonborough, VT 73099",96
432,2025-09-22 22:02:30.862357 +00:00,,"009 Sutton Haven East Ashleyview, NM 28914",96
433,2017-01-29 19:27:38.787115 +00:00,2017-04-27 22:27:38.787115 +00:00,"1238 Melissa Union Suite 085 Wilsonberg, NJ 10020",97
434,2025-07-28 10:09:33.751715 +00:00,2025-08-07 15:09:33.751715 +00:00,"1553 Nguyen Trafficway Apt. 227 Port William, NE 06559",97
435,2024-05-28 15:25:28.691535 +00:00,2024-05-31 13:25:28.691535 +00:00,"6282 Jacobson Burg Apt. 228 Rosetown, GA 75421",97
436,2017-05-07 09:18:17.573912 +00:00,2017-08-13 17:18:17.573912 +00:00,"03754 Suarez Terrace Smallborough, MD 26874",97
437,2017-08-26 01:09:57.531035 +00:00,2017-10-09 10:09:57.531035 +00:00,"84796 Devon Ramp Apt. 660 Johnberg, MO 89139",97
438,2025-07-07 14:03:28.533681 +00:00,2025-09-25 09:03:28.533681 +00:00,"13803 Bailey Canyon Suite 287 West Kayla, OR 29030",97
439,2011-07-12 19:17:33.138099 +00:00,2011-07-16 08:17:33.138099 +00:00,"7023 Adams Knoll Apt. 982 North Jasonland, TX 74919",98
440,2025-09-28 13:55:10.833879 +00:00,,"338 Sanders Street Hoopermouth, IN 50433",98
441,2018-09-08 02:42:37.641931 +00:00,2018-10-22 01:42:37.641931 +00:00,"603 John Plain Port Thomas, MN 77203",98
442,2020-10-08 12:11:35.207509 +00:00,2020-12-16 16:11:35.207509 +00:00,"517 Chang Glens Apt. 225 South Shannonland, NC 74728",98
443,2025-09-14 04:33:52.443248 +00:00,2025-09-27 12:33:52.443248 +00:00,"48791 Jesus Plaza Apt. 907 Port Davidton, PA 32950",98
444,2025-07-09 08:59:02.169312 +00:00,2025-07-12 01:59:02.169312 +00:00,"1095 Thompson Courts Apt. 185 New John, GU 66587",99
445,2017-01-28 13:19:31.146691 +00:00,2017-01-31 16:19:31.146691 +00:00,"82408 Evans Glens Deannamouth, MN 51051",99
446,2019-10-24 20:08:08.511076 +00:00,2020-01-12 20:08:08.511076 +00:00,"PSC 9751, Box 2251 APO AA 11119",99
447,2021-06-06 07:19:00.174280 +00:00,2021-07-24 15:19:00.174280 +00:00,"21166 Mcclain Manor New Katherine, OH 87467",99
448,2020-01-11 03:33:20.674907 +00:00,2020-01-24 16:33:20.674907 +00:00,"0675 Denise Camp Apt. 948 Jonesborough, SD 24606",99
449,2024-01-28 23:16:11.780933 +00:00,2024-04-19 20:16:11.780933 +00:00,"06735 Marissa Crest East Evanstad, CT 74920",100
450,2022-05-15 04:43:46.750587 +00:00,2022-06-22 07:43:46.750587 +00:00,"22868 Jason Run Apt. 676 East Jeffrey, AS 18590",100
451,2017-01-23 07:06:35.912739 +00:00,2017-02-17 22:06:35.912739 +00:00,USCGC Glenn FPO AE 85623,100
452,2025-07-01 12:25:37.010302 +00:00,2025-07-22 03:25:37.010302 +00:00,"5062 Harrison Islands East Jose, AK 15356",100
453,2025-07-16 23:11:29.458248 +00:00,2025-09-06 05:11:29.458248 +00:00,"150 Tran Ridges Apt. 890 Turnermouth, MT 11798",100
454,2015-06-09 05:17:45.654049 +00:00,2015-08-09 06:17:45.654049 +00:00,"649 Noah Stream Suite 598 Lake Laurenmouth, NC 58157",100
455,2025-08-05 11:43:22.286351 +00:00,,"59425 Cynthia Courts New Cherylton, NM 43013",100
456,2025-07-21 22:12:53.083956 +00:00,2025-09-08 16:12:53.083956 +00:00,"2771 David Square New Patricia, MI 17582",100
457,2025-09-12 16:58:56.503796 +00:00,,"035 Diana Plaza Suite 782 North Aaron, MN 71026",101
458,2010-07-24 06:13:41.855694 +00:00,2010-10-26 10:13:41.855694 +00:00,"623 Lori Grove Danaside, NE 30617",101
459,2025-09-16 22:18:17.171679 +00:00,,"72229 Karen Neck West Michelle, NY 37893",101
460,2013-11-26 19:44:54.716294 +00:00,2014-01-21 15:44:54.716294 +00:00,"9198 Brandon Extension Apt. 606 Traceyfort, IL 58707",101
461,2025-07-10 12:40:33.308585 +00:00,,"559 Duane River Apt. 827 Lake Matthewbury, MI 22967",101
462,2025-07-12 17:35:34.935094 +00:00,2025-08-12 13:35:34.935094 +00:00,"0275 Leon Fork Victoriafurt, GU 90164",101
463,2010-04-27 02:48:52.773346 +00:00,2010-05-01 01:48:52.773346 +00:00,"113 Anna Extensions Suite 296 Snyderstad, VT 33210",102
464,2025-08-10 01:53:53.678569 +00:00,,"07092 Bryant Shoals Geraldmouth, AR 24316",102
465,2010-01-20 16:31:46.143285 +00:00,2010-04-18 09:31:46.143285 +00:00,"5704 Mcdaniel Place Apt. 461 Port Benjamin, OK 74354",102
466,2018-04-07 06:01:30.712755 +00:00,2018-06-26 16:01:30.712755 +00:00,"8075 Anderson Common North Jason, MH 30004",102
467,2016-11-22 17:40:17.441097 +00:00,2017-01-24 00:40:17.441097 +00:00,"85735 Catherine Greens East Michael, NY 01616",102
468,2013-01-17 02:20:11.382315 +00:00,2013-03-08 07:20:11.382315 +00:00,"404 Kathryn Island Silvaberg, NE 19131",102
469,2023-11-21 07:06:13.428706 +00:00,2024-02-10 23:06:13.428706 +00:00,"3934 Miller Curve South Julie, MI 01495",102
470,2019-06-28 08:42:21.521166 +00:00,2019-07-20 05:42:21.521166 +00:00,Unit 8415 Box 4305 DPO AA 74442,102
471,2025-07-15 04:54:50.581578 +00:00,2025-09-21 07:54:50.581578 +00:00,"995 Guerra Shores Jenniferborough, CT 81731",103
472,2011-02-22 12:08:01.574126 +00:00,2011-05-24 13:08:01.574126 +00:00,"4997 Susan Crossing Apt. 591 Hicksfort, LA 43052",103
473,2023-11-14 03:37:26.107997 +00:00,2024-01-12 17:37:26.107997 +00:00,"12731 Craig Springs East Christopherhaven, MO 52300",103
474,2012-10-01 19:29:51.272965 +00:00,2012-10-29 12:29:51.272965 +00:00,"39748 Madison Brooks Apt. 201 Port Veronica, FM 69496",103
475,2017-08-06 14:53:49.790080 +00:00,2017-11-11 11:53:49.790080 +00:00,"50401 Miranda Walk East Sarahland, TN 00643",103
476,2025-08-29 14:26:34.906576 +00:00,2025-08-30 10:26:34.906576 +00:00,"1485 Tony Vista Suite 237 Reneeshire, AR 65967",103
477,2019-12-11 20:09:53.259823 +00:00,2020-02-14 00:09:53.259823 +00:00,"56766 Franco Falls New Rebecca, VA 58140",103
478,2025-07-30 20:32:02.672258 +00:00,2025-08-04 10:32:02.672258 +00:00,"589 Sandra Light Suite 519 Sanchezfurt, IN 74447",103
479,2025-08-10 19:33:08.631758 +00:00,2025-09-25 00:33:08.631758 +00:00,USNS Heath FPO AE 43220,104
480,2019-05-25 05:39:20.437106 +00:00,2019-08-15 22:39:20.437106 +00:00,"4155 Mitchell Run Apt. 686 Bradyland, CA 56525",104
481,2025-09-08 03:01:32.990818 +00:00,,"4635 Soto Manor Apt. 625 New Zacharyside, PR 83797",104
482,2025-07-08 15:37:03.493045 +00:00,2025-08-29 12:37:03.493045 +00:00,"4146 Alvarado Bridge East Bethhaven, AL 67868",104
483,2025-09-21 23:01:16.458018 +00:00,,"13803 Bailey Canyon Suite 287 West Kayla, OR 29030",104
484,2012-01-21 22:59:41.615448 +00:00,2012-02-26 18:59:41.615448 +00:00,"9804 Shepard Square Parkerburgh, NM 52621",104
485,2025-08-22 07:26:01.463207 +00:00,,USCGC Casey FPO AP 12043,104
486,2025-08-09 03:20:55.933709 +00:00,2025-09-09 14:20:55.933709 +00:00,"69564 Walker Trafficway Apt. 402 South Peggy, CA 44334",105
487,2016-03-25 12:02:49.969572 +00:00,2016-05-04 02:02:49.969572 +00:00,"3878 Hansen Crescent Apt. 705 Lake Andrew, IL 56553",105
488,2018-08-19 17:23:57.720038 +00:00,2018-11-20 15:23:57.720038 +00:00,"917 Gerald Corner Apt. 687 North Jocelynport, MD 27981",105
489,2011-10-03 22:58:46.751711 +00:00,2011-11-23 13:58:46.751711 +00:00,"2010 Courtney Land Nelsonbury, TN 37152",105
490,2013-08-19 00:07:22.267710 +00:00,2013-09-25 07:07:22.267710 +00:00,"5484 Leblanc Cove Port Victorton, HI 82738",105
491,2019-01-27 22:53:20.826737 +00:00,2019-04-21 01:53:20.826737 +00:00,"9089 Kristin Divide Isabellaside, SD 20624",105
492,2025-08-20 13:43:01.565559 +00:00,2025-08-23 11:43:01.565559 +00:00,"614 William Forges Suite 544 Port Danielleberg, OK 21006",105
493,2010-04-04 11:09:41.742124 +00:00,2010-05-25 02:09:41.742124 +00:00,"81732 Frederick Springs Lake Chelsea, GA 02566",105
494,2015-11-21 16:35:35.592558 +00:00,2016-02-25 07:35:35.592558 +00:00,Unit 7650 Box 6899 DPO AA 16295,106
495,2015-09-29 00:24:12.717710 +00:00,2015-10-21 12:24:12.717710 +00:00,"810 Hood Mountains Apt. 299 Robertview, RI 58955",106
496,2020-05-30 20:49:46.927821 +00:00,2020-06-28 14:49:46.927821 +00:00,Unit 9340 Box 4091 DPO AE 18018,106
497,2013-10-26 04:01:25.506932 +00:00,2013-11-14 08:01:25.506932 +00:00,Unit 7383 Box 5473 DPO AE 79237,106
498,2025-08-28 01:27:23.092620 +00:00,2025-08-31 14:27:23.092620 +00:00,"29404 Goodwin Grove Apt. 114 South Edgar, RI 17748",106
499,2025-07-26 11:58:39.661996 +00:00,,"99673 Carlos Walks Daniellemouth, LA 28273",106
500,2017-07-15 02:37:41.850087 +00:00,2017-07-29 06:37:41.850087 +00:00,"10161 Jordan Isle Suite 034 Murphyshire, GA 99195",106
501,2025-09-17 03:36:07.781087 +00:00,,"01853 Beth Street Apt. 921 Lake Robert, FL 42803",106
502,2015-11-03 19:07:31.766556 +00:00,2015-12-22 08:07:31.766556 +00:00,"38178 Edwards Grove Apt. 038 Amberborough, ID 24394",107
503,2016-05-04 14:21:46.903366 +00:00,2016-07-22 03:21:46.903366 +00:00,"8898 Anderson Freeway New Noah, MI 39916",107
504,2011-01-09 22:34:17.595780 +00:00,2011-04-06 14:34:17.595780 +00:00,"3243 Perkins Creek Apt. 373 Amandaview, IA 06978",107
505,2012-07-20 05:41:20.016205 +00:00,2012-10-11 03:41:20.016205 +00:00,"5134 Kerr Light Hooverhaven, OK 45564",107
506,2019-08-08 08:06:25.356206 +00:00,2019-10-25 16:06:25.356206 +00:00,"761 John Passage Jonathantown, TN 14048",107
507,2025-07-02 07:25:19.501953 +00:00,2025-07-14 14:25:19.501953 +00:00,"828 Weber Ports South William, PA 17678",108
508,2025-09-11 20:20:19.818503 +00:00,,"65356 Kimberly Fords Apt. 789 Acostaside, KS 24400",109
509,2022-09-23 17:36:58.734445 +00:00,2022-11-06 11:36:58.734445 +00:00,"23366 Santos Haven Apt. 055 East Patrickfurt, NY 20311",109
510,2025-07-16 13:16:01.969781 +00:00,,"04762 Dawson Pine Apt. 515 Lake Meghanshire, WI 58212",110
511,2025-09-01 06:36:28.261961 +00:00,,"620 Clark Oval Apt. 575 Howellhaven, HI 52664",110
512,2018-08-28 17:39:46.285760 +00:00,2018-10-28 08:39:46.285760 +00:00,"884 Lisa Centers Antoniofort, MP 01449",110
513,2016-11-03 23:49:15.666737 +00:00,2017-01-10 11:49:15.666737 +00:00,"864 Green Club Suite 387 Millerborough, MT 76223",110
514,2015-07-18 10:57:07.457397 +00:00,2015-10-05 14:57:07.457397 +00:00,"0549 Eric Junctions Reesemouth, AR 35632",110
515,2025-09-19 11:10:59.880605 +00:00,,Unit 9954 Box 1966 DPO AA 93581,110
516,2025-09-01 18:34:58.405347 +00:00,2025-09-20 22:34:58.405347 +00:00,"84009 Barry Trace Port Kyle, DC 21175",111
517,2025-09-09 20:14:29.217647 +00:00,2025-09-27 08:14:29.217647 +00:00,"21127 Ashley Divide Benjaminview, RI 11037",111
518,2011-10-25 01:02:48.769226 +00:00,2011-12-21 08:02:48.769226 +00:00,"623 Johnson Crossing Danielleshire, SD 21157",111
519,2016-05-01 13:57:35.466106 +00:00,2016-05-24 11:57:35.466106 +00:00,"479 Bryant Hill East Matthew, MS 89619",111
520,2022-10-28 07:49:47.790433 +00:00,2022-12-17 22:49:47.790433 +00:00,"907 Sara Rest Huffmanfort, OR 39122",111
521,2021-03-18 06:05:01.993063 +00:00,2021-06-23 18:05:01.993063 +00:00,"8761 Caitlyn Glen Lisashire, GA 91499",111
522,2017-11-24 21:41:04.457145 +00:00,2017-12-05 07:41:04.457145 +00:00,"0542 Sean Extension Suite 837 South Erin, ND 77361",112
523,2018-04-21 06:05:04.488706 +00:00,2018-07-20 01:05:04.488706 +00:00,"3021 Chen Run Suite 533 South Mathew, KY 90421",112
524,2014-08-09 04:59:08.063522 +00:00,2014-11-09 11:59:08.063522 +00:00,"725 Price Points New Bobbystad, CA 07668",112
525,2025-07-17 02:15:15.112393 +00:00,2025-08-13 19:15:15.112393 +00:00,"503 Johnson Stream Suite 817 Garciabury, MI 36653",113
526,2011-07-27 17:39:01.920741 +00:00,2011-08-30 01:39:01.920741 +00:00,"91188 Lisa Drive West Hannahport, CA 08055",113
527,2015-07-10 11:11:43.204624 +00:00,2015-10-03 16:11:43.204624 +00:00,"14973 Christopher Parkway Apt. 440 Lake Francisburgh, AS 68173",113
528,2012-10-01 10:46:28.615410 +00:00,2012-10-18 02:46:28.615410 +00:00,"4858 Allison Inlet East Ryan, SD 24520",113
529,2019-12-08 07:58:12.026702 +00:00,2020-02-22 08:58:12.026702 +00:00,"PSC 6279, Box 4895 APO AA 26218",113
530,2024-04-21 12:24:40.031970 +00:00,2024-05-11 02:24:40.031970 +00:00,"46121 Molly Ways Apt. 858 Michelletown, MI 56930",113
531,2022-06-20 23:47:38.855226 +00:00,2022-08-04 13:47:38.855226 +00:00,"180 Anthony Highway East Donaldfort, RI 75057",114
532,2025-07-13 22:06:31.220935 +00:00,2025-08-19 19:06:31.220935 +00:00,"7479 Frazier Pass Apt. 963 Jeffreyhaven, AZ 70214",114
533,2023-10-03 11:39:19.929032 +00:00,2023-11-04 03:39:19.929032 +00:00,"661 Wyatt Port Saraland, IN 90327",114
534,2022-01-30 17:23:54.058501 +00:00,2022-05-05 02:23:54.058501 +00:00,"72819 Smith Square South Shawnshire, ME 87710",114
535,2025-08-31 02:04:09.243476 +00:00,2025-09-06 23:04:09.243476 +00:00,"677 Cisneros Views Apt. 128 Lake Joann, OR 47208",115
536,2010-11-20 16:07:50.373407 +00:00,2010-12-19 10:07:50.373407 +00:00,USS Miller FPO AP 78520,115
537,2011-08-24 08:33:40.654332 +00:00,2011-10-22 02:33:40.654332 +00:00,"61814 Willis Run Kentside, AL 17463",115
538,2025-08-23 13:26:55.487185 +00:00,,"28269 Gregory Harbors East Sheri, ID 31796",115
539,2025-10-01 14:50:30.743329 +00:00,,"201 Price Wall West Aliciachester, MA 02253",115
540,2025-01-04 04:38:07.903112 +00:00,2025-03-04 18:38:07.903112 +00:00,"6343 Michael Causeway Suite 984 Victorton, OH 16706",115
541,2016-02-09 05:14:45.306536 +00:00,2016-04-01 02:14:45.306536 +00:00,"3003 Jasmine Run Saundersbury, WI 41099",115
542,2025-07-05 02:09:28.190020 +00:00,2025-08-15 18:09:28.190020 +00:00,"210 Williams Haven Matthewsville, AZ 56207",116
543,2024-05-22 05:29:08.078524 +00:00,2024-08-06 16:29:08.078524 +00:00,"13573 Peters Lock Beckerview, ID 11664",116
544,2015-08-17 14:36:37.637755 +00:00,2015-08-29 21:36:37.637755 +00:00,USCGC Pierce FPO AA 51753,117
545,2024-07-19 06:30:18.709768 +00:00,2024-09-22 11:30:18.709768 +00:00,"3434 Wood Port Apt. 309 Charlesside, MS 65004",117
546,2025-08-29 00:41:18.580098 +00:00,,"PSC 6719, Box 6982 APO AP 52164",118
547,2025-08-05 09:20:09.930808 +00:00,2025-09-13 23:20:09.930808 +00:00,"4456 Camacho Green South Laura, NC 65780",118
548,2020-03-18 12:59:57.072605 +00:00,2020-06-22 03:59:57.072605 +00:00,"95066 Jeffrey Ramp New Marissa, NY 20409",118
549,2021-04-15 19:27:29.741455 +00:00,2021-06-13 18:27:29.741455 +00:00,"969 Nelson Mill Suite 295 Jasonside, NJ 20370",118
550,2025-08-10 15:07:17.941597 +00:00,,"05763 Walters Viaduct Erinborough, HI 06039",118
551,2020-07-23 23:43:27.596792 +00:00,2020-09-17 19:43:27.596792 +00:00,"766 Brooks Drive Patrickton, HI 42085",118
552,2024-01-20 13:01:22.435530 +00:00,2024-03-30 23:01:22.435530 +00:00,"4642 Sonya Extensions West Dale, NC 38840",118
553,2025-09-17 03:32:28.955962 +00:00,,"990 Kelly Summit Suite 112 Mcclainville, KY 69003",118
554,2020-04-19 03:43:14.837887 +00:00,2020-06-27 07:43:14.837887 +00:00,"815 Miles Oval East Nathan, OH 87426",119
555,2019-01-05 18:18:43.574742 +00:00,2019-03-23 20:18:43.574742 +00:00,"45348 Jonathan Ridge Lake Erica, NM 95506",119
556,2015-11-04 07:43:31.780640 +00:00,2015-11-06 14:43:31.780640 +00:00,"649 Tonya Mount East Jenniferborough, FM 97795",119
557,2011-05-13 04:56:34.547548 +00:00,2011-08-17 15:56:34.547548 +00:00,"8098 Allison Roads Brownborough, OH 38405",119
558,2013-01-18 23:51:34.034798 +00:00,2013-04-12 17:51:34.034798 +00:00,"192 Adkins Parkway East Albert, SC 77954",119
559,2014-02-20 11:21:18.715553 +00:00,2014-04-18 13:21:18.715553 +00:00,"7159 Joshua Alley Suite 394 Duncanmouth, MS 86910",119
560,2025-08-26 22:34:28.679569 +00:00,,"1910 Jerome Shores North Joannashire, MP 88815",119
561,2025-07-19 07:20:18.322535 +00:00,2025-08-26 20:20:18.322535 +00:00,Unit 3333 Box 5304 DPO AA 55689,120
562,2013-07-17 05:39:48.401228 +00:00,2013-08-07 21:39:48.401228 +00:00,Unit 3285 Box 4287 DPO AP 31457,120
563,2016-08-05 03:42:19.248127 +00:00,2016-10-02 06:42:19.248127 +00:00,"755 Sharon Causeway Suite 221 Richardport, GU 04928",120
564,2012-07-25 15:20:18.947783 +00:00,2012-09-21 08:20:18.947783 +00:00,"55843 Turner Valley East Jonathanport, NM 35272",121
565,2025-08-25 05:47:48.449430 +00:00,,"603 Tina Loaf South Tanner, TN 65783",121
566,2025-10-02 19:44:52.237781 +00:00,,"7152 Brown Walk North Alyssaview, NM 72206",121
567,2017-03-21 06:07:01.519201 +00:00,2017-05-19 00:07:01.519201 +00:00,"9199 Robert Lights Pacetown, AZ 31859",121
568,2011-06-09 16:53:13.650532 +00:00,2011-06-28 00:53:13.650532 +00:00,"2447 Colon Cove Lake Angela, AS 20723",122
569,2019-07-21 04:59:03.257824 +00:00,2019-08-03 02:59:03.257824 +00:00,"016 Joann Greens Suite 245 West Thomasfurt, IN 15246",122
570,2025-09-13 19:38:50.946907 +00:00,,"18881 Smith Creek Suite 209 South Justin, KY 33910",122
571,2025-09-24 06:50:15.656897 +00:00,,USNV Lopez FPO AA 63556,122
572,2025-08-23 15:50:06.634751 +00:00,2025-09-20 08:50:06.634751 +00:00,"0432 Henry Plaza Meyerfurt, ND 07031",122
573,2010-01-03 13:32:46.587082 +00:00,2010-01-31 16:32:46.587082 +00:00,"77662 Donna Turnpike Martinezport, MO 03410",123
574,2020-01-29 04:04:29.051029 +00:00,2020-02-28 04:04:29.051029 +00:00,"4514 Susan Plains Suite 980 Davidbury, VA 63321",123
575,2025-09-10 21:39:27.585604 +00:00,,"9503 Adams Curve Russellfurt, MP 73500",124
576,2010-04-01 11:44:03.766460 +00:00,2010-06-19 05:44:03.766460 +00:00,"324 Bryant Common Apt. 096 South Richard, TX 98950",124
577,2022-08-13 16:12:59.934162 +00:00,2022-10-17 01:12:59.934162 +00:00,"30138 Timothy Squares Suite 497 Lake Jamie, RI 24508",124
578,2012-03-16 11:47:26.623184 +00:00,2012-04-12 13:47:26.623184 +00:00,"95373 Edwards Gateway Suite 005 East Jacob, WY 85741",124
579,2025-07-25 00:18:37.468022 +00:00,2025-10-05 07:18:37.468022 +00:00,"PSC 7012, Box 9116 APO AA 74790",124
580,2025-07-06 13:27:42.925133 +00:00,2025-10-02 16:27:42.925133 +00:00,"4185 Gross Glen Apt. 637 South Christopherchester, CA 82454",124
581,2025-07-30 19:06:23.646211 +00:00,2025-09-14 00:06:23.646211 +00:00,"278 Long Lane Oliviastad, MA 11994",124
582,2015-06-11 23:45:00.708367 +00:00,2015-07-16 03:45:00.708367 +00:00,"4435 Jamie Corner Jessicashire, WV 58559",124
583,2021-12-21 17:37:55.019156 +00:00,2022-03-13 19:37:55.019156 +00:00,"8313 Foster Burgs Suite 596 South Walterfurt, ME 15006",125
584,2020-11-21 19:13:49.848200 +00:00,2020-12-07 10:13:49.848200 +00:00,"144 Robertson Mountains New Brenda, IA 95288",126
585,2025-07-15 01:03:35.672219 +00:00,,USNS Davis FPO AA 24683,126
586,2025-07-11 17:48:32.294348 +00:00,2025-08-10 12:48:32.294348 +00:00,"7167 Michelle Trail West Kaitlin, MT 45785",126
587,2013-07-05 04:56:03.323603 +00:00,2013-10-10 11:56:03.323603 +00:00,"71895 Cameron Plains Suite 223 Jamesburgh, PA 30245",126
588,2014-02-05 00:25:40.493269 +00:00,2014-04-28 12:25:40.493269 +00:00,"1579 Rebecca Inlet Apt. 016 Port Connie, IA 73752",126
589,2025-09-10 09:16:47.829966 +00:00,2025-10-01 05:16:47.829966 +00:00,"0536 Tina Light Apt. 882 West Albertton, MD 07864",126
590,2025-09-08 13:33:07.811638 +00:00,,"402 Matthew Ramp Suite 859 West Ericville, MT 62365",126
591,2019-12-21 18:34:59.660896 +00:00,2020-01-21 19:34:59.660896 +00:00,"3494 Campbell Corner New Mitchellmouth, IL 96769",127
592,2018-12-09 10:16:41.637953 +00:00,2018-12-21 07:16:41.637953 +00:00,"62591 Amber Turnpike New Jennifer, PW 86633",128
593,2012-09-18 04:56:22.407919 +00:00,2012-10-11 17:56:22.407919 +00:00,"950 Rogers Loaf Christyland, LA 60415",128
594,2012-04-14 03:45:37.771574 +00:00,2012-04-16 15:45:37.771574 +00:00,"33707 Brandon Groves Jasonberg, ID 45874",128
595,2025-08-29 19:09:42.394371 +00:00,2025-09-13 04:09:42.394371 +00:00,"58476 Steven Village Port Rebecca, OK 21072",128
596,2025-08-17 06:13:03.360716 +00:00,2025-09-10 15:13:03.360716 +00:00,"9369 Vaughn Locks Apt. 051 Johnfort, SC 93822",128
597,2023-12-13 13:06:32.576756 +00:00,2024-01-08 04:06:32.576756 +00:00,"7369 Gray Circles Apt. 524 Kristinburgh, PA 76030",128
598,2014-02-09 22:40:39.147182 +00:00,2014-04-28 20:40:39.147182 +00:00,"748 Williams Mills Apt. 575 North Lisafurt, ND 58098",128
599,2025-09-15 21:05:56.310674 +00:00,,"2129 Barrett Avenue Brettside, IL 50123",129
600,2012-04-18 22:25:26.922112 +00:00,2012-07-19 09:25:26.922112 +00:00,"753 Hall Freeway Suite 325 Marymouth, CO 53713",129
601,2025-10-03 17:41:09.350727 +00:00,,"52926 Jasmine Green Apt. 403 Port Alison, SD 22190",129
602,2016-05-15 13:04:07.868320 +00:00,2016-07-17 06:04:07.868320 +00:00,"47948 Hood Island Hectorshire, NM 42221",129
603,2024-12-15 13:18:45.562672 +00:00,2025-03-23 16:18:45.562672 +00:00,"629 Figueroa River Maryton, OH 23289",129
604,2022-03-03 16:01:41.413796 +00:00,2022-05-27 21:01:41.413796 +00:00,"123 Phillip Common New Kristinahaven, WV 19569",129
605,2013-10-27 23:43:15.741792 +00:00,2013-12-01 03:43:15.741792 +00:00,"07315 Nicole Track Katherineville, MP 42179",129
606,2014-07-28 10:50:03.041204 +00:00,2014-08-07 15:50:03.041204 +00:00,Unit 0177 Box 6434 DPO AE 37926,129
607,2018-03-21 10:25:27.737875 +00:00,2018-04-17 02:25:27.737875 +00:00,"3985 Lauren Tunnel Jasminland, GU 11233",130
608,2016-01-13 14:20:48.569973 +00:00,2016-01-26 02:20:48.569973 +00:00,"5539 Braun Stream Suite 994 Andersonfurt, IA 93546",130
609,2021-12-29 08:31:19.966987 +00:00,2022-03-17 06:31:19.966987 +00:00,"65168 Smith Port Suite 083 Jasminetown, IL 47485",130
610,2022-10-19 10:26:49.593286 +00:00,2022-12-27 19:26:49.593286 +00:00,"80372 Price Ferry Suite 484 South Julie, HI 17395",130
611,2017-09-14 16:11:40.437352 +00:00,2017-12-10 08:11:40.437352 +00:00,"6043 Carter Ville North Katiemouth, DE 88988",131
612,2016-12-22 11:45:35.281731 +00:00,2017-03-01 00:45:35.281731 +00:00,"118 Lori Valleys Apt. 627 South Aliciaside, OH 05066",131
613,2025-05-03 11:12:14.149781 +00:00,2025-08-08 23:12:14.149781 +00:00,"576 Hampton Loop Suite 735 Theresastad, IA 54925",131
614,2015-01-08 04:18:04.062747 +00:00,2015-04-11 12:18:04.062747 +00:00,"527 Brown Mews Suite 849 Karenfort, MP 14049",131
615,2025-08-09 13:43:53.815830 +00:00,,"855 Miguel Pike North Lukeport, AR 38371",131
616,2016-11-17 16:47:50.723193 +00:00,2017-02-24 05:47:50.723193 +00:00,"6719 Brad Camp Suite 649 Georgeville, LA 79287",131
617,2025-07-26 18:13:46.492184 +00:00,2025-09-04 18:13:46.492184 +00:00,"0308 Maria Ports Collinsstad, VI 38095",131
618,2023-02-26 07:03:37.771735 +00:00,2023-05-13 13:03:37.771735 +00:00,"538 Shawn Groves New Kyleshire, WA 49915",131
619,2025-07-16 20:03:48.141070 +00:00,,"03610 Ware Skyway Alyssamouth, NJ 60666",132
620,2011-06-10 13:27:53.671431 +00:00,2011-08-01 15:27:53.671431 +00:00,"01238 Catherine Loaf Apt. 885 New Brian, PR 68659",132
621,2025-09-22 08:53:55.854891 +00:00,,"454 Stein Coves North Tashaton, NE 81696",133
622,2025-09-26 21:06:47.337662 +00:00,,"2999 Melanie Brooks Powellberg, ME 68415",133
623,2025-09-27 05:49:50.921266 +00:00,,"3859 Smith Plain Porterchester, RI 98198",133
624,2015-08-17 04:42:43.703951 +00:00,2015-10-28 21:42:43.703951 +00:00,"16179 Christopher Well Lake Denise, MA 34492",133
625,2025-09-01 05:46:14.206001 +00:00,2025-09-12 21:46:14.206001 +00:00,"539 Sarah Extension South Megan, MS 47714",133
626,2016-04-13 09:19:34.049833 +00:00,2016-04-19 05:19:34.049833 +00:00,"4305 Hill Fort Suite 099 Rogerborough, PR 49204",134
627,2023-11-25 16:23:36.982593 +00:00,2024-01-13 10:23:36.982593 +00:00,"2888 Rebecca Forks Apt. 853 Jasonview, KS 43673",134
628,2023-03-26 03:50:22.136575 +00:00,2023-04-05 03:50:22.136575 +00:00,"55952 Flores Fall Apt. 296 North Madisonbury, AL 58264",134
629,2017-02-22 10:57:47.673102 +00:00,2017-03-21 17:57:47.673102 +00:00,"158 Colleen Divide Zunigaport, NJ 43991",134
630,2012-05-22 17:35:22.019026 +00:00,2012-08-29 01:35:22.019026 +00:00,"10136 Ross Drives South Faithchester, TX 49433",134
631,2025-04-22 09:07:39.793592 +00:00,2025-06-19 22:07:39.793592 +00:00,"7232 Morris Islands Alejandroborough, OH 08910",134
632,2015-09-20 20:52:53.236246 +00:00,2015-12-22 08:52:53.236246 +00:00,"93329 Stacy Prairie Apt. 727 Kennethshire, AR 74578",134
633,2015-08-20 05:05:17.657141 +00:00,2015-08-22 02:05:17.657141 +00:00,"73331 Tracey Trail New Amandamouth, NC 76997",134
634,2014-05-29 16:34:26.668033 +00:00,2014-07-31 14:34:26.668033 +00:00,"2406 Brandon Cliffs Gonzalezside, NY 67644",135
635,2019-09-02 05:15:48.673668 +00:00,2019-11-01 15:15:48.673668 +00:00,"4299 Ruth Ferry Apt. 539 Ellisstad, ND 98235",135
636,2018-04-20 14:32:59.360350 +00:00,2018-06-09 19:32:59.360350 +00:00,"6438 Katherine Station Apt. 895 Woodsstad, MT 37343",135
637,2025-09-05 21:27:45.610669 +00:00,,"130 Williams Spur Apt. 936 Port Diane, UT 14898",135
638,2020-09-14 02:50:26.260377 +00:00,2020-12-19 18:50:26.260377 +00:00,"001 Jason Cliffs Apt. 088 Port Janice, MD 67904",135
639,2010-12-28 18:16:56.688008 +00:00,2011-02-21 18:16:56.688008 +00:00,"165 Christina Road Apt. 588 Madisonhaven, SC 02655",136
640,2010-05-15 14:38:37.680023 +00:00,2010-07-04 19:38:37.680023 +00:00,"851 David Center Barbaraton, IN 10440",136
641,2025-02-27 00:03:29.552968 +00:00,2025-05-27 09:03:29.552968 +00:00,USS Miller FPO AP 77733,136
642,2013-08-25 18:30:56.757642 +00:00,2013-09-12 11:30:56.757642 +00:00,"PSC 6003, Box 2581 APO AA 30091",136
643,2017-01-20 11:12:13.097558 +00:00,2017-02-23 15:12:13.097558 +00:00,"564 Clayton Key Chavezport, CA 13401",136
644,2017-08-29 01:07:32.258869 +00:00,2017-11-27 01:07:32.258869 +00:00,"65356 Kimberly Fords Apt. 789 Acostaside, KS 24400",136
645,2017-04-15 03:56:08.690069 +00:00,2017-06-18 22:56:08.690069 +00:00,"526 Reynolds Shoals Suite 832 Johnnymouth, ME 97671",136
646,2017-07-06 12:24:01.877458 +00:00,2017-07-18 14:24:01.877458 +00:00,"68352 Christopher Shoal Joshuabury, TN 43125",136
647,2018-12-04 05:05:05.288682 +00:00,2019-02-02 20:05:05.288682 +00:00,"86932 Kevin Junction Lake Sonya, KY 80079",137
648,2018-11-12 22:40:50.457595 +00:00,2018-12-19 04:40:50.457595 +00:00,"369 Whitehead Wells Apt. 842 West Peter, CT 63397",137
649,2023-10-27 10:40:11.376190 +00:00,2023-12-02 21:40:11.376190 +00:00,"PSC 7662, Box 0134 APO AP 10984",137
650,2018-11-22 10:41:53.801006 +00:00,2018-12-02 10:41:53.801006 +00:00,"7192 Arias Run Suite 506 Karaburgh, SD 70392",137
651,2016-10-11 07:08:40.219795 +00:00,2016-11-06 23:08:40.219795 +00:00,"5848 James Lane Suite 278 Lake Brian, AL 70517",137
652,2025-07-12 01:53:53.766339 +00:00,2025-07-17 06:53:53.766339 +00:00,"602 Turner Lodge Suite 514 Mccormickhaven, AK 28464",137
653,2025-03-19 15:09:10.970430 +00:00,2025-05-24 11:09:10.970430 +00:00,"48865 Scott Shoals Apt. 200 East Paulchester, IL 31086",138
654,2016-11-04 11:48:02.247699 +00:00,2017-01-30 13:48:02.247699 +00:00,"495 Theresa Estate Apt. 572 West Marcus, IL 04601",138
655,2011-09-13 05:15:07.406485 +00:00,2011-10-25 07:15:07.406485 +00:00,"36356 Jennifer Row Apt. 731 Lake Brandon, NV 02803",139
656,2024-11-17 11:48:20.567720 +00:00,2025-02-22 13:48:20.567720 +00:00,"1456 Ramirez Forges Apt. 163 Howemouth, MD 88396",139
657,2019-12-08 00:00:18.939541 +00:00,2020-02-16 05:00:18.939541 +00:00,"9148 Alexander Plains Suite 507 Kevinland, NE 68988",139
658,2019-05-06 18:14:54.481503 +00:00,2019-05-08 20:14:54.481503 +00:00,"9592 Patricia Isle Apt. 450 North Tylerberg, FL 57758",139
659,2020-07-20 09:31:53.944133 +00:00,2020-08-05 05:31:53.944133 +00:00,"809 Gibson Bridge Apt. 322 Bethmouth, MA 27148",140
660,2013-11-23 10:38:43.139056 +00:00,2014-02-27 11:38:43.139056 +00:00,"8678 Kristen Glens Suite 725 Bakerton, AS 07781",140
661,2025-07-05 23:16:33.514113 +00:00,2025-07-22 15:16:33.514113 +00:00,"62199 Franklin Fords Apt. 494 West Jennifer, NY 47439",140
662,2014-07-05 21:28:02.068842 +00:00,2014-07-19 20:28:02.068842 +00:00,USNV Lopez FPO AA 94841,140
663,2025-09-17 18:11:36.662576 +00:00,,Unit 3907 Box 9792 DPO AP 16940,140
664,2025-08-22 22:41:32.056540 +00:00,,"413 Joshua Spurs New Mariah, IA 12594",141
665,2013-03-06 19:57:40.677713 +00:00,2013-05-24 08:57:40.677713 +00:00,"349 Danny Dale Lake Elaineborough, WA 88683",141
666,2014-07-30 08:48:52.080849 +00:00,2014-10-10 15:48:52.080849 +00:00,"7620 Moreno River Suite 331 West Stanley, MD 38847",142
667,2010-09-24 00:49:48.770187 +00:00,2010-12-03 10:49:48.770187 +00:00,"717 Davidson Mountain Suite 756 Lake Amanda, NY 42294",142
668,2014-12-10 05:07:50.196034 +00:00,2015-01-07 23:07:50.196034 +00:00,"0942 Keller Row Apt. 335 North Katherine, HI 35741",143
669,2025-08-04 05:47:35.301825 +00:00,,"849 Brianna Curve Suite 287 Reynoldschester, CO 79055",143
670,2021-10-23 22:05:01.030591 +00:00,2021-11-04 19:05:01.030591 +00:00,"33499 Angel Shoal Suite 549 Lake Stacy, AL 89964",143
671,2023-01-22 04:30:04.573585 +00:00,2023-02-15 13:30:04.573585 +00:00,"109 Mcdonald Fords Apt. 601 Joshuaborough, ME 58377",143
672,2025-09-13 03:42:53.297478 +00:00,2025-10-05 20:42:53.297478 +00:00,"220 Joseph Plains Suite 854 Michaelmouth, IL 98236",143
673,2018-12-12 10:32:29.491471 +00:00,2019-02-14 09:32:29.491471 +00:00,"95121 Tammy Ridge Charlesland, LA 51141",143
674,2025-07-30 12:30:00.745939 +00:00,2025-08-18 16:30:00.745939 +00:00,"73723 Patel Trafficway Suite 107 Lake Carrieberg, ND 93331",143
675,2025-09-26 02:53:46.175754 +00:00,,"1659 Stephen Walks Apt. 319 New Allison, OK 58586",143
676,2023-12-08 13:07:53.458498 +00:00,2023-12-17 17:07:53.458498 +00:00,"1321 Megan Mountains Suite 737 Leonton, MI 33512",144
677,2016-09-19 03:36:27.003401 +00:00,2016-10-07 06:36:27.003401 +00:00,"9199 Robert Lights Pacetown, AZ 31859",144
678,2025-07-12 03:48:12.180856 +00:00,2025-07-13 14:48:12.180856 +00:00,"1245 Robert Square Lopezport, MH 18703",144
679,2025-07-27 04:19:12.579769 +00:00,2025-08-01 04:19:12.579769 +00:00,Unit 7765 Box 4277 DPO AP 11490,144
680,2023-03-28 20:37:52.700625 +00:00,2023-04-12 10:37:52.700625 +00:00,"9522 Marc Lodge Rivasberg, MO 97626",145
681,2025-03-30 21:39:37.951048 +00:00,2025-07-04 22:39:37.951048 +00:00,"899 Maria Stravenue Suite 295 Andersonfort, UT 40781",145
682,2010-03-12 22:30:56.124106 +00:00,2010-04-16 12:30:56.124106 +00:00,Unit 8162 Box 9458 DPO AP 49411,145
683,2024-07-12 15:38:29.212540 +00:00,2024-07-14 07:38:29.212540 +00:00,"0817 Danielle Inlet Apt. 125 Gordonshire, MP 36155",145
684,2025-08-19 22:09:29.245813 +00:00,2025-08-25 03:09:29.245813 +00:00,"0389 Toni Ranch Floresfurt, OK 51723",145
685,2022-09-25 00:00:16.135372 +00:00,2022-10-06 21:00:16.135372 +00:00,"088 Lewis Key Jennifermouth, GU 81066",145
686,2011-11-22 22:55:48.531678 +00:00,2012-02-23 15:55:48.531678 +00:00,"52916 Jessica Mountain New Isabellafort, MI 83548",146
687,2017-09-08 00:36:16.977678 +00:00,2017-11-29 07:36:16.977678 +00:00,"271 Andrew Glen Apt. 447 South Tammy, OR 92812",146
688,2023-03-29 09:25:03.760948 +00:00,2023-04-15 06:25:03.760948 +00:00,"576 Hampton Loop Suite 735 Theresastad, IA 54925",147
689,2021-03-14 14:26:00.201867 +00:00,2021-03-17 07:26:00.201867 +00:00,USS Mitchell FPO AP 86957,147
690,2025-09-07 10:01:37.694747 +00:00,,"6973 Gill Road Apt. 833 Tiffanyborough, PW 30669",147
691,2019-04-09 08:57:41.248017 +00:00,2019-05-26 05:57:41.248017 +00:00,"764 Tammy Bypass Apt. 045 Richardsonfurt, MO 84880",147
692,2020-01-26 05:53:47.473283 +00:00,2020-05-02 12:53:47.473283 +00:00,"645 Ryan Viaduct Apt. 477 Mcclureville, KS 09766",147
693,2016-10-12 02:45:13.867814 +00:00,2016-12-19 15:45:13.867814 +00:00,"158 Patterson Plains Apt. 773 Greenborough, OK 12557",148
694,2013-06-08 00:56:42.340539 +00:00,2013-08-07 10:56:42.340539 +00:00,"936 Austin Spring East Stephenland, MD 61227",148
695,2018-10-31 16:43:17.304671 +00:00,2018-12-31 02:43:17.304671 +00:00,"514 Joseph Highway South Austin, NC 87789",148
696,2018-02-09 10:57:44.357550 +00:00,2018-02-14 20:57:44.357550 +00:00,USCGC Santana FPO AP 48140,148
697,2018-06-24 16:38:26.901719 +00:00,2018-09-24 03:38:26.901719 +00:00,"5515 Michael Lane North Christophershire, MI 87022",148
698,2018-02-21 21:45:23.258851 +00:00,2018-05-03 12:45:23.258851 +00:00,"5486 Julia Coves Lake Genestad, LA 49088",148
699,2014-07-11 20:11:05.820535 +00:00,2014-09-25 01:11:05.820535 +00:00,"4010 Briggs Freeway Apt. 582 North Jessica, AS 67816",148
700,2025-08-12 15:58:14.103668 +00:00,2025-09-23 12:58:14.103668 +00:00,"30743 Castillo Extension Lake Stephanieville, NM 11448",149
701,2025-08-04 22:01:10.188438 +00:00,,"8087 David Forks Leslieland, NJ 21824",149
702,2025-07-30 23:15:35.510305 +00:00,,"1088 Hill Valleys Suite 633 West Michael, HI 05264",150
703,2010-03-04 01:43:49.915531 +00:00,2010-04-30 08:43:49.915531 +00:00,"999 Jeremy Motorway Stephanieville, GU 76228",150
704,2010-12-16 02:57:31.228806 +00:00,2011-01-18 10:57:31.228806 +00:00,"61952 Donna Stravenue Port Courtney, RI 83638",150
705,2025-07-15 20:53:49.438560 +00:00,2025-07-17 02:53:49.438560 +00:00,"865 Emily Tunnel Apt. 193 Coreystad, KS 62020",150
706,2018-05-31 14:28:06.538303 +00:00,2018-09-07 13:28:06.538303 +00:00,Unit 1648 Box 9416 DPO AA 78199,151
707,2014-04-23 00:18:50.787637 +00:00,2014-06-24 12:18:50.787637 +00:00,"85504 Herrera Views New Kiaraborough, RI 38209",151
708,2011-11-07 13:27:12.232284 +00:00,2011-12-31 17:27:12.232284 +00:00,"63543 Rebecca Vista Ralphstad, VT 76735",152
709,2011-10-17 18:46:18.410171 +00:00,2011-12-14 21:46:18.410171 +00:00,"59338 Jacob Forest Port Laurachester, IA 60010",152
710,2016-07-04 00:06:02.702827 +00:00,2016-10-08 21:06:02.702827 +00:00,"6686 Melissa Track Suite 570 South Jennifer, WY 49615",153
711,2015-09-13 07:28:26.088323 +00:00,2015-11-06 21:28:26.088323 +00:00,"4426 Victoria Estate Coreyside, AL 06967",153
712,2024-06-02 18:10:39.669428 +00:00,2024-06-07 13:10:39.669428 +00:00,USS Rivas FPO AP 74899,153
713,2013-10-18 16:46:47.709790 +00:00,2013-12-17 11:46:47.709790 +00:00,"4219 Mack Shores Apt. 073 East Kelseystad, NE 43948",154
714,2015-04-18 06:54:40.592780 +00:00,2015-06-13 12:54:40.592780 +00:00,"9884 Scott Street Lake Timothy, MA 93051",154
715,2016-03-30 14:18:59.096808 +00:00,2016-06-16 22:18:59.096808 +00:00,"01323 Holden Divide Amyland, IA 74409",154
716,2014-06-16 02:03:07.176805 +00:00,2014-07-05 21:03:07.176805 +00:00,"601 Arias Stream Timothyton, TN 12778",154
717,2012-10-11 14:47:23.477730 +00:00,2012-12-09 18:47:23.477730 +00:00,"14434 Debra Station Suite 790 West Coltonfort, CO 23196",154
718,2025-08-15 12:53:36.226078 +00:00,2025-09-28 21:53:36.226078 +00:00,"0529 John Viaduct Apt. 110 Lake Thomaschester, KS 79917",154
719,2025-08-11 04:50:10.072841 +00:00,2025-08-18 16:50:10.072841 +00:00,"63288 Thomas Heights Danielleport, MP 06340",154
720,2025-03-19 10:10:53.630768 +00:00,2025-05-22 09:10:53.630768 +00:00,"29659 Brian Manor Apt. 157 New Stephenhaven, PW 68544",154
721,2025-09-09 10:23:33.245939 +00:00,2025-09-11 17:23:33.245939 +00:00,Unit 8777 Box 9030 DPO AE 68407,155
722,2024-12-04 22:52:14.760125 +00:00,2024-12-16 19:52:14.760125 +00:00,"76641 Cruz Common Suite 479 Hortonhaven, AS 43964",155
723,2017-10-06 02:21:41.946019 +00:00,2017-11-05 07:21:41.946019 +00:00,"640 Jenna Street Suite 424 Joshuaborough, TX 36379",156
724,2022-11-16 16:44:00.266569 +00:00,2022-11-21 16:44:00.266569 +00:00,"53993 Angela Port New Debra, NJ 29948",157
725,2022-08-18 01:36:43.146584 +00:00,2022-10-17 11:36:43.146584 +00:00,"5478 Dalton Ferry North Rose, MP 48471",157
726,2023-10-30 22:43:49.608662 +00:00,2024-01-09 03:43:49.608662 +00:00,"681 Rush Ramp North Geoffrey, NY 23878",158
727,2012-04-27 13:03:54.187135 +00:00,2012-05-24 00:03:54.187135 +00:00,"7297 Martinez Mountain New Sarachester, MH 29576",158
728,2010-10-27 14:42:07.990663 +00:00,2010-10-29 11:42:07.990663 +00:00,"037 John Stravenue Suite 974 Angelatown, GA 58849",158
729,2022-08-27 21:25:11.552522 +00:00,2022-09-17 22:25:11.552522 +00:00,"22276 Matthew Branch Port Shelbyberg, OR 65733",159
730,2022-07-05 18:09:28.923621 +00:00,2022-07-17 00:09:28.923621 +00:00,"206 Young Lodge Apt. 759 Roseville, IA 58595",159
731,2018-07-02 14:31:20.642293 +00:00,2018-09-02 11:31:20.642293 +00:00,Unit 2651 Box 9892 DPO AE 66798,159
732,2025-08-31 00:29:11.228505 +00:00,2025-09-04 19:29:11.228505 +00:00,"4625 Martin Knolls Sarahtown, TX 13927",159
733,2016-01-28 02:56:51.703789 +00:00,2016-02-29 04:56:51.703789 +00:00,USNS Keller FPO AA 96994,159
734,2025-07-29 02:43:11.535815 +00:00,2025-08-01 05:43:11.535815 +00:00,"PSC 6731, Box 6827 APO AP 54389",159
735,2017-12-18 20:02:33.806681 +00:00,2018-01-28 16:02:33.806681 +00:00,"2513 Harrison Expressway Apt. 772 Gomezburgh, SD 61347",159
736,2011-06-18 18:21:17.873151 +00:00,2011-07-04 04:21:17.873151 +00:00,"PSC 4692, Box 5174 APO AP 64257",159
737,2016-10-26 18:45:04.129755 +00:00,2016-11-16 09:45:04.129755 +00:00,Unit 3133 Box 9089 DPO AE 23768,160
738,2023-06-04 23:58:57.043131 +00:00,2023-08-19 19:58:57.043131 +00:00,"4900 Smith Track Wheelerberg, CO 91740",160
739,2025-09-29 00:07:42.237389 +00:00,,"5838 Booth Inlet Apt. 082 New Darrell, DE 01983",160
740,2024-01-08 14:53:24.493570 +00:00,2024-01-25 06:53:24.493570 +00:00,"36568 Bradshaw Port Suite 830 Gonzalezhaven, MO 31741",161
741,2025-08-26 20:41:13.243747 +00:00,,"7522 Riley Ridges Suite 404 Ashleyside, MN 74858",162
742,2020-07-18 11:22:19.110354 +00:00,2020-09-10 10:22:19.110354 +00:00,"073 Christopher Haven Apt. 384 Phillipschester, MN 52795",162
743,2025-09-20 01:34:19.507215 +00:00,,"PSC 8329, Box 4827 APO AA 11039",162
744,2023-09-28 10:14:04.865578 +00:00,2023-10-13 20:14:04.865578 +00:00,"985 Freeman Fields Suite 311 New Jennifer, MH 72225",162
745,2025-09-09 05:18:05.028574 +00:00,,"37976 Edwards Fields Suite 442 Dawntown, WA 28285",162
746,2013-07-23 12:52:13.150869 +00:00,2013-09-28 19:52:13.150869 +00:00,"PSC 1959, Box 7077 APO AA 87103",162
747,2010-09-14 10:32:32.598203 +00:00,2010-12-03 15:32:32.598203 +00:00,"1114 Sarah Harbors Suite 723 New Jorge, FM 23687",163
748,2020-06-30 15:23:02.668149 +00:00,2020-07-02 12:23:02.668149 +00:00,"80684 Patel Crescent Apt. 106 Port Kevinstad, NC 47153",163
749,2025-09-11 00:51:17.811424 +00:00,2025-09-17 16:51:17.811424 +00:00,"713 Arnold Creek Apt. 236 Torresbury, MI 39185",163
750,2014-01-22 09:02:08.760542 +00:00,2014-01-30 17:02:08.760542 +00:00,"44851 Mark Haven Suite 908 Hessshire, MI 36237",164
751,2023-03-25 05:46:09.905083 +00:00,2023-05-04 05:46:09.905083 +00:00,"58781 Adriana Burgs Apt. 339 West Haleyton, AK 56487",164
752,2025-09-08 15:13:32.996978 +00:00,,"5794 Mccullough Trail Apt. 919 Christianside, WA 74050",164
753,2020-12-17 19:08:10.687746 +00:00,2021-01-03 16:08:10.687746 +00:00,"4272 Turner Mountains Lake Joshuamouth, MD 05877",164
754,2017-09-26 20:44:46.673436 +00:00,2017-10-02 21:44:46.673436 +00:00,"5696 Turner Estates Cassandratown, MI 31205",164
755,2017-11-10 10:28:25.864267 +00:00,2017-12-28 18:28:25.864267 +00:00,"865 Kevin Crescent Suite 058 Davidburgh, AZ 62179",164
756,2025-07-02 05:00:43.724673 +00:00,2025-07-16 04:00:43.724673 +00:00,"4653 Alexander Freeway Apt. 255 East David, MD 34233",164
757,2012-04-11 06:09:07.308501 +00:00,2012-07-11 17:09:07.308501 +00:00,"04379 Allison Square Brittanyport, RI 35586",164
758,2023-10-22 07:11:43.965368 +00:00,2023-12-31 22:11:43.965368 +00:00,"4335 Robert Spurs Stevenmouth, ME 83362",165
759,2020-08-27 07:22:29.237255 +00:00,2020-11-17 14:22:29.237255 +00:00,"31973 Frank River Suite 512 Emilyberg, AS 16131",165
760,2025-08-07 07:28:02.100919 +00:00,,"2657 Kirk Orchard Theresafort, MS 98724",165
761,2012-03-20 10:10:41.329774 +00:00,2012-04-09 00:10:41.329774 +00:00,"267 Miller Throughway South Calebberg, HI 44198",165
762,2025-07-03 02:07:55.877613 +00:00,2025-07-23 02:07:55.877613 +00:00,"59618 Olivia Point Suite 078 East Nicoleborough, IL 54577",165
763,2025-07-21 10:08:15.880951 +00:00,,"929 Scott Greens Apt. 535 Shawnview, MN 13354",165
764,2025-09-29 14:39:07.235680 +00:00,,"240 Underwood Greens Barreraburgh, UT 77659",166
765,2025-07-03 20:16:08.306508 +00:00,2025-08-17 05:16:08.306508 +00:00,"56757 Hoffman Plaza Apt. 504 Brennanshire, AR 18322",166
766,2015-07-18 05:57:47.073061 +00:00,2015-08-10 03:57:47.073061 +00:00,"282 Sandy Isle Phillipland, WY 57980",166
767,2025-08-15 00:21:24.740674 +00:00,,"17234 Andrea Neck Juliestad, WV 96903",167
768,2025-07-29 00:54:11.667502 +00:00,2025-09-30 13:54:11.667502 +00:00,"729 Barber Road Steinchester, VT 17880",167
769,2025-08-13 19:40:30.858558 +00:00,2025-09-11 03:40:30.858558 +00:00,"7175 Robinson Corners Suite 064 Jefferyburgh, FL 11980",167
770,2012-10-03 14:51:05.751997 +00:00,2013-01-07 15:51:05.751997 +00:00,"33372 Albert Square Suite 186 North Mitchell, NM 57460",167
771,2019-08-01 09:44:27.024181 +00:00,2019-08-08 06:44:27.024181 +00:00,"22563 Hernandez Drive New Tammy, CT 50793",168
772,2025-05-22 23:09:37.936617 +00:00,2025-07-03 10:09:37.936617 +00:00,"226 Sharon Mews Michaelside, NH 12364",168
773,2013-11-09 16:19:13.471442 +00:00,2014-01-16 04:19:13.471442 +00:00,"51672 Burch Row Apt. 974 New Tammyton, PW 68350",168
774,2020-12-31 09:43:03.620381 +00:00,2021-02-08 13:43:03.620381 +00:00,"670 Morris Burgs Cordovaside, MA 65241",168
775,2022-09-11 10:19:48.483876 +00:00,2022-10-04 13:19:48.483876 +00:00,"0986 Jessica Corner Smithmouth, GU 68804",168
776,2021-11-23 07:30:35.956698 +00:00,2022-02-06 12:30:35.956698 +00:00,"313 Perez Place Apt. 817 Timothyhaven, ME 20188",168
777,2025-09-30 01:59:31.056154 +00:00,,"8553 Melissa Cove Nicholasland, FL 77612",168
778,2010-10-30 21:19:18.046733 +00:00,2010-12-11 13:19:18.046733 +00:00,Unit 5939 Box 0027 DPO AP 58616,168
779,2013-05-31 09:18:24.720567 +00:00,2013-07-15 04:18:24.720567 +00:00,"79297 Paul Springs Suite 247 Heathertown, MO 87336",169
780,2025-09-26 13:24:48.886997 +00:00,,"609 Nichole Pine Suite 462 Breannastad, NY 76075",169
781,2018-02-22 19:16:43.959511 +00:00,2018-03-20 05:16:43.959511 +00:00,"6188 David Hill Lake Caitlin, WI 65605",169
782,2022-06-14 16:23:45.288149 +00:00,2022-08-03 01:23:45.288149 +00:00,"7424 Mary Field Apt. 306 Port Christinaborough, PW 57211",170
783,2025-08-10 03:07:17.515061 +00:00,2025-09-15 19:07:17.515061 +00:00,Unit 5469 Box 1787 DPO AE 85332,170
784,2025-10-03 21:14:33.465299 +00:00,,"21750 Ronald Street Suite 076 Port Gina, NM 79312",170
785,2021-12-20 06:03:52.575786 +00:00,2022-03-18 04:03:52.575786 +00:00,USCGC Young FPO AA 37876,170
786,2024-11-29 14:40:31.183721 +00:00,2024-12-10 10:40:31.183721 +00:00,"08253 Newton River West Ashley, MH 37022",170
787,2025-09-24 03:39:09.176389 +00:00,,"63592 Hall Terrace Johnsonview, CT 16861",170
788,2025-08-26 22:22:34.292609 +00:00,,"5793 Emily Squares Sheltonport, KS 61366",170
789,2012-01-09 00:40:04.014854 +00:00,2012-03-16 07:40:04.014854 +00:00,Unit 8670 Box 2703 DPO AP 69764,170
790,2024-05-28 02:32:52.609024 +00:00,2024-08-07 03:32:52.609024 +00:00,"593 Luke Forks Lake David, GA 66282",171
791,2017-12-19 12:54:09.718651 +00:00,2018-02-03 03:54:09.718651 +00:00,"36562 Brown Gardens Shepardtown, AL 49540",171
792,2016-10-04 14:16:53.706143 +00:00,2017-01-06 13:16:53.706143 +00:00,"422 Gibson Loaf Apt. 225 East Patriciatown, NY 41297",171
793,2012-11-02 20:43:00.963039 +00:00,2013-02-07 17:43:00.963039 +00:00,"42854 Alejandra Rapids Malloryside, FL 60847",171
794,2023-10-26 18:59:13.331768 +00:00,2023-11-08 06:59:13.331768 +00:00,"91821 Scott Light North Joseph, SD 53336",171
795,2023-10-16 23:56:46.837248 +00:00,2023-12-24 22:56:46.837248 +00:00,"742 Cardenas Walks Suite 203 Lake Seanport, MA 81084",171
796,2011-02-09 13:44:56.290497 +00:00,2011-03-20 12:44:56.290497 +00:00,"238 Johnson Underpass Rodriguezchester, MA 08247",172
797,2017-02-17 07:43:36.234144 +00:00,2017-03-16 04:43:36.234144 +00:00,"6587 Mitchell Unions East Lisa, DE 67266",173
798,2018-07-21 20:12:18.545486 +00:00,2018-08-24 14:12:18.545486 +00:00,"047 Cindy Fields Apt. 804 Port Donaldstad, AS 41702",173
799,2016-06-02 14:05:30.816329 +00:00,2016-07-13 05:05:30.816329 +00:00,"PSC 3399, Box 1219 APO AE 12586",173
800,2013-07-14 09:56:10.568305 +00:00,2013-07-27 07:56:10.568305 +00:00,"7183 Hopkins Locks Lake Kevinhaven, MD 74251",173
801,2025-09-29 10:25:17.093155 +00:00,,"923 Kevin Stravenue Port Andrew, NJ 26513",173
802,2025-02-21 18:24:20.040858 +00:00,2025-05-31 22:24:20.040858 +00:00,"11540 Glenn Island New Erika, NE 57198",173
803,2025-07-03 20:12:19.772338 +00:00,2025-09-29 23:12:19.772338 +00:00,"64455 Justin Mountains Apt. 508 North Alexanderside, SD 56978",174
804,2012-11-19 03:17:59.405915 +00:00,2013-02-24 15:17:59.405915 +00:00,"011 Oneill Stream Apt. 489 Jonesville, LA 37076",174
805,2024-03-13 18:40:05.273139 +00:00,2024-05-03 14:40:05.273139 +00:00,USS Brady FPO AA 87048,174
806,2014-02-01 00:50:04.195125 +00:00,2014-03-17 04:50:04.195125 +00:00,"5548 Schroeder Roads Suite 118 New Julian, ME 76365",174
807,2025-09-08 20:52:54.226651 +00:00,,"972 Mitchell Summit North Anna, MT 58363",174
808,2010-10-14 03:36:02.408617 +00:00,2011-01-19 10:36:02.408617 +00:00,"75276 Howe Crossroad Suite 282 Dixonstad, AS 39809",174
809,2025-06-05 01:13:09.877311 +00:00,2025-06-12 13:13:09.877311 +00:00,USNS Valenzuela FPO AE 18353,175
810,2021-08-23 14:37:59.267322 +00:00,2021-11-24 12:37:59.267322 +00:00,"788 David Green Apt. 030 Zacharytown, WA 85197",175
811,2022-11-18 07:36:17.482934 +00:00,2023-01-05 15:36:17.482934 +00:00,"7455 Garcia Mountains East Stephenberg, PR 21850",175
812,2018-10-25 15:57:05.258507 +00:00,2018-12-04 05:57:05.258507 +00:00,"94285 Raymond Cliffs Suite 938 Lake Kennethfurt, MH 71557",175
813,2016-02-17 14:01:14.795396 +00:00,2016-03-18 19:01:14.795396 +00:00,"558 Trevor Villages Suite 178 North Rachel, WY 07869",175
814,2023-12-31 11:25:46.537016 +00:00,2024-03-12 03:25:46.537016 +00:00,"567 Jenny Keys Apt. 242 Rogersmouth, TX 11104",175
815,2025-07-07 18:16:38.068832 +00:00,2025-09-11 14:16:38.068832 +00:00,"4072 Sullivan Corners Suite 103 Bradleyside, NJ 28559",176
816,2025-01-13 01:52:27.993573 +00:00,2025-02-04 18:52:27.993573 +00:00,"10130 Shawn Islands Cruzchester, NJ 04897",176
817,2022-12-24 17:07:53.225554 +00:00,2023-02-15 20:07:53.225554 +00:00,"08539 Miller Union Suite 247 Lorihaven, TN 07495",176
818,2018-12-11 07:45:00.512154 +00:00,2019-01-26 08:45:00.512154 +00:00,"PSC 7824, Box 1571 APO AP 49234",176
819,2012-11-22 18:00:21.457675 +00:00,2013-03-02 18:00:21.457675 +00:00,"5915 Carroll Circles Apt. 657 West Stevenside, CT 73944",176
820,2012-07-05 22:36:15.691984 +00:00,2012-09-16 20:36:15.691984 +00:00,"432 Rivera Fork North Sandra, WV 95571",176
821,2011-07-08 03:10:39.036605 +00:00,2011-08-16 22:10:39.036605 +00:00,"964 Barnes Path Ashleyside, MP 47804",176
822,2016-12-21 11:08:32.003030 +00:00,2017-02-23 15:08:32.003030 +00:00,"8009 Richard Parks Apt. 757 Conniefurt, ME 87502",177
823,2015-07-07 13:43:22.919765 +00:00,2015-08-20 12:43:22.919765 +00:00,"1337 Bethany Prairie Suite 569 Port Jamiemouth, OR 27218",177
824,2016-12-24 08:25:35.070759 +00:00,2017-02-23 09:25:35.070759 +00:00,"9532 Caitlin Isle Apt. 684 North Michele, FL 05039",177
825,2025-08-27 10:33:12.581960 +00:00,,"34679 Edwards Islands Apt. 559 Jasonside, GU 93477",177
826,2019-03-16 04:02:08.302434 +00:00,2019-06-20 00:02:08.302434 +00:00,"65606 Cook Wells Apt. 354 North Meghan, LA 04949",177
827,2019-04-08 15:33:12.945342 +00:00,2019-04-11 03:33:12.945342 +00:00,"539 Carmen Manors Apt. 265 Baileyborough, MI 25341",177
828,2018-03-12 00:04:08.215487 +00:00,2018-05-01 15:04:08.215487 +00:00,"PSC 5183, Box 2410 APO AP 11261",178
829,2025-07-20 14:12:02.338658 +00:00,2025-09-19 20:12:02.338658 +00:00,"4342 Heather Ridges East Ann, NM 41088",178
830,2011-10-27 02:12:48.975266 +00:00,2011-11-13 09:12:48.975266 +00:00,"89315 Katie Field Suite 832 West Phillip, NC 77517",178
831,2018-11-20 07:08:46.335689 +00:00,2019-02-04 13:08:46.335689 +00:00,"6072 Brady Dam New Tanya, MO 72847",179
832,2017-06-27 12:08:39.752747 +00:00,2017-08-24 20:08:39.752747 +00:00,"0048 Brian Lights East Billstad, MP 75427",179
833,2012-03-17 06:20:09.814673 +00:00,2012-06-03 14:20:09.814673 +00:00,"510 Gonzalez Islands Kimberlybury, TN 80724",179
834,2015-04-05 07:45:37.833054 +00:00,2015-06-18 11:45:37.833054 +00:00,"947 Johnson Corner South Martinborough, NE 33529",179
835,2010-05-23 23:38:35.420070 +00:00,2010-06-11 22:38:35.420070 +00:00,"870 Griffin Lake Apt. 038 Antoniostad, MS 75248",179
836,2016-08-08 16:35:03.357134 +00:00,2016-10-03 07:35:03.357134 +00:00,"396 Donald Glen Apt. 462 South Austin, FL 51773",179
837,2020-12-28 06:24:45.740557 +00:00,2021-03-03 01:24:45.740557 +00:00,"922 Harmon Roads Suite 326 East Joanneshire, MN 28898",179
838,2020-12-20 01:59:06.412865 +00:00,2021-02-08 11:59:06.412865 +00:00,"0445 Bryan Road Apt. 778 Port Laurabury, VT 45347",180
839,2021-01-11 02:19:07.928533 +00:00,2021-02-09 06:19:07.928533 +00:00,"243 Peter Key Suite 341 Port Thomaston, PA 13575",181
840,2010-08-05 11:33:31.918647 +00:00,2010-10-08 15:33:31.918647 +00:00,"PSC 5998, Box 1213 APO AA 78033",181
841,2015-05-23 23:04:36.599599 +00:00,2015-08-25 12:04:36.599599 +00:00,"94708 Christina Turnpike Suite 439 Beckerville, NE 95363",181
842,2025-07-30 02:24:11.260090 +00:00,,"253 Justin Land Apt. 135 Howardfurt, OK 01734",181
843,2013-09-17 15:30:15.829181 +00:00,2013-12-04 03:30:15.829181 +00:00,"3067 Brent Inlet Lake Keithchester, SD 00753",181
844,2025-08-26 14:42:51.264871 +00:00,2025-10-04 18:42:51.264871 +00:00,"546 Christopher Pines Jessicahaven, CT 66122",181
845,2012-01-07 12:46:37.099747 +00:00,2012-03-18 18:46:37.099747 +00:00,"3380 Guerrero Knolls Suite 552 Lake Kristen, AS 59474",181
846,2017-07-20 00:23:20.290433 +00:00,2017-10-20 07:23:20.290433 +00:00,"44923 Robert Haven Apt. 383 Tracitown, MA 18895",182
847,2018-02-23 19:08:40.170906 +00:00,2018-03-23 12:08:40.170906 +00:00,"3000 Hull Field East Charlestown, MO 66881",182
848,2022-08-09 19:37:28.493829 +00:00,2022-08-19 09:37:28.493829 +00:00,"4417 Reynolds Hollow West Stacy, SC 46156",182
849,2021-12-26 23:06:49.092127 +00:00,2022-01-01 09:06:49.092127 +00:00,"660 Christopher Forge Torresmouth, MI 23237",182
850,2023-07-12 08:40:46.127168 +00:00,2023-08-26 23:40:46.127168 +00:00,"6819 Scott Parkway South Anne, WY 10211",182
851,2012-05-30 23:11:36.087652 +00:00,2012-06-26 10:11:36.087652 +00:00,"1048 Taylor Spur Suite 684 Tylerton, GU 36847",182
852,2025-07-01 08:26:17.969841 +00:00,2025-07-10 22:26:17.969841 +00:00,"37639 Baker Land Port Amandaton, MI 98436",183
853,2018-10-18 00:26:49.892438 +00:00,2019-01-05 14:26:49.892438 +00:00,"985 Turner Glens Thompsonfurt, PR 57520",183
854,2011-03-14 14:33:39.412102 +00:00,2011-03-23 13:33:39.412102 +00:00,Unit 6882 Box 3509 DPO AA 63374,183
855,2020-07-28 13:58:47.241760 +00:00,2020-09-12 09:58:47.241760 +00:00,"5584 Gibbs Court Suite 772 Jennifertown, PA 70300",183
856,2018-07-05 14:16:27.743320 +00:00,2018-08-22 12:16:27.743320 +00:00,"7060 Patricia Passage New Walter, TN 99149",183
857,2025-07-13 21:35:05.380040 +00:00,2025-09-25 05:35:05.380040 +00:00,"1728 Thomas Skyway Apt. 865 North Caleb, MT 83795",184
858,2025-08-30 14:47:49.206980 +00:00,,"9221 Collins Locks Apt. 497 Reedside, NH 36337",184
859,2013-05-28 08:19:53.572680 +00:00,2013-07-06 02:19:53.572680 +00:00,"6772 Kelly Plains Apt. 395 Mitchellbury, TX 78605",184
860,2014-04-01 12:56:09.465586 +00:00,2014-04-30 11:56:09.465586 +00:00,"19810 Frederick Green Suite 581 Martinberg, MS 24011",184
861,2019-07-10 10:01:04.719874 +00:00,2019-10-14 01:01:04.719874 +00:00,"628 Sheila Pike Apt. 973 Grosston, AR 18881",184
862,2016-08-26 11:17:31.050924 +00:00,2016-09-02 18:17:31.050924 +00:00,"430 John Lake North Marieburgh, MO 49969",184
863,2014-04-27 01:38:18.143050 +00:00,2014-06-04 14:38:18.143050 +00:00,"537 Cantu Forges Apt. 386 Lake Nicole, DE 70560",184
864,2025-09-26 11:12:53.556777 +00:00,,"2134 Richard Circles Smallview, MP 94613",184
865,2025-09-16 01:40:07.883912 +00:00,2025-09-18 13:40:07.883912 +00:00,"789 Roach Terrace Suite 751 Beckermouth, MP 89558",185
866,2017-01-12 15:38:04.147014 +00:00,2017-02-16 10:38:04.147014 +00:00,"2998 Carpenter Parkway Apt. 376 Thomasburgh, MD 09693",185
867,2025-10-04 03:39:16.725108 +00:00,,"657 Williams Center Suite 006 Lake Jessicaview, WY 16481",185
868,2011-07-16 06:28:04.555300 +00:00,2011-10-14 11:28:04.555300 +00:00,"467 Weiss Streets West Mark, IA 96692",185
869,2024-05-27 21:04:33.196730 +00:00,2024-07-21 16:04:33.196730 +00:00,"82058 Morales Village West Sharontown, ID 07676",186
870,2021-05-04 02:45:17.026593 +00:00,2021-07-11 20:45:17.026593 +00:00,"423 Samuel Trafficway New Joshuaton, FL 77733",186
871,2025-09-21 04:19:09.288320 +00:00,,USNV Ramirez FPO AE 37642,186
872,2015-07-30 01:32:08.776283 +00:00,2015-09-01 04:32:08.776283 +00:00,"478 Dawn Spur Michaelberg, NJ 86948",186
873,2018-04-05 04:46:52.431146 +00:00,2018-05-01 10:46:52.431146 +00:00,"036 Brandon Brooks Suite 759 Josechester, NJ 11676",186
874,2013-11-10 02:53:40.684829 +00:00,2013-12-01 18:53:40.684829 +00:00,USNS Rodriguez FPO AA 18130,186
875,2025-09-12 06:22:38.908280 +00:00,,"464 Smith Junction Suite 587 Powersstad, MH 67621",187
876,2025-07-06 09:53:29.199148 +00:00,2025-07-19 12:53:29.199148 +00:00,"491 Howell Harbors Amandaburgh, MT 11519",187
877,2014-11-13 04:11:27.759355 +00:00,2014-12-18 04:11:27.759355 +00:00,"PSC 8908, Box 1928 APO AE 45610",187
878,2011-01-07 06:32:36.653318 +00:00,2011-03-23 16:32:36.653318 +00:00,"750 Romero Shore Herreraview, VT 66152",187
879,2011-08-03 20:22:04.631801 +00:00,2011-08-10 02:22:04.631801 +00:00,"115 Jack Unions Jenniferhaven, IL 12910",188
880,2011-02-21 12:38:00.667372 +00:00,2011-03-23 22:38:00.667372 +00:00,"027 Christine Radial Lake Sabrina, TX 46986",188
881,2016-06-05 21:18:08.773089 +00:00,2016-07-15 06:18:08.773089 +00:00,"6170 Austin Fields Suite 138 South Jeffreymouth, MT 67516",188
882,2025-09-26 02:05:46.518336 +00:00,2025-10-04 20:05:46.518336 +00:00,"8933 Debra Run Johnside, MS 98203",189
883,2017-07-21 21:53:45.341285 +00:00,2017-10-15 02:53:45.341285 +00:00,"9108 Davis Glens Suite 030 Denisestad, UT 94680",189
884,2025-07-12 01:20:45.608313 +00:00,2025-07-15 14:20:45.608313 +00:00,"PSC 2371, Box 7571 APO AA 83837",189
885,2025-09-02 04:53:37.286764 +00:00,2025-09-23 10:53:37.286764 +00:00,"1260 Strickland Brook Suite 977 Brianborough, DE 44568",189
886,2018-03-27 09:53:37.907417 +00:00,2018-06-12 06:53:37.907417 +00:00,"5962 Edward Bypass Colemanburgh, DC 90574",189
887,2025-07-20 07:08:19.591508 +00:00,2025-10-05 04:08:19.591508 +00:00,"5961 Allen Trail Apt. 984 New William, FM 26181",189
888,2013-12-13 07:38:20.372453 +00:00,2013-12-29 23:38:20.372453 +00:00,"15856 Donna Mill Lake Aaron, MO 50845",189
889,2020-08-24 16:19:05.122709 +00:00,2020-09-15 18:19:05.122709 +00:00,"86473 Annette Valley Apt. 169 North Charles, AL 09368",189
890,2011-02-26 10:12:15.844278 +00:00,2011-03-01 13:12:15.844278 +00:00,"8079 Sara Flats New Teresa, GU 97470",190
891,2022-02-23 02:29:03.795974 +00:00,2022-05-23 16:29:03.795974 +00:00,"247 Lynch Trail Apt. 663 South Sarahton, KY 62138",191
892,2011-12-15 00:09:57.962779 +00:00,2012-03-15 16:09:57.962779 +00:00,"56525 Gonzales Fork Tonystad, NV 87701",192
893,2018-02-03 23:25:02.453453 +00:00,2018-03-10 08:25:02.453453 +00:00,USCGC Schroeder FPO AA 64755,193
894,2023-09-26 21:04:40.562481 +00:00,2023-12-04 10:04:40.562481 +00:00,"073 Davis Mountain Apt. 356 South Dana, OR 85543",193
895,2025-09-24 02:03:40.888554 +00:00,,Unit 1003 Box 1007 DPO AA 37365,193
896,2025-08-09 20:27:51.533700 +00:00,2025-09-03 20:27:51.533700 +00:00,"537 Nicholas Points Sherriport, OR 77152",193
897,2025-08-25 22:53:27.430668 +00:00,2025-09-20 03:53:27.430668 +00:00,"802 Debra Causeway Apt. 119 Richardsfort, PR 02028",193
898,2016-05-03 12:26:08.800915 +00:00,2016-05-26 10:26:08.800915 +00:00,"70297 Kaufman Canyon Apt. 432 Port Natasha, CA 30597",193
899,2025-07-14 02:55:19.705741 +00:00,,USNV Joseph FPO AP 14941,193
900,2019-04-15 03:42:20.879311 +00:00,2019-04-19 17:42:20.879311 +00:00,"1686 Chang Flats Michelletown, GA 98476",193
901,2025-07-21 15:46:03.611774 +00:00,2025-09-25 16:46:03.611774 +00:00,"53221 Kelly Lake Amyborough, CA 62608",194
902,2025-10-03 19:37:04.858837 +00:00,,"276 Sullivan Tunnel Suite 884 Port Kyleland, MI 82380",194
903,2015-02-18 05:29:42.238085 +00:00,2015-04-22 13:29:42.238085 +00:00,"4733 Maureen Greens Apt. 492 New Cynthia, CO 18436",194
904,2023-11-27 22:04:49.428140 +00:00,2024-02-04 21:04:49.428140 +00:00,Unit 0196 Box 5011 DPO AA 91544,195
905,2010-02-24 00:22:39.614780 +00:00,2010-05-17 12:22:39.614780 +00:00,"308 Hart Freeway Apt. 598 North Erica, ND 00804",195
906,2012-12-25 22:56:04.107240 +00:00,2013-01-13 21:56:04.107240 +00:00,"04220 Kemp Mountains North Kim, FL 36602",195
907,2025-08-26 13:23:36.090917 +00:00,,"300 Amber Haven Suite 018 West Anna, IN 64658",195
908,2021-09-13 16:26:19.976318 +00:00,2021-10-13 01:26:19.976318 +00:00,"285 Huynh Shore Port Richardfurt, DE 03061",195
909,2010-12-04 03:59:32.456105 +00:00,2011-01-01 21:59:32.456105 +00:00,"100 Charles Greens Port Margaret, MI 71270",196
910,2018-03-22 14:51:19.728034 +00:00,2018-05-28 06:51:19.728034 +00:00,"9605 Jones Parkways Apt. 321 Fosterhaven, NE 66278",196
911,2023-01-08 00:38:12.375183 +00:00,2023-04-03 10:38:12.375183 +00:00,"6097 Evans Centers Prestonmouth, PR 38258",196
912,2025-06-29 04:25:28.240868 +00:00,2025-08-30 01:25:28.240868 +00:00,"00265 Linda Rapid Suite 862 Romanhaven, WA 55781",196
913,2025-09-26 16:07:35.603926 +00:00,,"4797 Andrew Lane New Peter, MI 37557",197
914,2018-04-06 17:02:57.749699 +00:00,2018-05-23 14:02:57.749699 +00:00,"37739 Paul Lock New Briana, FL 46771",198
915,2010-01-14 18:13:06.057122 +00:00,2010-03-08 01:13:06.057122 +00:00,"59699 Parks Drive New Donna, DC 68570",198
916,2025-09-10 11:44:43.787695 +00:00,,"552 Robert Skyway Aaronbury, MN 78298",198
917,2025-02-13 04:34:50.416918 +00:00,2025-03-18 12:34:50.416918 +00:00,"60307 George Cliff Suite 383 Port Christopherview, WY 31693",198
918,2013-07-11 08:07:56.089921 +00:00,2013-09-26 15:07:56.089921 +00:00,"6037 Li Skyway Suite 970 Barryhaven, VT 71630",198
919,2011-04-05 03:52:35.807356 +00:00,2011-06-03 12:52:35.807356 +00:00,"PSC 2544, Box 7028 APO AA 80461",198
920,2025-09-11 06:59:39.352112 +00:00,2025-10-05 10:59:39.352112 +00:00,"6572 Lori Turnpike Cobbburgh, AL 39746",198
921,2025-08-10 11:48:04.824710 +00:00,2025-09-14 21:48:04.824710 +00:00,"2687 Jordan Ridges Suite 769 Riceborough, NJ 61126",199
922,2025-08-17 03:54:09.560372 +00:00,2025-08-24 20:54:09.560372 +00:00,"4629 Gutierrez Views Suite 565 Lake Chelseaborough, NM 63034",199
923,2024-05-31 19:12:53.077612 +00:00,2024-06-06 05:12:53.077612 +00:00,"476 Kevin Vista Weaverburgh, VA 32557",199
924,2023-01-14 10:51:32.066967 +00:00,2023-01-29 05:51:32.066967 +00:00,Unit 6885 Box 8053 DPO AE 07057,199
925,2025-08-19 21:42:17.771298 +00:00,,"1041 Andrea Burg Apt. 507 Lake Tiffany, MO 33648",199
926,2010-01-20 20:56:38.291017 +00:00,2010-02-20 21:56:38.291017 +00:00,"488 Charles Key Suite 423 North Jamesborough, ID 56446",200
927,2025-10-03 08:59:14.203815 +00:00,,"493 Randy Summit New April, PW 30931",200
928,2013-05-16 04:58:03.310618 +00:00,2013-08-07 17:58:03.310618 +00:00,"854 Brenda Coves Apt. 205 Smithton, VI 85273",201
929,2025-07-05 13:34:55.934055 +00:00,2025-07-20 08:34:55.934055 +00:00,"4865 Casey Mountain Suite 431 Sandovalborough, MP 33957",201
930,2025-08-03 04:22:00.195337 +00:00,,"201 Davenport Gardens Apt. 175 Port Yvonne, NH 82915",201
931,2012-12-22 18:50:11.553555 +00:00,2013-03-28 14:50:11.553555 +00:00,"638 David Pines New Carrie, MT 21107",201
932,2025-07-18 14:15:17.958868 +00:00,2025-08-03 20:15:17.958868 +00:00,"0368 David Mission East Bryan, AR 56178",201
933,2024-03-20 00:00:58.839458 +00:00,2024-05-31 02:00:58.839458 +00:00,"62204 Clark Trace Herreraport, FM 29640",201
934,2025-08-04 18:49:26.097466 +00:00,,USCGC Pierce FPO AA 51753,201
935,2019-05-19 18:07:25.627944 +00:00,2019-08-16 02:07:25.627944 +00:00,"569 David Estate Livingstonmouth, CT 43558",202
936,2018-07-02 12:18:14.112795 +00:00,2018-10-02 14:18:14.112795 +00:00,"75633 Jordan Camp Katherinefurt, PR 13710",202
937,2021-03-04 19:39:51.233926 +00:00,2021-03-17 12:39:51.233926 +00:00,"412 Lyons Point Port Elizabethbury, AZ 65642",202
938,2012-11-16 11:08:26.367440 +00:00,2013-01-04 15:08:26.367440 +00:00,"46653 Haney Springs Frankville, FL 54266",202
939,2010-08-26 14:54:21.880180 +00:00,2010-11-20 00:54:21.880180 +00:00,"971 Paul Falls Bullockberg, MP 12889",202
940,2023-09-02 12:04:29.006607 +00:00,2023-10-24 04:04:29.006607 +00:00,"7156 Perez Forges Apt. 430 East Jonathanshire, CO 84183",203
941,2025-09-07 13:08:43.203362 +00:00,,"3243 Richmond Prairie Apt. 192 East Matthew, OK 01782",203
942,2025-08-09 16:08:08.754941 +00:00,,"58162 Samantha Shoal Suite 794 North Jesse, KY 86125",203
943,2022-08-11 07:54:51.629109 +00:00,2022-10-14 06:54:51.629109 +00:00,"782 Evans Mission Lake Heatherbury, FM 74179",203
944,2011-05-04 23:22:24.747517 +00:00,2011-08-05 06:22:24.747517 +00:00,"17395 Butler Hollow Suite 240 Sullivanfort, CT 06351",204
945,2010-01-22 01:44:53.330252 +00:00,2010-03-03 06:44:53.330252 +00:00,"231 Clements Land Apt. 551 Bonniemouth, ND 71458",204
946,2024-06-17 00:03:37.416491 +00:00,2024-06-28 16:03:37.416491 +00:00,"38602 Smith Mission Suite 079 Danielshire, VT 45558",204
947,2019-09-11 19:19:53.501486 +00:00,2019-09-29 17:19:53.501486 +00:00,"311 James Unions Apt. 572 West David, ND 09177",205
948,2013-07-20 04:23:17.184391 +00:00,2013-08-15 20:23:17.184391 +00:00,Unit 3415 Box 5905 DPO AP 84392,205
949,2015-02-07 18:29:59.328809 +00:00,2015-03-23 02:29:59.328809 +00:00,"419 Hoover Streets Suite 809 East Jonathanberg, WV 58023",205
950,2021-04-16 16:01:03.711667 +00:00,2021-07-23 04:01:03.711667 +00:00,"97115 Johnson Estate Suite 314 Hoganmouth, PW 56752",205
951,2016-01-28 14:14:18.166013 +00:00,2016-05-07 04:14:18.166013 +00:00,"654 Emily Port North Alvin, MT 14904",205
952,2016-01-05 19:44:24.519135 +00:00,2016-03-02 21:44:24.519135 +00:00,"539 Sarah Extension South Megan, MS 47714",206
953,2025-08-16 17:43:16.389896 +00:00,2025-08-22 13:43:16.389896 +00:00,"125 Campbell Extensions Apt. 098 East Todd, AR 06045",206
954,2025-09-25 03:18:37.761188 +00:00,,"7895 Robert Ridge Jacksonhaven, ND 65626",206
955,2015-03-01 22:22:39.192894 +00:00,2015-05-13 15:22:39.192894 +00:00,"2215 George Stravenue Apt. 192 Fletcherport, SD 13088",206
956,2025-07-12 12:18:35.120220 +00:00,,"953 Christopher Views Suite 463 Allisonside, OH 04566",207
957,2025-07-14 23:23:05.909533 +00:00,2025-07-18 07:23:05.909533 +00:00,"273 Kerr Vista Apt. 260 South Nicoleland, WI 07775",207
958,2024-10-18 11:10:50.040478 +00:00,2024-10-20 03:10:50.040478 +00:00,"6014 Woodward Spur Suite 865 North Laurastad, AK 41701",207
959,2025-07-24 11:02:06.519536 +00:00,2025-08-10 13:02:06.519536 +00:00,"683 Richardson Trail Apt. 023 South Stevenstad, MI 85098",207
960,2020-02-11 18:32:32.233642 +00:00,2020-03-18 19:32:32.233642 +00:00,"6162 Catherine Mount South John, OH 29353",207
961,2018-07-20 19:00:33.838781 +00:00,2018-07-21 10:00:33.838781 +00:00,"1297 Daniel Trail South Stephaniechester, VI 20253",207
962,2019-12-20 06:27:29.083078 +00:00,2020-02-02 20:27:29.083078 +00:00,"137 Le Stream Caitlinmouth, VT 19010",207
963,2023-05-20 06:03:25.941314 +00:00,2023-06-14 16:03:25.941314 +00:00,"72374 Jo Overpass Suite 507 West Dianestad, IL 24390",207
964,2025-10-02 18:42:23.819186 +00:00,,"36904 Bruce Inlet Suite 732 Brooksside, IL 89305",208
965,2025-09-13 17:57:02.952812 +00:00,,"0592 Collins Mall South Marvinside, SD 67008",208
966,2020-12-29 13:37:33.037806 +00:00,2021-02-03 19:37:33.037806 +00:00,"516 Janice Lock Apt. 990 Kruegerhaven, MN 92326",209
967,2017-02-18 02:42:56.198618 +00:00,2017-04-06 14:42:56.198618 +00:00,"749 Michael Lock New Jeremyview, OH 57406",209
968,2021-05-26 06:16:46.919497 +00:00,2021-08-27 04:16:46.919497 +00:00,"9091 Diana Highway Apt. 434 Port Mathew, MO 85937",209
969,2021-08-03 07:37:58.343178 +00:00,2021-08-06 15:37:58.343178 +00:00,"8492 Mccarty Turnpike Suite 458 Allenmouth, NV 23703",210
970,2012-08-08 00:18:05.493148 +00:00,2012-08-15 17:18:05.493148 +00:00,"61519 Lori Villages Brownport, MN 54357",210
971,2025-08-23 05:14:38.034539 +00:00,2025-09-09 17:14:38.034539 +00:00,"209 Andrew Villages Suite 682 Geraldton, KY 84935",210
972,2020-06-12 10:50:34.927505 +00:00,2020-09-14 04:50:34.927505 +00:00,"690 Joan Hills Apt. 541 North Angela, MH 02882",210
973,2014-07-23 02:27:39.211145 +00:00,2014-08-25 00:27:39.211145 +00:00,"82654 James Springs South Valerie, NJ 84084",210
974,2015-02-02 20:05:16.093533 +00:00,2015-03-03 14:05:16.093533 +00:00,"83370 Joseph Rest Williamfort, IN 08536",210
975,2025-08-29 19:24:01.241014 +00:00,2025-09-19 20:24:01.241014 +00:00,"41457 Saunders Green New Justin, TX 71613",210
976,2020-12-24 13:42:35.420751 +00:00,2021-03-16 00:42:35.420751 +00:00,"39027 Johnson Curve Michaelmouth, RI 52629",210
977,2016-06-21 11:07:56.870967 +00:00,2016-08-01 22:07:56.870967 +00:00,"4818 Henry Branch Suite 286 West Rebeccaview, NH 13474",211
978,2012-04-13 09:18:25.798640 +00:00,2012-07-20 17:18:25.798640 +00:00,"8085 Mario Wells Apt. 275 Alexanderchester, MN 48536",211
979,2015-05-08 15:04:09.666391 +00:00,2015-08-06 15:04:09.666391 +00:00,Unit 6372 Box 2576 DPO AA 97547,211
980,2025-07-04 21:45:27.541435 +00:00,2025-07-23 00:45:27.541435 +00:00,"229 William Highway Edwardstad, IA 86137",211
981,2017-08-02 09:38:43.749061 +00:00,2017-11-02 11:38:43.749061 +00:00,"87557 Derek Crest Donaldstad, NV 03752",211
982,2018-11-28 12:31:37.507701 +00:00,2019-03-02 21:31:37.507701 +00:00,"8839 Berry Cove New Alejandraberg, CT 78859",211
983,2025-09-21 01:11:59.165414 +00:00,,"579 Lewis Knoll Port Robert, PR 12484",211
984,2025-09-29 06:21:33.689878 +00:00,,"0169 Murphy Trail West Sherry, WV 06754",212
985,2022-02-23 17:13:48.582535 +00:00,2022-04-11 19:13:48.582535 +00:00,"1048 Taylor Spur Suite 684 Tylerton, GU 36847",212
986,2014-04-29 01:32:25.679464 +00:00,2014-04-30 17:32:25.679464 +00:00,"67305 Foster Walks New Robertshire, GU 43547",212
987,2018-06-11 16:33:01.225868 +00:00,2018-07-17 22:33:01.225868 +00:00,"0741 Stephen Meadows Amandaport, ME 07753",212
988,2018-06-16 16:18:02.532392 +00:00,2018-09-21 18:18:02.532392 +00:00,"29585 Samantha Causeway Apt. 240 Fergusonport, CA 44094",212
989,2025-09-11 12:14:52.783281 +00:00,,"039 Thompson Dale Apt. 745 East Johnport, MS 95566",212
990,2025-08-05 16:17:39.133302 +00:00,2025-09-03 15:17:39.133302 +00:00,"72797 Robert Drive Baileyside, AR 93892",212
991,2011-08-11 21:47:50.517956 +00:00,2011-09-12 08:47:50.517956 +00:00,"647 Eileen Loaf Suite 433 Lake Samuel, PA 53922",213
992,2025-07-15 22:22:44.331702 +00:00,,"PSC 1901, Box 8182 APO AE 44168",213
993,2025-10-03 16:51:43.502461 +00:00,,"20681 Taylor Village Apt. 688 North Scott, VI 34887",214
994,2025-07-12 23:21:45.049943 +00:00,2025-08-29 06:21:45.049943 +00:00,"64812 Oliver Cape Thompsonberg, WY 66496",214
995,2020-11-13 07:17:06.107583 +00:00,2021-01-19 04:17:06.107583 +00:00,Unit 8728 Box 2862 DPO AE 99612,215
996,2011-09-08 16:15:16.087826 +00:00,2011-10-06 09:15:16.087826 +00:00,"PSC 4386, Box 6713 APO AP 93608",216
997,2012-06-17 08:16:09.478888 +00:00,2012-06-19 00:16:09.478888 +00:00,"10178 Becker Road West Gina, PR 27605",216
998,2013-12-01 01:59:36.072260 +00:00,2014-03-09 14:59:36.072260 +00:00,"87718 Bennett Village West Johnberg, GU 23865",217
999,2025-09-07 19:48:25.938583 +00:00,,"1256 Smith Station Jonmouth, OR 69853",217
1000,2025-09-15 23:08:48.596210 +00:00,,"68225 Short Shores Trevorburgh, IL 67728",218
1001,2018-10-22 01:38:25.718117 +00:00,2019-01-11 02:38:25.718117 +00:00,"091 Michael Locks Chadville, TN 09081",218
1002,2025-08-06 23:38:55.433911 +00:00,,"7921 Melissa Dale East Shannon, ME 70974",218
1003,2013-11-01 14:14:03.893297 +00:00,2013-12-04 02:14:03.893297 +00:00,"29900 Tracy Cape South Michael, ID 99837",218
1004,2025-08-04 17:53:35.095217 +00:00,2025-09-02 11:53:35.095217 +00:00,"700 Mary Falls Suite 566 Morrowborough, UT 28480",218
1005,2010-11-12 15:03:23.110147 +00:00,2011-01-19 13:03:23.110147 +00:00,"07776 Torres Way Apt. 202 New Samantha, VT 58964",218
1006,2014-09-12 03:42:04.425012 +00:00,2014-09-14 10:42:04.425012 +00:00,"392 Charles Canyon Apt. 547 West Danielside, MH 91520",218
1007,2011-06-24 00:17:50.224368 +00:00,2011-07-16 22:17:50.224368 +00:00,"427 Ronald Dale Apt. 321 South Cheryl, NJ 64447",218
1008,2022-10-09 08:14:46.154695 +00:00,2022-12-10 15:14:46.154695 +00:00,"1053 Sheena Stream Suite 248 Wallershire, ND 75661",219
1009,2025-09-03 07:58:26.524274 +00:00,,"0517 West Junctions New Rebecca, AL 91466",219
1010,2025-07-09 04:34:12.516983 +00:00,2025-08-08 19:34:12.516983 +00:00,"82315 Ashley Islands Chelseaton, VI 26145",219
1011,2013-03-09 07:16:46.644056 +00:00,2013-05-31 20:16:46.644056 +00:00,"37751 Penny Valley Gomezburgh, SC 73358",220
1012,2025-09-11 17:12:16.202642 +00:00,2025-09-24 00:12:16.202642 +00:00,"5073 Monica River Suite 847 Geoffreyport, UT 35626",221
1013,2023-05-13 21:32:01.056489 +00:00,2023-07-09 08:32:01.056489 +00:00,"7479 Frazier Pass Apt. 963 Jeffreyhaven, AZ 70214",221
1014,2012-10-23 11:54:08.463351 +00:00,2012-11-12 06:54:08.463351 +00:00,"13318 Smith Bypass Apt. 427 Michaelview, AL 96045",221
1015,2016-09-25 19:02:21.413081 +00:00,2016-12-10 05:02:21.413081 +00:00,"20431 Valenzuela Glens Port Mark, LA 38194",221
1016,2020-09-12 13:28:50.690724 +00:00,2020-10-31 12:28:50.690724 +00:00,"854 Adams Tunnel Angelastad, DC 90665",221
1017,2010-10-03 13:15:20.953980 +00:00,2010-11-26 02:15:20.953980 +00:00,USNS Hampton FPO AP 73343,221
1018,2022-03-20 01:00:14.739015 +00:00,2022-06-10 08:00:14.739015 +00:00,"644 Michael Pike South Cynthiamouth, CA 94800",221
1019,2012-02-01 12:08:29.067841 +00:00,2012-03-18 18:08:29.067841 +00:00,Unit 6532 Box 6973 DPO AP 68941,221
1020,2024-09-10 15:59:40.368308 +00:00,2024-09-14 19:59:40.368308 +00:00,"072 Clark Skyway Apt. 418 Espinozashire, NY 65793",222
1021,2025-08-20 03:38:32.334678 +00:00,,"282 Boone Crescent Apt. 715 North Colin, ID 51483",222
1022,2025-08-15 23:15:03.706368 +00:00,,"695 Lauren Lake Lake David, FL 54307",223
1023,2013-02-04 06:19:02.161892 +00:00,2013-02-21 13:19:02.161892 +00:00,"77868 Porter Stream Port Richard, OH 24433",223
1024,2021-04-14 05:25:52.748486 +00:00,2021-06-23 10:25:52.748486 +00:00,"9000 Wiley Freeway Suite 346 New Fernando, PW 40129",223
1025,2015-04-13 08:27:11.186601 +00:00,2015-06-07 08:27:11.186601 +00:00,"745 Banks Village Suite 943 East Brendastad, NC 38510",224
1026,2025-08-05 20:04:11.808298 +00:00,,"759 Wise Unions Suite 560 East Maryton, KS 44555",224
1027,2025-08-07 23:29:46.382392 +00:00,2025-08-27 03:29:46.382392 +00:00,"802 Tammy Walks New Cynthia, MS 87215",225
1028,2012-04-27 07:12:27.511989 +00:00,2012-06-24 10:12:27.511989 +00:00,"6714 Douglas Hills Apt. 976 Lindsayland, MH 00704",225
1029,2025-07-30 19:40:19.056092 +00:00,2025-08-13 03:40:19.056092 +00:00,USNV Smith FPO AA 13852,225
1030,2025-02-02 22:15:35.939165 +00:00,2025-03-07 10:15:35.939165 +00:00,"8588 Rogers Ranch North Danielshire, NE 54562",225
1031,2025-08-30 22:01:37.850524 +00:00,,"1156 Werner Landing Apt. 839 Port Veronicabury, AL 83274",225
1032,2013-10-10 05:16:12.623058 +00:00,2013-11-05 01:16:12.623058 +00:00,"570 Alexandra Tunnel Suite 050 Kimberlytown, MN 66675",226
1033,2020-08-06 18:07:23.367943 +00:00,2020-08-16 18:07:23.367943 +00:00,"71802 Black Rest Port Danielle, UT 18664",226
1034,2010-10-28 14:39:52.791366 +00:00,2010-12-24 11:39:52.791366 +00:00,"04379 Allison Square Brittanyport, RI 35586",226
1035,2023-07-14 11:08:25.094611 +00:00,2023-08-16 14:08:25.094611 +00:00,"959 Roberta Cape Suite 767 Thomashaven, AL 10678",226
1036,2010-01-19 09:37:43.940950 +00:00,2010-02-04 10:37:43.940950 +00:00,"802 Morris Well Apt. 111 North Patty, AL 79538",226
1037,2017-09-27 16:13:20.479194 +00:00,2017-11-03 08:13:20.479194 +00:00,"276 Ann Square Apt. 099 Davismouth, AZ 65238",226
1038,2025-08-10 11:13:52.002065 +00:00,2025-09-28 10:13:52.002065 +00:00,"PSC 6461, Box 0333 APO AE 23304",227
1039,2013-07-21 02:43:50.772871 +00:00,2013-09-13 16:43:50.772871 +00:00,"065 Snyder Road Suite 046 North Michaelville, MT 10473",227
1040,2025-08-19 12:45:51.273566 +00:00,2025-09-12 01:45:51.273566 +00:00,"8247 Cowan Glen Josephberg, WV 99672",227
1041,2023-08-26 07:56:32.334218 +00:00,2023-09-29 06:56:32.334218 +00:00,"PSC 6534, Box 7855 APO AA 01425",227
1042,2025-08-24 06:57:07.146847 +00:00,,"3221 Angela Circle Wisechester, PR 88844",228
1043,2015-01-06 00:08:18.126618 +00:00,2015-03-27 00:08:18.126618 +00:00,"1677 Kathleen Trace West Bryan, NV 60384",228
1044,2019-05-21 05:42:45.792475 +00:00,2019-07-11 11:42:45.792475 +00:00,"PSC 6768, Box 1448 APO AA 56808",228
1045,2014-11-25 07:42:29.960490 +00:00,2015-02-02 16:42:29.960490 +00:00,"5978 Gill Street New Kenneth, CA 28392",228
1046,2019-01-05 22:23:47.444839 +00:00,2019-02-19 22:23:47.444839 +00:00,"43832 Gary Wall West Briana, CO 77144",228
1047,2018-04-25 06:24:55.339008 +00:00,2018-06-28 10:24:55.339008 +00:00,"916 Ethan Street Martinton, OH 79915",229
1048,2012-04-11 03:28:36.666592 +00:00,2012-05-13 00:28:36.666592 +00:00,Unit 6532 Box 6973 DPO AP 68941,229
1049,2015-02-28 21:42:42.660238 +00:00,2015-03-11 17:42:42.660238 +00:00,"4656 Simmons Springs Suite 583 West Lisa, NY 21355",229
1050,2025-07-05 09:12:26.993011 +00:00,2025-09-06 07:12:26.993011 +00:00,"53159 Steven Mission Hamiltonview, PA 66540",229
1051,2022-09-10 17:05:55.524626 +00:00,2022-12-07 05:05:55.524626 +00:00,"67649 Christopher Loaf Littlemouth, FM 25289",229
1052,2012-09-05 08:42:45.187651 +00:00,2012-12-05 14:42:45.187651 +00:00,"8487 Matthew Hollow Suite 652 South Jaredview, VT 23111",229
1053,2025-03-16 05:58:10.946556 +00:00,2025-06-07 03:58:10.946556 +00:00,"6755 Joshua Locks Port Douglasberg, MA 52488",230
1054,2015-05-20 18:48:50.031307 +00:00,2015-08-07 22:48:50.031307 +00:00,"008 Jennifer Pine Apt. 833 Thomasfort, MH 27647",230
1055,2025-07-06 03:06:56.758147 +00:00,2025-07-11 08:06:56.758147 +00:00,"0363 Rangel Shore Port Andrew, AR 85720",230
1056,2014-09-07 23:22:32.577585 +00:00,2014-10-18 09:22:32.577585 +00:00,"190 Warner Well Apt. 047 West Michaeltown, PW 41872",230
1057,2017-02-04 08:02:15.468678 +00:00,2017-05-05 08:02:15.468678 +00:00,"802 Sabrina Loop Suite 434 Annabury, VI 48132",230
1058,2011-02-20 21:07:30.294116 +00:00,2011-03-09 18:07:30.294116 +00:00,"1160 Lee Knoll Suite 953 Rebeccaport, CA 47679",230
1059,2025-08-21 10:40:29.225361 +00:00,2025-10-03 23:40:29.225361 +00:00,Unit 6112 Box 3561 DPO AP 38580,231
1060,2019-02-07 10:41:04.136719 +00:00,2019-04-13 20:41:04.136719 +00:00,"9009 Phillips Courts New Marymouth, MT 29871",231
1061,2025-06-28 11:14:55.192031 +00:00,2025-09-27 07:14:55.192031 +00:00,"8821 David Lane Apt. 064 South Hannahport, MN 53903",231
1062,2015-03-31 05:42:09.851264 +00:00,2015-05-05 20:42:09.851264 +00:00,"2592 Mark Place Suite 436 South Josephport, OR 34119",231
1063,2025-10-01 06:48:29.137894 +00:00,,"619 Amanda Station Port Mikeberg, SC 24664",231
1064,2012-08-21 15:46:23.670166 +00:00,2012-10-04 04:46:23.670166 +00:00,"961 Beltran Manor Apt. 645 East Jessicachester, FM 86385",231
1065,2025-08-09 04:07:03.367208 +00:00,2025-10-05 06:07:03.367208 +00:00,"41681 Trujillo Crossing Port Jamiemouth, MO 19173",231
1066,2020-09-24 21:14:31.165833 +00:00,2020-12-29 07:14:31.165833 +00:00,"836 Manning Lock Jamesbury, GA 52364",231
1067,2025-07-30 12:45:09.374738 +00:00,2025-08-28 16:45:09.374738 +00:00,"372 Stephen Burgs Apt. 885 Port Johnathanmouth, MD 10420",232
1068,2013-02-14 06:03:27.203337 +00:00,2013-02-27 19:03:27.203337 +00:00,"090 Reynolds Mill Mitchellton, MN 63274",233
1069,2018-05-08 19:25:32.316288 +00:00,2018-07-04 11:25:32.316288 +00:00,"4642 Sonya Extensions West Dale, NC 38840",233
1070,2011-02-08 10:10:37.354462 +00:00,2011-05-14 10:10:37.354462 +00:00,"4939 Myers Court Suite 274 Mendezside, AS 89755",234
1071,2022-12-15 01:32:31.293216 +00:00,2023-02-03 21:32:31.293216 +00:00,"68895 Jacqueline Ranch Jamesfurt, VI 27978",234
1072,2018-02-06 01:44:28.826672 +00:00,2018-02-18 18:44:28.826672 +00:00,"3222 Manuel Cliff Suite 716 Nancyton, IL 40512",234
1073,2016-11-20 00:37:04.972311 +00:00,2016-12-04 04:37:04.972311 +00:00,"4522 Sandra Throughway Apt. 503 Aliciahaven, WV 35983",234
1074,2014-08-12 07:37:41.444152 +00:00,2014-08-15 05:37:41.444152 +00:00,"852 Ashley Burg New Scottfurt, WI 00819",234
1075,2011-10-25 17:06:11.445552 +00:00,2012-01-05 04:06:11.445552 +00:00,"7705 Tammy Shore Suite 346 Toddhaven, MT 01538",234
1076,2020-10-17 22:30:50.910204 +00:00,2021-01-20 02:30:50.910204 +00:00,"65078 Debbie Pike Apt. 362 Williamschester, AS 34951",234
1077,2025-09-24 07:23:20.310039 +00:00,2025-10-02 20:23:20.310039 +00:00,"0757 Buchanan Club Mckeetown, PR 00730",235
1078,2018-07-15 13:18:00.727553 +00:00,2018-08-06 05:18:00.727553 +00:00,"9914 Sarah Harbors Suite 502 Simpsonport, NC 84230",235
1079,2025-09-30 00:41:35.062315 +00:00,,"404 Cox Stravenue Perezfurt, RI 66033",235
1080,2022-01-06 16:37:29.874586 +00:00,2022-03-13 02:37:29.874586 +00:00,"82751 Linda Center Leonardbury, WA 05613",235
1081,2022-10-31 05:37:23.015454 +00:00,2023-01-01 02:37:23.015454 +00:00,"74923 Kimberly Forge Suite 698 Randallbury, ND 83500",235
1082,2022-09-18 07:34:14.037981 +00:00,2022-11-30 00:34:14.037981 +00:00,"8793 Fisher Village Dwayneville, NY 28002",235
1083,2016-04-19 11:31:51.501753 +00:00,2016-04-30 22:31:51.501753 +00:00,"63183 Danielle Walks Howardborough, MP 24242",235
1084,2017-02-26 19:57:20.566178 +00:00,2017-05-12 19:57:20.566178 +00:00,"76158 Peck Haven Paulamouth, AZ 61751",236
1085,2024-07-25 00:57:31.159199 +00:00,2024-09-21 03:57:31.159199 +00:00,"7917 Castillo Rapids Suite 253 West Heidi, ID 44193",236
1086,2013-09-03 08:09:15.229167 +00:00,2013-11-07 08:09:15.229167 +00:00,"81820 Anthony Plaza South Nicholas, MS 21853",236
1087,2024-04-28 09:23:21.905262 +00:00,2024-06-08 05:23:21.905262 +00:00,"099 Vazquez Row South Brianchester, NC 13295",236
1088,2011-03-05 14:12:56.410344 +00:00,2011-05-13 18:12:56.410344 +00:00,"13713 Jonathan Track Apt. 116 Adkinsbury, MP 56807",237
1089,2015-09-02 14:33:38.360365 +00:00,2015-09-29 06:33:38.360365 +00:00,"889 Mckay Viaduct Apt. 853 New Marcus, NH 59979",237
1090,2018-10-13 09:28:35.413577 +00:00,2018-12-29 21:28:35.413577 +00:00,"6824 Mcneil Square Jacquelinetown, VA 18607",237
1091,2025-07-12 23:33:24.186638 +00:00,2025-09-24 02:33:24.186638 +00:00,"6056 Dean Mountains Suite 709 West Robert, MS 95360",237
1092,2025-06-08 11:14:28.831418 +00:00,2025-07-02 05:14:28.831418 +00:00,"39204 Catherine Plaza Suite 000 Davidville, ME 34474",237
1093,2013-05-05 21:47:20.311350 +00:00,2013-07-26 03:47:20.311350 +00:00,"0442 Whitney Streets Suite 796 Rebeccahaven, KS 65181",237
1094,2019-02-17 08:57:29.418393 +00:00,2019-02-25 21:57:29.418393 +00:00,"441 Anthony Trace Kelleyport, VA 01581",237
1095,2025-07-23 03:55:34.828060 +00:00,,USNS Jones FPO AA 38261,237
1096,2016-11-06 01:22:32.879697 +00:00,2016-12-27 02:22:32.879697 +00:00,"150 Yolanda Wall North Pamela, NE 77458",238
1097,2013-06-16 21:59:33.339891 +00:00,2013-08-24 05:59:33.339891 +00:00,"1242 Eric Mall North Jennifer, ME 80424",238
1098,2025-05-30 00:32:41.319279 +00:00,2025-08-12 09:32:41.319279 +00:00,"589 Dominique Alley Barnesland, KY 20489",239
1099,2025-07-15 20:51:56.313677 +00:00,,"3640 Amber Spurs Apt. 788 North Troyville, MN 64677",239
1100,2010-08-17 04:14:03.194860 +00:00,2010-11-11 05:14:03.194860 +00:00,Unit 7017 Box 4689 DPO AP 99243,239
1101,2012-06-25 17:34:15.878399 +00:00,2012-08-02 00:34:15.878399 +00:00,Unit 6294 Box 1216 DPO AP 61145,240
1102,2015-07-20 17:36:36.315330 +00:00,2015-09-18 12:36:36.315330 +00:00,"0520 Crawford Roads Suite 012 Jasonhaven, ID 05922",240
1103,2025-02-07 23:00:26.032382 +00:00,2025-05-01 01:00:26.032382 +00:00,"84565 Mason Creek Port Cynthiafort, UT 46887",240
1104,2025-09-19 06:50:50.998353 +00:00,,"39077 Cody Canyon Suite 760 Douglastown, VT 95611",241
1105,2014-08-25 10:20:06.062860 +00:00,2014-08-30 15:20:06.062860 +00:00,"8427 Robinson Haven Apt. 521 Ethanfurt, KY 30929",241
1106,2012-11-27 11:43:49.643048 +00:00,2013-03-03 07:43:49.643048 +00:00,"5669 Melody Throughway Apt. 398 Robertberg, IN 29938",241
1107,2025-07-22 23:49:34.322554 +00:00,2025-08-24 06:49:34.322554 +00:00,"07241 Kirk Oval Michaelmouth, MH 43216",241
1108,2025-07-10 23:06:29.711462 +00:00,,"PSC 3399, Box 1219 APO AE 12586",241
1109,2016-08-04 09:56:36.511170 +00:00,2016-11-09 11:56:36.511170 +00:00,"992 Jesse Radial Apt. 998 Laurenbury, ME 29488",241
1110,2025-10-01 14:09:57.647835 +00:00,,"660 Berry Divide Suite 640 Port Rachael, GA 87919",242
1111,2010-01-24 19:30:49.402153 +00:00,2010-04-17 12:30:49.402153 +00:00,"3617 Haney Tunnel Apt. 844 North Kennethland, DC 70137",242
1112,2025-07-23 01:09:27.803425 +00:00,2025-07-23 11:09:27.803425 +00:00,USCGC Johnson FPO AE 81813,242
1113,2010-10-01 14:20:19.322364 +00:00,2010-10-03 06:20:19.322364 +00:00,"1267 Melinda Views Apt. 664 South Christopherport, GU 03201",242
1114,2025-09-13 06:22:22.225570 +00:00,,"72025 Tracy Place Suite 929 Port Nicholas, FM 06543",243
1115,2015-03-21 12:59:56.724082 +00:00,2015-06-26 19:59:56.724082 +00:00,"74944 Megan Ville Suite 920 Josephton, ME 93697",243
1116,2019-11-10 21:02:02.212904 +00:00,2019-12-23 14:02:02.212904 +00:00,"2375 Clark Spur Apt. 051 Brandonfurt, NM 87944",243
1117,2025-09-02 09:30:57.664288 +00:00,,"1063 Dylan Fork Suite 811 South Heatherville, AR 17355",243
1118,2025-07-06 13:22:43.047814 +00:00,2025-09-22 11:22:43.047814 +00:00,"PSC 9685, Box 4940 APO AE 56374",243
1119,2020-08-25 04:33:02.795389 +00:00,2020-08-29 08:33:02.795389 +00:00,"421 Harry Passage Suite 532 Hamiltonchester, GU 28030",243
1120,2011-03-09 06:36:26.804376 +00:00,2011-06-04 23:36:26.804376 +00:00,"68734 Crawford Corner Bruceview, UT 23499",243
1121,2025-07-13 10:30:03.744220 +00:00,2025-09-14 23:30:03.744220 +00:00,"0035 Kaitlin Falls Gonzalesfort, ND 95272",243
1122,2017-11-06 00:05:37.349270 +00:00,2017-11-27 06:05:37.349270 +00:00,"74812 Kline Plains Grayside, OR 96792",244
1123,2021-07-08 06:58:52.157572 +00:00,2021-09-30 00:58:52.157572 +00:00,"79264 Nelson Viaduct Jamesview, MS 42863",244
1124,2025-07-01 07:15:48.626154 +00:00,2025-07-13 19:15:48.626154 +00:00,"9234 Martinez Port Suite 356 New Danielview, NH 77266",244
1125,2018-03-02 06:22:25.254657 +00:00,2018-03-12 11:22:25.254657 +00:00,"550 Armstrong Roads Suite 689 Watsonton, MO 47330",244
1126,2020-05-05 11:42:17.774172 +00:00,2020-06-16 13:42:17.774172 +00:00,"2610 Jeffrey Views East Markbury, AL 10977",244
1127,2014-06-30 04:35:30.121176 +00:00,2014-07-11 20:35:30.121176 +00:00,"3487 Frazier Cape Suite 371 Zacharyshire, PR 65233",244
1128,2018-02-19 00:07:24.163487 +00:00,2018-02-19 20:07:24.163487 +00:00,"14233 Grant Wells East Tanya, PR 46384",244
1129,2022-04-09 07:36:53.130850 +00:00,2022-06-22 06:36:53.130850 +00:00,"3452 Olsen Meadows Fisherfort, MP 82693",244
1130,2016-12-16 11:58:55.589718 +00:00,2017-03-10 20:58:55.589718 +00:00,"380 Jones Wells Suite 843 Danielmouth, AZ 63075",245
1131,2025-09-06 15:33:50.300212 +00:00,2025-09-17 01:33:50.300212 +00:00,"30840 Luke Forks Apt. 989 Tranton, CO 68623",245
1132,2025-08-13 12:41:17.541629 +00:00,2025-08-16 20:41:17.541629 +00:00,"124 Stanton Radial Port Kimberly, OK 25202",245
1133,2024-06-26 20:28:26.813281 +00:00,2024-07-14 08:28:26.813281 +00:00,"9639 Mclean Expressway Suite 895 Lake Adrianbury, MN 02007",245
1134,2012-09-01 02:37:59.875593 +00:00,2012-11-20 12:37:59.875593 +00:00,"8604 Little Orchard Mariemouth, WA 27566",245
1135,2018-01-06 07:30:54.067588 +00:00,2018-03-22 22:30:54.067588 +00:00,"059 David Forest Lake Moniqueside, PA 18853",246
1136,2017-08-23 18:15:49.172785 +00:00,2017-11-06 23:15:49.172785 +00:00,"367 Hoffman Stream Apt. 364 South Staceybury, NE 03922",246
1137,2017-04-21 01:36:45.395120 +00:00,2017-05-09 19:36:45.395120 +00:00,"085 Daniel Viaduct Suite 034 Lake Joshua, FM 36618",247
1138,2011-05-01 20:09:59.067113 +00:00,2011-07-30 05:09:59.067113 +00:00,"85217 Johnson Vista Lake Katiemouth, MO 49469",247
1139,2025-09-13 15:12:47.783122 +00:00,,"717 Lorraine Shore Shannonburgh, PA 60908",247
1140,2025-10-03 17:35:01.101967 +00:00,,"82204 Angela Bridge Suite 818 New Karen, OR 90698",247
1141,2014-09-28 05:07:31.269022 +00:00,2014-12-10 18:07:31.269022 +00:00,"41780 Melinda Station North Robertton, NC 83240",247
1142,2010-11-27 15:28:17.109051 +00:00,2011-03-06 04:28:17.109051 +00:00,"2957 Andrew Stravenue Sherryton, NC 98869",247
1143,2024-06-06 15:30:38.405845 +00:00,2024-07-25 19:30:38.405845 +00:00,USS Roberts FPO AP 25244,247
1144,2024-05-17 23:39:41.230544 +00:00,2024-07-06 23:39:41.230544 +00:00,"053 Massey Forest North Carlos, VA 32870",248
1145,2025-09-21 00:06:15.943172 +00:00,,"33498 James Pine Suite 900 North Christopher, GA 94703",248
1146,2011-05-03 05:04:23.035519 +00:00,2011-05-11 08:04:23.035519 +00:00,"68225 Short Shores Trevorburgh, IL 67728",248
1147,2024-12-26 19:00:09.262978 +00:00,2025-01-10 09:00:09.262978 +00:00,"97115 Johnson Estate Suite 314 Hoganmouth, PW 56752",248
1148,2014-06-13 08:29:13.838428 +00:00,2014-07-07 22:29:13.838428 +00:00,"6287 Roberta Parkways Suite 524 Hernandezburgh, ND 71753",248
1149,2010-09-08 12:01:17.900027 +00:00,2010-09-12 21:01:17.900027 +00:00,"0717 Alexander Corners Martinside, SC 95307",248
1150,2011-08-31 01:26:26.668679 +00:00,2011-09-29 00:26:26.668679 +00:00,"27761 Davis Streets Summertown, VI 05705",249
1151,2025-09-26 23:44:51.487949 +00:00,,"PSC 4454, Box 7313 APO AE 60268",249
1152,2020-07-29 13:46:49.057346 +00:00,2020-08-15 05:46:49.057346 +00:00,"0235 Reyes Park Jeremyland, PW 76070",249
1153,2025-08-26 07:04:54.519579 +00:00,2025-09-22 04:04:54.519579 +00:00,"285 James Plaza East Matthew, WA 06861",249
1154,2012-08-15 21:43:05.901811 +00:00,2012-08-19 00:43:05.901811 +00:00,"9445 Harris Fall Apt. 386 Sarahview, VI 33160",249
1155,2022-03-31 12:51:39.189403 +00:00,2022-05-30 17:51:39.189403 +00:00,"68225 Short Shores Trevorburgh, IL 67728",249
1156,2012-02-04 22:33:41.999051 +00:00,2012-05-04 22:33:41.999051 +00:00,USCGC Mccoy FPO AE 81321,249
1157,2019-12-24 00:04:24.881554 +00:00,2020-02-26 19:04:24.881554 +00:00,"0120 Kyle Manors Apt. 468 Emilymouth, NM 57819",250
1158,2018-08-12 19:16:46.972611 +00:00,2018-11-18 07:16:46.972611 +00:00,"308 Norris Streets South Teresa, PW 59523",250
1159,2013-05-03 05:43:33.810905 +00:00,2013-06-12 05:43:33.810905 +00:00,"66537 Sanders Creek Anitastad, VA 14351",250
1160,2025-09-23 16:42:44.563039 +00:00,,"59435 Melissa Estates Apt. 405 South Christopher, AR 80536",250
1161,2017-12-29 03:56:48.482121 +00:00,2018-01-10 20:56:48.482121 +00:00,USS Rogers FPO AA 25272,250
1162,2013-02-14 12:05:07.825556 +00:00,2013-04-12 19:05:07.825556 +00:00,Unit 8670 Box 2703 DPO AP 69764,251
1163,2021-02-03 12:41:09.031497 +00:00,2021-04-08 11:41:09.031497 +00:00,"6993 Craig Wall Apt. 735 Tonihaven, NC 92169",251
1164,2019-08-26 03:42:34.797288 +00:00,2019-10-07 05:42:34.797288 +00:00,"73976 West Ferry Suite 804 New Aaron, GU 85175",251
1165,2025-08-10 01:37:02.743720 +00:00,2025-09-30 02:37:02.743720 +00:00,"40612 David Knolls Suite 156 New Tracey, NV 60179",251
1166,2025-10-04 15:56:01.299159 +00:00,,"81051 Sanford Forks Marcport, NY 75480",251
1167,2017-01-25 12:33:07.146988 +00:00,2017-02-07 10:33:07.146988 +00:00,USCGC Marsh FPO AA 29493,251
1168,2023-11-17 13:13:27.209205 +00:00,2024-02-04 22:13:27.209205 +00:00,"24846 Daniel Coves Suite 832 West Stefanieburgh, MS 89662",252
1169,2018-06-30 10:15:20.512055 +00:00,2018-07-23 23:15:20.512055 +00:00,"52421 Julie Drive East Derekmouth, MO 81046",252
1170,2011-01-20 05:29:36.221178 +00:00,2011-02-04 20:29:36.221178 +00:00,"162 Gabriel Field East Stevenport, UT 46030",252
1171,2019-05-17 13:34:31.386046 +00:00,2019-08-07 00:34:31.386046 +00:00,"5271 Cox Ways Apt. 522 Bentonfurt, AR 21490",252
1172,2019-07-28 06:33:02.005759 +00:00,2019-10-09 09:33:02.005759 +00:00,"60274 Vega Freeway Apt. 671 Lopezport, KS 76461",252
1173,2024-08-20 10:31:34.196366 +00:00,2024-09-04 05:31:34.196366 +00:00,"4239 Taylor River Port Michaelstad, LA 73139",253
1174,2014-07-02 18:28:18.401574 +00:00,2014-07-12 03:28:18.401574 +00:00,"384 Bryan Knolls Suite 587 Michaelside, HI 63577",253
1175,2011-08-06 06:45:18.562814 +00:00,2011-08-26 11:45:18.562814 +00:00,"PSC 1674, Box 4907 APO AA 99541",253
1176,2022-01-14 00:15:44.552669 +00:00,2022-03-29 19:15:44.552669 +00:00,"283 Jackson Throughway Suite 475 Wendyshire, KY 00833",253
1177,2024-03-14 17:31:20.593219 +00:00,2024-06-14 14:31:20.593219 +00:00,"661 Lowery Run Apt. 844 New Richardbury, IN 56065",253
1178,2017-09-01 15:00:18.585129 +00:00,2017-10-28 07:00:18.585129 +00:00,"8851 Jesse Club Suite 566 Kevinfurt, NJ 52038",253
1179,2025-08-07 15:53:34.619128 +00:00,,"13085 Christine Passage Suite 139 North Julietown, WY 25875",253
1180,2023-04-19 19:15:25.700680 +00:00,2023-06-07 03:15:25.700680 +00:00,"265 Coleman Square Apt. 043 Michaelmouth, NH 05295",253
1181,2022-07-10 20:45:08.286213 +00:00,2022-07-30 00:45:08.286213 +00:00,"2992 Christopher Underpass Apt. 301 South Nancyville, NY 95743",254
1182,2015-03-10 23:21:25.821122 +00:00,2015-04-24 23:21:25.821122 +00:00,"496 Scott Junction Sabrinaburgh, MN 21567",254
1183,2013-04-09 16:08:40.996801 +00:00,2013-05-30 22:08:40.996801 +00:00,"9305 Clay Locks Apt. 130 South Michael, NV 37570",255
1184,2012-09-07 07:50:52.153471 +00:00,2012-12-11 12:50:52.153471 +00:00,"913 Burns Unions Suite 314 North Aimeeton, WI 73358",255
1185,2023-04-17 04:29:04.216748 +00:00,2023-04-26 08:29:04.216748 +00:00,"718 Mary Loaf Suite 117 Lake Danielside, MH 24132",255
1186,2015-01-15 02:01:33.782639 +00:00,2015-03-06 17:01:33.782639 +00:00,"55984 Ariel Camp Suite 726 West Michaelhaven, PR 31225",255
1187,2013-03-30 15:51:53.319067 +00:00,2013-04-06 12:51:53.319067 +00:00,"5082 Newton Tunnel Apt. 456 Lake Jasonborough, NM 56170",255
1188,2025-08-10 01:45:37.911661 +00:00,,"07830 Clayton Springs Lake Stephanie, NH 12990",255
1189,2025-09-26 09:06:39.802168 +00:00,,USNV Smith FPO AP 86547,255
1190,2022-05-23 02:43:03.893842 +00:00,2022-06-17 07:43:03.893842 +00:00,"1227 Jennifer Canyon Burgessburgh, NE 19568",256
1191,2024-08-07 20:36:41.545682 +00:00,2024-09-12 16:36:41.545682 +00:00,"982 Holmes Tunnel Apt. 124 Lauratown, AS 71735",256
1192,2025-08-24 09:33:13.752702 +00:00,,"15738 Janet Burgs Suite 435 Kathrynchester, WV 04972",256
1193,2025-07-14 03:43:25.326311 +00:00,2025-09-19 15:43:25.326311 +00:00,"70615 Nicholas Mall Suite 548 North Vincent, TN 12676",256
1194,2018-03-25 13:28:55.192424 +00:00,2018-05-05 04:28:55.192424 +00:00,"16045 Craig Bypass Suite 610 Rodriguezside, SD 31977",256
1195,2025-07-07 12:31:07.844337 +00:00,2025-07-26 16:31:07.844337 +00:00,"473 Gray Junctions Wolfville, GU 46296",256
1196,2025-08-04 19:00:16.926049 +00:00,2025-08-17 17:00:16.926049 +00:00,"48045 Bradford View Apt. 286 Kellyshire, TN 73306",256
1197,2019-11-29 12:55:44.868847 +00:00,2020-01-27 11:55:44.868847 +00:00,"43240 Matthew Lock Suite 905 Lake Danielleside, NH 49034",257
1198,2020-03-17 07:35:51.461614 +00:00,2020-05-17 13:35:51.461614 +00:00,"9438 Jose Summit Kristinastad, MA 51652",257
1199,2016-02-29 09:20:51.190649 +00:00,2016-05-22 17:20:51.190649 +00:00,"6857 Perez Green Suite 323 West Randyhaven, IL 10838",257
1200,2022-05-27 23:16:28.861744 +00:00,2022-07-12 04:16:28.861744 +00:00,"7442 Dale Stravenue North Ericmouth, GU 33026",257
1201,2016-04-22 01:46:43.652013 +00:00,2016-06-21 21:46:43.652013 +00:00,"561 Tina Mountain Suite 414 East Brian, CO 75539",257
1202,2021-06-08 21:00:01.333242 +00:00,2021-07-15 08:00:01.333242 +00:00,"683 Smith Forge Suite 805 Dennismouth, MA 69336",257
1203,2010-10-26 13:28:50.062418 +00:00,2011-01-19 18:28:50.062418 +00:00,"0421 Jennings Street West April, NM 79554",257
1204,2016-03-28 11:10:56.315935 +00:00,2016-04-18 17:10:56.315935 +00:00,"47326 Valenzuela Motorway Moorechester, MS 71420",258
1205,2015-04-24 23:22:57.146824 +00:00,2015-06-14 14:22:57.146824 +00:00,"456 Kimberly Ridge New Nicoleland, MI 88839",258
1206,2025-02-19 14:04:19.643220 +00:00,2025-04-15 19:04:19.643220 +00:00,"191 Ramirez Pines Suite 615 Lake Willieland, AL 69335",258
1207,2018-09-03 08:39:44.378850 +00:00,2018-10-28 13:39:44.378850 +00:00,"96321 Brandt Ferry New Katherine, IA 88201",258
1208,2011-09-15 06:29:20.106435 +00:00,2011-11-20 07:29:20.106435 +00:00,"74519 Leonard Bypass Gregoryville, ME 04935",258
1209,2025-09-04 11:18:29.776940 +00:00,,"864 Susan Street Collinsville, OK 35570",259
1210,2025-07-16 07:21:59.468436 +00:00,2025-07-19 10:21:59.468436 +00:00,"65385 Zachary Port West Haley, VT 69685",259
1211,2013-10-05 23:04:26.634764 +00:00,2013-10-18 21:04:26.634764 +00:00,"36902 Allen Meadow Apt. 109 Lake Julie, IL 59106",259
1212,2025-05-16 04:31:20.058953 +00:00,2025-08-21 16:31:20.058953 +00:00,"6301 Linda Isle Apt. 465 Charlesfort, NE 79793",259
1213,2018-08-02 03:22:56.201044 +00:00,2018-11-02 15:22:56.201044 +00:00,"013 Vega Extensions East Gloriaburgh, IN 81722",259
1214,2025-09-02 08:15:42.479674 +00:00,2025-09-28 09:15:42.479674 +00:00,"480 Powers Greens Suite 722 South Elizabethtown, NV 19032",260
1215,2012-07-22 22:21:10.983810 +00:00,2012-08-13 14:21:10.983810 +00:00,"1386 James Fork West Brandystad, NJ 29817",260
1216,2025-08-31 00:29:42.635005 +00:00,2025-09-12 12:29:42.635005 +00:00,"2507 Nathan Loop Apt. 496 Lindaton, OK 23563",260
1217,2012-09-26 06:13:30.556785 +00:00,2012-11-08 19:13:30.556785 +00:00,"127 Elliott River Apt. 214 New Patrick, RI 86060",260
1218,2025-10-03 20:06:53.574391 +00:00,,"726 Richard Mount Lake Lisa, MH 00837",261
1219,2021-06-15 08:37:03.988774 +00:00,2021-07-23 01:37:03.988774 +00:00,"7673 William Villages Santanaton, WY 56901",261
1220,2010-06-23 11:11:35.925946 +00:00,2010-09-20 10:11:35.925946 +00:00,Unit 1906 Box 6904 DPO AA 55674,261
1221,2025-09-04 00:38:57.039102 +00:00,,"8098 Allison Roads Brownborough, OH 38405",261
1222,2017-04-03 23:35:29.963475 +00:00,2017-05-26 06:35:29.963475 +00:00,"5439 Anna Ranch Mendozaton, MS 55090",261
1223,2018-12-18 02:33:49.530977 +00:00,2019-03-17 16:33:49.530977 +00:00,"9583 Lori Ranch Port Sharonside, AK 31395",262
1224,2021-12-25 08:33:26.599201 +00:00,2022-03-20 08:33:26.599201 +00:00,"32195 Elizabeth Knolls East Taylor, WI 71669",262
1225,2021-01-02 23:50:02.960695 +00:00,2021-02-10 17:50:02.960695 +00:00,"48070 Baker Stravenue Luisshire, CO 19271",263
1226,2025-08-13 22:30:17.673772 +00:00,2025-08-28 22:30:17.673772 +00:00,"9150 Deborah Common Suite 693 Wilcoxport, HI 96482",263
1227,2017-07-11 19:37:21.947664 +00:00,2017-09-06 01:37:21.947664 +00:00,"4881 Fernandez Coves Apt. 864 Lake Michael, FM 04195",263
1228,2023-11-01 10:17:18.137445 +00:00,2024-01-29 14:17:18.137445 +00:00,"01883 Mary Dale Apt. 221 North Kenneth, RI 33740",263
1229,2025-08-29 14:53:04.887633 +00:00,,"23712 Elizabeth Fields Suite 151 North Amy, VA 29130",263
1230,2025-08-29 02:01:49.727452 +00:00,,"5905 Edwards Crossroad West Jacobstad, MH 88081",263
1231,2017-08-15 04:02:55.224740 +00:00,2017-10-06 11:02:55.224740 +00:00,"704 Jenkins Mission Apt. 782 East Monica, NJ 96489",263
1232,2025-09-08 02:48:58.311452 +00:00,,"67056 Amanda Mountains Suite 743 Christopherton, OR 19081",264
1233,2025-07-07 04:48:17.503468 +00:00,2025-08-30 13:48:17.503468 +00:00,"1988 Michael Expressway Apt. 530 North Troyville, IL 89973",264
1234,2015-03-20 11:35:49.511650 +00:00,2015-05-19 16:35:49.511650 +00:00,"1366 Mark Knolls Apt. 448 West Linda, OR 92627",264
1235,2011-04-11 20:19:38.853057 +00:00,2011-05-26 05:19:38.853057 +00:00,"6937 Larson Mountain Suite 544 Port Dylan, KS 23153",264
1236,2025-10-04 06:59:34.382777 +00:00,,"31050 Nicole Field Apt. 912 Benjaminburgh, TN 53639",264
1237,2014-07-23 20:04:02.053659 +00:00,2014-08-03 06:04:02.053659 +00:00,"23200 Wiggins Rest Suite 890 West Vickie, TX 17280",264
1238,2025-09-27 00:40:03.996747 +00:00,,"2744 Bowen Brook Apt. 672 Emmashire, LA 04302",264
1239,2024-11-30 05:20:28.381212 +00:00,2024-12-05 10:20:28.381212 +00:00,"7224 Kimberly Trail Apt. 158 Carrmouth, OK 51890",264
1240,2025-09-19 11:17:01.445068 +00:00,,"68873 Michelle Unions Morafurt, RI 89258",265
1241,2014-06-24 04:05:25.837444 +00:00,2014-08-04 05:05:25.837444 +00:00,"56737 Kristen Canyon Apt. 381 Wardshire, MA 06076",265
1242,2015-07-13 04:08:36.332294 +00:00,2015-09-02 05:08:36.332294 +00:00,"592 Pope Centers Bowmanton, NY 54157",265
1243,2012-07-09 21:45:24.012869 +00:00,2012-08-01 19:45:24.012869 +00:00,"214 Linda Rest South Danielmouth, IL 41176",265
1244,2015-08-23 14:33:48.018722 +00:00,2015-10-04 21:33:48.018722 +00:00,"07404 Laura Vista Gabrielafurt, MN 81385",265
1245,2023-11-23 15:26:45.273876 +00:00,2023-12-29 16:26:45.273876 +00:00,"7233 Hull Pike Sharonland, HI 05424",265
1246,2025-09-12 23:41:39.909068 +00:00,,USCGC Holt FPO AE 23351,265
1247,2016-09-19 07:36:18.735142 +00:00,2016-09-24 02:36:18.735142 +00:00,"75499 Young Stream Santanaburgh, LA 57708",266
1248,2019-05-02 20:04:13.177331 +00:00,2019-08-03 08:04:13.177331 +00:00,"PSC 4522, Box 0161 APO AA 44910",266
1249,2019-11-06 04:54:21.896860 +00:00,2019-11-22 05:54:21.896860 +00:00,"877 Rogers Mission Lake Chelseaport, HI 56391",266
1250,2014-06-03 13:56:29.431072 +00:00,2014-08-15 11:56:29.431072 +00:00,"7414 Adam Fords Barbarastad, AS 04758",266
1251,2013-11-28 21:57:50.684903 +00:00,2014-02-11 21:57:50.684903 +00:00,"146 Alvarez Parkway Cynthiamouth, CT 51249",266
1252,2016-09-21 04:41:03.371067 +00:00,2016-11-30 04:41:03.371067 +00:00,"71781 Lacey Light Lake Michael, WI 95582",266
1253,2020-08-29 13:17:21.522735 +00:00,2020-09-21 21:17:21.522735 +00:00,"0194 Cooke Villages Cynthiaton, OH 94750",266
1254,2012-09-19 23:26:09.578206 +00:00,2012-12-07 17:26:09.578206 +00:00,"3527 Smith Drives Cunninghamport, NM 15287",267
1255,2020-01-08 10:26:10.521133 +00:00,2020-04-02 10:26:10.521133 +00:00,"PSC 6103, Box 7874 APO AA 41651",267
1256,2019-01-23 01:46:34.802249 +00:00,2019-03-22 19:46:34.802249 +00:00,"427 Jane Radial Suite 846 Peterstad, OR 45601",267
1257,2010-11-24 02:59:01.565321 +00:00,2011-01-07 11:59:01.565321 +00:00,"8314 Griffin Rest Port Adamtown, MT 89431",267
1258,2022-11-28 12:46:31.096411 +00:00,2022-12-14 03:46:31.096411 +00:00,"825 Tyler Vista Suite 709 West Patricia, MS 46468",267
1259,2014-11-06 14:24:59.747297 +00:00,2014-11-29 07:24:59.747297 +00:00,"30870 Wilson Dale Brendanland, MS 82184",267
1260,2025-08-22 09:13:45.262174 +00:00,,"8948 Whitehead Path Apt. 872 Wilkersonmouth, OK 74594",268
1261,2022-10-11 01:24:44.695733 +00:00,2022-12-04 15:24:44.695733 +00:00,Unit 1774 Box 7841 DPO AP 95460,268
1262,2025-07-08 11:03:33.822611 +00:00,2025-07-18 21:03:33.822611 +00:00,"953 Brandy Tunnel Apt. 901 Lake Kristaton, DE 50474",268
1263,2015-05-09 06:06:31.834274 +00:00,2015-05-27 14:06:31.834274 +00:00,"68387 Duncan Land Suite 618 North Kristen, TN 30773",269
1264,2025-01-01 19:24:31.921932 +00:00,2025-01-13 16:24:31.921932 +00:00,"030 Ross Gardens Lucaschester, MH 97189",269
1265,2023-11-01 19:16:20.996165 +00:00,2023-11-18 06:16:20.996165 +00:00,"696 Janice Dale Boydbury, WV 39014",269
1266,2015-04-19 16:47:59.291775 +00:00,2015-07-05 13:47:59.291775 +00:00,"8575 Hannah Squares Michaelstad, NE 19370",269
1267,2025-09-07 06:34:11.289723 +00:00,,"037 John Stravenue Suite 974 Angelatown, GA 58849",269
1268,2014-11-18 11:28:52.610935 +00:00,2015-02-02 02:28:52.610935 +00:00,"7001 Rachel Trafficway Orrfurt, NY 86769",269
1269,2022-08-24 11:55:24.616557 +00:00,2022-11-01 05:55:24.616557 +00:00,"00835 Mathews Glen Apt. 950 Bentonbury, OH 94184",270
1270,2014-01-22 00:49:21.882782 +00:00,2014-04-17 15:49:21.882782 +00:00,"834 Jose Prairie Lake Bridgetport, MT 06152",270
1271,2015-05-20 02:22:47.218909 +00:00,2015-08-18 07:22:47.218909 +00:00,"58978 Elliott Crossing Port Bridget, GU 78080",271
1272,2025-09-20 22:52:44.936023 +00:00,,"1833 Bruce Brooks Port Todd, NY 85268",271
1273,2021-10-11 02:26:22.959559 +00:00,2021-12-23 00:26:22.959559 +00:00,"3721 Hunt Canyon Apt. 027 Richardtown, MH 93831",271
1274,2025-09-14 22:55:14.826029 +00:00,,"282 Alexandra Village Meganton, NM 53087",272
1275,2025-07-11 21:06:33.427141 +00:00,2025-09-13 20:06:33.427141 +00:00,"62199 Franklin Fords Apt. 494 West Jennifer, NY 47439",273
1276,2023-01-05 06:38:35.137934 +00:00,2023-01-09 10:38:35.137934 +00:00,"1930 Jeffrey Spring Apt. 603 Priceside, PR 30194",273
1277,2017-05-20 00:25:19.782152 +00:00,2017-08-12 14:25:19.782152 +00:00,"54330 Ryan Locks Apt. 808 Kelleyville, UT 45286",273
1278,2025-08-09 02:30:52.269428 +00:00,2025-09-29 18:30:52.269428 +00:00,"75667 Turner Hollow Samuelchester, MP 03446",273
1279,2024-07-08 02:39:52.620700 +00:00,2024-07-09 03:39:52.620700 +00:00,"5226 Miller Drive Suite 964 Lewisfort, MS 44104",273
1280,2014-09-02 22:52:10.078669 +00:00,2014-10-24 09:52:10.078669 +00:00,"6061 Denise Parkways Prestonmouth, MD 62448",273
1281,2025-07-19 06:14:02.497808 +00:00,2025-09-23 12:14:02.497808 +00:00,"97280 Byrd Plains New Tara, AR 27470",273
1282,2025-09-19 17:46:07.312142 +00:00,,"04360 Long Summit Apt. 153 Brownburgh, MO 25264",274
1283,2024-06-14 12:28:23.070234 +00:00,2024-06-30 03:28:23.070234 +00:00,"130 Le Vista Warnerfurt, HI 71259",274
1284,2014-03-08 11:51:31.011604 +00:00,2014-06-02 07:51:31.011604 +00:00,Unit 9832 Box 3639 DPO AE 17619,274
1285,2021-02-02 20:18:37.100714 +00:00,2021-04-03 20:18:37.100714 +00:00,"4013 Frey Coves Tanyaview, IA 19518",274
1286,2022-06-26 14:26:08.856666 +00:00,2022-08-29 23:26:08.856666 +00:00,"04220 Kemp Mountains North Kim, FL 36602",275
1287,2013-01-23 21:33:03.157140 +00:00,2013-04-22 15:33:03.157140 +00:00,"72797 Robert Drive Baileyside, AR 93892",275
1288,2025-10-04 07:22:08.342730 +00:00,,"29507 Robinson Falls Evansburgh, CO 92844",275
1289,2020-09-29 00:26:00.883417 +00:00,2020-12-05 17:26:00.883417 +00:00,"6032 Brown Rapids Woodstown, MP 91245",275
1290,2025-07-01 10:36:26.953959 +00:00,2025-08-07 02:36:26.953959 +00:00,"77363 Martin Station Melissaburgh, CA 63364",275
1291,2013-03-31 09:12:34.660643 +00:00,2013-04-11 05:12:34.660643 +00:00,"19872 Sawyer Manor Apt. 537 East Oscar, IN 27670",275
1292,2013-05-21 20:18:24.361732 +00:00,2013-08-15 11:18:24.361732 +00:00,"53993 Angela Port New Debra, NJ 29948",276
1293,2018-02-15 16:12:49.496395 +00:00,2018-02-26 22:12:49.496395 +00:00,"2769 Lisa Crossing East David, WV 38205",276
1294,2010-02-10 19:54:50.822422 +00:00,2010-04-19 22:54:50.822422 +00:00,"171 Elizabeth Flats Apt. 417 Smithmouth, IN 50564",276
1295,2022-02-12 18:13:32.613424 +00:00,2022-05-08 03:13:32.613424 +00:00,"043 Miller Estates Lake Mark, MS 75875",276
1372,2025-09-24 22:00:39.569278 +00:00,,"498 Andrew Lane Phillipberg, OH 28756",293
1296,2024-11-28 16:56:14.371481 +00:00,2025-02-20 10:56:14.371481 +00:00,"07418 Mayer Stream Suite 128 Cassandraburgh, SC 54046",276
1297,2014-04-08 17:37:53.575344 +00:00,2014-06-05 10:37:53.575344 +00:00,"5140 Manuel Mountains Stephaniemouth, FM 44689",276
1298,2020-05-13 06:19:46.568417 +00:00,2020-05-28 16:19:46.568417 +00:00,"496 Graham Fork Suite 353 Hinesstad, VI 50908",277
1299,2012-06-13 10:30:44.247431 +00:00,2012-09-13 02:30:44.247431 +00:00,Unit 8595 Box 2458 DPO AE 11928,277
1300,2016-01-15 17:04:21.072902 +00:00,2016-04-11 19:04:21.072902 +00:00,"759 Bender Mission Suite 033 Murraymouth, FL 39890",277
1301,2012-03-24 17:16:33.533733 +00:00,2012-04-03 02:16:33.533733 +00:00,"PSC 4107, Box 6905 APO AE 72039",277
1302,2025-09-27 03:51:28.273869 +00:00,,Unit 5438 Box 6051 DPO AE 97890,278
1303,2012-02-22 15:54:15.912519 +00:00,2012-04-09 17:54:15.912519 +00:00,"650 David Loop Apt. 110 Murrayfort, ME 64251",279
1304,2018-10-14 06:57:28.282208 +00:00,2018-10-22 19:57:28.282208 +00:00,"75505 Colleen Dam Lake Victoria, OR 33292",279
1305,2025-08-12 09:44:48.318715 +00:00,2025-09-30 08:44:48.318715 +00:00,"74563 John Island North Wyatt, NM 59033",279
1306,2013-03-15 11:58:05.500299 +00:00,2013-05-29 01:58:05.500299 +00:00,"434 Richard Lock Brownburgh, GA 61634",279
1307,2011-01-21 10:45:39.042719 +00:00,2011-04-30 19:45:39.042719 +00:00,Unit 4065 Box 0601 DPO AP 26354,279
1308,2015-11-03 11:30:45.635632 +00:00,2015-11-15 23:30:45.635632 +00:00,"336 Brewer Fields Apt. 003 Port Deborahport, OR 97663",280
1309,2011-03-17 08:29:28.971376 +00:00,2011-05-20 07:29:28.971376 +00:00,"192 Mitchell Mountains New Nicolemouth, NC 65473",280
1310,2017-09-20 16:13:45.834492 +00:00,2017-12-28 00:13:45.834492 +00:00,"5299 Horton Corner Apt. 346 Christophertown, MS 97250",280
1311,2025-07-27 16:38:02.993175 +00:00,,"489 Brown Forge West Michaelbury, KS 43258",280
1312,2025-08-19 06:33:33.630697 +00:00,2025-08-24 11:33:33.630697 +00:00,"379 Daniel Shoal Jeffreyborough, MS 89545",280
1313,2025-08-14 21:07:39.813857 +00:00,2025-08-15 22:07:39.813857 +00:00,"891 Reynolds Squares Riversport, AL 33841",281
1314,2012-12-15 17:44:06.483021 +00:00,2013-03-07 14:44:06.483021 +00:00,"1603 Morgan Field Suite 049 East Jill, WV 75019",281
1315,2024-04-25 04:50:59.933120 +00:00,2024-06-01 11:50:59.933120 +00:00,USNS Chavez FPO AA 72121,281
1316,2013-10-22 00:06:29.352487 +00:00,2013-11-16 15:06:29.352487 +00:00,"550 Myers Ridge North Christinamouth, ME 70289",281
1317,2017-11-05 18:03:59.751462 +00:00,2018-01-18 07:03:59.751462 +00:00,"5841 Eric Points Williamsmouth, WA 34345",281
1318,2012-09-25 06:56:08.012153 +00:00,2013-01-01 09:56:08.012153 +00:00,"PSC 4190, Box 6835 APO AP 03410",281
1319,2013-10-16 01:28:14.697684 +00:00,2013-10-24 09:28:14.697684 +00:00,"4718 Campbell Key Suite 958 East Joshua, TN 01454",281
1320,2014-08-28 01:09:37.200190 +00:00,2014-11-27 12:09:37.200190 +00:00,"09509 Felicia Vista East Daniellebury, ND 44978",282
1321,2022-05-19 06:53:36.599304 +00:00,2022-05-22 04:53:36.599304 +00:00,"9035 Diaz Expressway Apt. 056 North Michael, VA 52488",282
1322,2025-08-19 17:03:31.956882 +00:00,,"043 Gary Turnpike Suite 999 Christymouth, MD 74402",282
1323,2011-09-19 23:51:33.315216 +00:00,2011-10-27 06:51:33.315216 +00:00,"631 Cameron Square East Travis, VI 15367",282
1324,2023-11-14 14:44:47.284710 +00:00,2024-01-21 12:44:47.284710 +00:00,"02351 Chase Valleys Port Jacob, AL 52024",282
1325,2021-02-12 16:35:03.420356 +00:00,2021-05-04 22:35:03.420356 +00:00,"12638 King Coves North Cathy, LA 40151",282
1326,2013-08-14 17:59:35.475626 +00:00,2013-08-31 04:59:35.475626 +00:00,"PSC 4728, Box 1052 APO AA 46730",283
1327,2025-08-09 19:50:26.447331 +00:00,2025-09-01 02:50:26.447331 +00:00,Unit 2470 Box 3324 DPO AE 08347,283
1328,2010-09-20 03:44:11.328314 +00:00,2010-10-20 08:44:11.328314 +00:00,"6104 Harry Bypass West Raymondtown, VT 46083",283
1329,2025-07-10 08:51:14.859617 +00:00,2025-08-01 00:51:14.859617 +00:00,"205 Julia Gateway Apt. 881 Lake Sarahfort, UT 03078",283
1330,2015-09-04 03:13:42.178329 +00:00,2015-12-01 01:13:42.178329 +00:00,"1942 Peggy Ville Apt. 261 North Tylerberg, WY 10512",283
1331,2022-11-09 19:28:49.470831 +00:00,2023-01-01 07:28:49.470831 +00:00,"876 Ross Stravenue Ericport, NC 07906",283
1332,2025-09-05 15:21:58.578199 +00:00,,"60273 Taylor Fall West Kurthaven, CA 16782",283
1333,2017-09-09 04:47:52.607428 +00:00,2017-12-11 17:47:52.607428 +00:00,"688 Bethany Brooks Apt. 634 Zhangberg, LA 41491",283
1334,2019-06-01 17:48:20.416748 +00:00,2019-08-08 10:48:20.416748 +00:00,"7430 Morales Mill East Tammiehaven, WA 16741",284
1335,2015-08-13 02:23:23.336904 +00:00,2015-10-09 19:23:23.336904 +00:00,"495 Robbins Inlet New Thomaschester, CO 87076",284
1336,2011-07-19 15:54:30.263902 +00:00,2011-09-18 21:54:30.263902 +00:00,"2328 Terri Orchard Apt. 590 North Dominiqueshire, NM 21274",284
1337,2012-06-08 07:43:18.042441 +00:00,2012-07-10 19:43:18.042441 +00:00,"43843 Bishop Land North Antoniobury, NY 80919",284
1338,2025-08-08 03:29:46.486266 +00:00,,"61078 Crawford Street Apt. 067 New Sara, CO 89452",284
1339,2011-04-17 17:27:39.494341 +00:00,2011-06-09 20:27:39.494341 +00:00,"82770 Sheri Ferry East Ronaldland, VI 13858",285
1340,2024-07-15 17:16:35.347074 +00:00,2024-08-10 23:16:35.347074 +00:00,"PSC 3399, Box 1219 APO AE 12586",285
1341,2025-09-12 21:06:34.127824 +00:00,,"37577 Weaver Heights Jonesport, TX 99108",285
1342,2023-01-09 18:00:51.618040 +00:00,2023-03-19 12:00:51.618040 +00:00,"5682 Church Lakes Port Catherine, OH 54065",285
1343,2025-03-05 14:40:39.692401 +00:00,2025-05-06 11:40:39.692401 +00:00,"7874 Ortiz Mews Suite 534 Vanceburgh, GU 11651",285
1344,2025-09-19 22:54:28.414954 +00:00,2025-09-29 07:54:28.414954 +00:00,"7174 Lopez Locks Apt. 385 Christineville, MO 47788",285
1345,2023-01-07 03:27:37.753457 +00:00,2023-02-07 19:27:37.753457 +00:00,"3559 Ewing Corner Apt. 480 South Robert, NC 86150",286
1346,2025-01-05 10:33:11.095142 +00:00,2025-04-13 08:33:11.095142 +00:00,"97327 Erica Overpass Suite 550 Marctown, TN 86083",286
1347,2014-10-28 05:29:32.114825 +00:00,2015-01-09 03:29:32.114825 +00:00,"151 Joseph Manors Suite 505 Justinhaven, KS 92580",287
1348,2019-06-08 07:16:12.627824 +00:00,2019-09-09 00:16:12.627824 +00:00,"101 Patel Fields Suite 320 Traceymouth, OK 15337",287
1349,2023-06-11 03:05:30.414710 +00:00,2023-08-14 22:05:30.414710 +00:00,"68854 Sheryl Tunnel Sydneyhaven, MH 60167",287
1350,2017-04-29 01:28:06.758612 +00:00,2017-05-17 09:28:06.758612 +00:00,"15879 Crawford Square Apt. 794 South Cameronville, NY 52210",287
1351,2020-03-15 20:59:44.361335 +00:00,2020-06-09 11:59:44.361335 +00:00,"PSC 5328, Box 9847 APO AA 78866",287
1352,2016-08-11 07:30:54.303687 +00:00,2016-10-29 01:30:54.303687 +00:00,"265 Gina Forest Clarkland, WY 52459",287
1353,2025-07-20 10:15:02.460476 +00:00,2025-09-02 04:15:02.460476 +00:00,"9875 Walsh Springs Austinchester, AK 35370",287
1354,2025-08-02 03:25:47.432020 +00:00,,"612 Julie Via Suite 698 Paulchester, PA 74654",287
1355,2010-11-09 10:49:57.744570 +00:00,2010-11-22 08:49:57.744570 +00:00,"8166 Mark Glen North Shellybury, IA 21713",288
1356,2024-05-31 08:24:16.743878 +00:00,2024-06-12 10:24:16.743878 +00:00,"9048 John Vista Wilsonmouth, DC 18472",289
1357,2021-04-01 22:24:28.519661 +00:00,2021-04-10 06:24:28.519661 +00:00,"01853 Beth Street Apt. 921 Lake Robert, FL 42803",289
1358,2025-07-08 20:31:47.887015 +00:00,2025-08-25 18:31:47.887015 +00:00,USCGC Mcfarland FPO AE 07773,289
1359,2023-02-19 06:18:22.065444 +00:00,2023-04-14 05:18:22.065444 +00:00,USS Wright FPO AE 89832,289
1360,2012-10-03 13:25:31.441034 +00:00,2012-10-22 02:25:31.441034 +00:00,"0988 Gordon Parks Lake Christopher, DE 25612",290
1361,2016-11-16 17:04:56.101871 +00:00,2017-01-18 00:04:56.101871 +00:00,"115 Tara Oval Suite 422 Port Tanner, TX 26607",290
1362,2025-07-07 03:36:27.743294 +00:00,2025-09-28 21:36:27.743294 +00:00,"6896 Paul Fall Suite 738 Kennethburgh, MA 45172",290
1363,2025-07-21 13:24:20.620699 +00:00,2025-08-23 11:24:20.620699 +00:00,"754 Wilkins Bridge Suite 974 Lake Corey, IN 62465",290
1364,2010-04-21 12:44:45.339161 +00:00,2010-07-20 12:44:45.339161 +00:00,"290 Annette Corners Richardsland, AS 43027",291
1365,2025-09-17 19:42:16.331219 +00:00,,"79722 Casey Ramp Suite 967 East Meganhaven, MD 86743",291
1366,2012-01-22 13:03:32.683891 +00:00,2012-02-15 02:03:32.683891 +00:00,"460 Bailey Points East Bernard, MT 98394",291
1367,2010-08-08 16:38:21.447083 +00:00,2010-11-02 02:38:21.447083 +00:00,"2550 Matthew Court Apt. 863 North Karenside, VA 10351",291
1368,2021-11-23 01:53:28.442330 +00:00,2022-02-13 08:53:28.442330 +00:00,"385 Cynthia Parkways West Paulhaven, DE 86765",291
1369,2024-05-01 17:18:08.419815 +00:00,2024-07-31 08:18:08.419815 +00:00,"7181 Glover Expressway Apt. 372 Sarahshire, MO 16573",291
1370,2014-01-11 04:45:30.638668 +00:00,2014-04-05 23:45:30.638668 +00:00,"48889 Amanda Falls Apt. 365 Lake Carol, WY 58486",292
1371,2016-10-28 10:46:32.466746 +00:00,2016-12-22 05:46:32.466746 +00:00,"562 Scott Prairie North Kyleland, MI 52828",293
1373,2025-10-04 04:58:31.541307 +00:00,,USNV Brown FPO AP 72154,293
1374,2025-08-15 14:21:32.772004 +00:00,2025-09-02 12:21:32.772004 +00:00,"9477 Diaz Radial Suite 246 Lake Coltonberg, MD 43631",293
1375,2014-10-10 14:51:19.787259 +00:00,2014-10-29 18:51:19.787259 +00:00,USS Davis FPO AA 66042,293
1376,2021-04-06 21:46:09.923972 +00:00,2021-05-17 22:46:09.923972 +00:00,"5467 Guerra Mall Suite 555 Jeremyfurt, AS 29716",293
1377,2021-06-02 17:12:16.742445 +00:00,2021-06-21 06:12:16.742445 +00:00,"904 Green Viaduct Jenningsberg, AR 81036",294
1378,2025-08-24 02:24:51.070538 +00:00,2025-10-04 18:24:51.070538 +00:00,"51760 Jacqueline Inlet Suite 847 Brandyhaven, IN 72129",294
1379,2025-07-22 19:04:01.173656 +00:00,2025-07-31 13:04:01.173656 +00:00,"291 Erik Ways Charlottetown, TN 18953",294
1380,2022-10-30 06:28:30.068743 +00:00,2023-01-20 13:28:30.068743 +00:00,"7444 John Row Kinghaven, WI 33740",294
1381,2014-01-12 20:15:28.500676 +00:00,2014-04-15 18:15:28.500676 +00:00,Unit 4456 Box 6360 DPO AE 10039,295
1382,2025-09-26 02:38:04.597146 +00:00,,"03340 Rollins Fields Franciscoland, SC 78391",295
1383,2016-03-22 02:07:13.219221 +00:00,2016-05-23 19:07:13.219221 +00:00,"404 Philip Trace New Anthonyton, MD 61140",295
1384,2025-08-21 09:07:36.400661 +00:00,2025-09-02 11:07:36.400661 +00:00,"7124 Roberts Lodge Apt. 602 East Johnmouth, IN 29585",295
1385,2017-05-10 04:34:18.790415 +00:00,2017-06-15 00:34:18.790415 +00:00,"1203 Fisher Plaza Suite 737 Port Gail, RI 20527",295
1386,2015-09-30 15:07:22.265145 +00:00,2015-12-24 05:07:22.265145 +00:00,"842 Quinn Route Suite 657 Michaelton, MS 53064",295
1387,2010-03-19 18:40:47.541819 +00:00,2010-06-25 21:40:47.541819 +00:00,"6377 Pope Greens North Ritaburgh, MN 61612",295
1388,2014-05-27 23:51:44.918548 +00:00,2014-06-06 08:51:44.918548 +00:00,USCGC Ortega FPO AP 15386,296
1389,2015-10-10 18:31:00.577770 +00:00,2015-11-03 12:31:00.577770 +00:00,Unit 7396 Box 9918 DPO AP 11735,296
1390,2025-09-19 17:31:26.918709 +00:00,,"7578 Snyder Bridge Apt. 505 Lake Loganton, FM 83590",296
1391,2025-03-29 23:24:35.268504 +00:00,2025-03-31 20:24:35.268504 +00:00,"18816 Jennifer Shoal Smithhaven, MP 33776",296
1392,2025-07-28 15:28:28.471940 +00:00,2025-08-08 01:28:28.471940 +00:00,"56731 Pierce Path East Blake, NV 66044",296
1393,2010-10-22 10:32:44.341357 +00:00,2011-01-01 21:32:44.341357 +00:00,"9541 Watkins Gardens Suite 302 Williamberg, IL 34946",296
1394,2025-08-13 16:07:34.321889 +00:00,2025-09-01 20:07:34.321889 +00:00,"634 Suarez Divide Apt. 927 New Briannaborough, GA 80356",296
1395,2016-12-08 08:16:16.587134 +00:00,2017-03-11 01:16:16.587134 +00:00,USNS Riley FPO AA 97493,297
1396,2025-10-04 21:25:48.788181 +00:00,,"977 Walker Hills Suite 941 West Antoniochester, RI 14978",297
1397,2025-09-19 14:55:46.267718 +00:00,2025-09-27 12:55:46.267718 +00:00,"896 Jennifer Pass South Jason, SD 54197",298
1398,2025-09-23 08:59:04.231769 +00:00,,"668 Martinez Road New Ambermouth, HI 57835",298
1399,2023-07-03 07:20:59.802660 +00:00,2023-10-05 06:20:59.802660 +00:00,"77491 Duarte Corners Apt. 711 South Susan, ND 97908",298
1400,2025-08-28 08:26:48.498009 +00:00,,"054 Hall Knoll New Michellebury, ME 61495",298
1401,2025-09-04 07:59:43.850230 +00:00,,"032 Ford Fall Williamfurt, AR 36560",298
1402,2014-04-10 21:32:11.380892 +00:00,2014-06-12 19:32:11.380892 +00:00,"67386 Alice Hill Suite 335 Emilyborough, LA 80860",298
1403,2014-05-04 13:52:10.445605 +00:00,2014-05-31 05:52:10.445605 +00:00,"928 Alexander Spring Jonesmouth, MO 41448",298
1404,2011-12-18 09:22:31.305470 +00:00,2012-02-20 13:22:31.305470 +00:00,"96648 Martinez Heights East Karen, AK 89523",298
1405,2025-09-27 19:31:09.174777 +00:00,,"5631 Solomon Forges Port Wandaberg, WV 29386",299
1406,2014-01-27 09:31:49.362457 +00:00,2014-02-13 16:31:49.362457 +00:00,"15088 Lee Motorway Gregoryside, MD 89965",299
1407,2019-08-27 09:15:25.483463 +00:00,2019-11-27 06:15:25.483463 +00:00,"7750 Ho Spring Gambleshire, TN 79094",299
1408,2010-01-04 19:56:23.420109 +00:00,2010-01-06 16:56:23.420109 +00:00,"PSC 9939, Box 5407 APO AP 24931",299
1409,2025-08-12 00:49:06.779001 +00:00,2025-09-28 12:49:06.779001 +00:00,"6133 Nathan Grove Suite 789 Henrymouth, MO 48273",299
1410,2023-05-06 06:12:30.140532 +00:00,2023-08-10 07:12:30.140532 +00:00,"12641 Richards Junction Suite 460 Macdonaldside, NV 57055",300
1411,2010-04-02 01:49:12.007132 +00:00,2010-06-26 21:49:12.007132 +00:00,"0305 Pope Fort Apt. 190 Hayesland, FM 54569",300
1412,2021-07-21 18:04:48.231041 +00:00,2021-10-12 21:04:48.231041 +00:00,"3459 Brittany Plaza South Aprilton, MH 77989",300
1413,2025-07-08 03:00:32.132316 +00:00,2025-08-28 04:00:32.132316 +00:00,"251 Velasquez Village Apt. 085 Port Tara, TN 13331",300
1414,2019-06-30 21:33:03.440847 +00:00,2019-10-08 01:33:03.440847 +00:00,"2173 Cox Courts Jacksonfurt, DE 63400",300
1415,2015-06-08 23:40:01.174531 +00:00,2015-06-19 04:40:01.174531 +00:00,"348 Kathryn Summit Apt. 074 Jonathanview, VI 42761",300
1416,2018-04-05 17:18:28.694018 +00:00,2018-05-29 21:18:28.694018 +00:00,"00450 Richard Spur Suite 175 Hannahstad, GA 87376",300
\.

-- producto_categoria
COPY public.producto_categoria (id, categoria_id, producto_id) FROM stdin WITH (FORMAT CSV, DELIMITER ',');
1,25,1
2,16,1
3,13,1
4,19,2
5,23,2
6,21,3
7,2,3
8,27,4
9,29,4
10,10,5
11,6,5
12,29,6
13,24,7
14,2,7
15,8,7
16,14,7
17,7,8
18,24,8
19,27,8
20,18,8
21,19,8
22,11,9
23,19,9
24,2,9
25,29,9
26,22,10
27,11,10
28,30,11
29,12,11
30,9,11
31,18,11
32,10,12
33,25,12
34,1,12
35,26,13
36,3,13
37,14,13
38,18,14
39,9,14
40,20,14
41,19,15
42,9,15
43,1,16
44,21,16
45,23,17
46,4,18
47,8,18
48,26,18
49,11,18
50,21,19
51,15,19
52,25,19
53,26,19
54,6,19
55,26,20
56,8,20
57,7,21
58,2,21
59,21,21
60,19,21
61,28,21
62,15,22
63,10,22
64,7,22
65,17,23
66,13,23
67,5,23
68,22,24
69,20,24
70,10,24
71,18,24
72,6,24
73,23,25
74,7,25
75,24,25
76,22,26
77,19,26
78,3,26
79,6,26
80,16,27
81,2,27
82,5,27
83,3,28
84,4,28
85,14,28
86,2,29
87,6,29
88,5,29
89,4,29
90,13,29
91,17,30
92,10,30
93,30,30
94,8,30
95,7,30
96,13,31
97,28,31
98,12,31
99,30,31
100,14,32
101,26,32
102,28,32
103,23,33
104,16,33
105,2,34
106,15,34
107,22,34
108,14,35
109,18,35
110,13,35
111,12,35
112,9,36
113,10,36
114,17,37
115,23,37
116,1,37
117,30,38
118,25,38
119,3,39
120,9,39
121,25,40
122,2,40
123,3,40
124,22,40
125,21,41
126,23,41
127,1,41
128,18,42
129,26,42
130,23,42
131,22,43
132,12,44
133,1,44
134,8,44
135,17,44
136,7,45
137,10,45
138,2,45
139,13,45
140,3,45
141,29,46
142,16,46
143,6,47
144,17,47
145,19,47
146,2,48
147,17,49
148,8,49
149,3,49
150,28,49
151,3,50
152,26,50
153,4,51
154,13,51
155,9,51
156,2,51
157,20,52
158,18,53
159,13,53
160,30,54
161,1,54
162,22,54
163,5,54
164,10,54
165,14,55
166,5,55
167,12,55
168,13,55
169,18,56
170,24,56
171,16,57
172,17,57
173,26,57
174,20,57
175,21,57
176,19,58
177,10,58
178,21,59
179,10,59
180,1,59
181,6,60
182,14,60
183,15,60
184,10,61
185,5,61
186,14,61
187,25,61
188,14,62
189,29,62
190,27,62
191,30,62
192,5,63
193,26,63
194,10,63
195,16,63
196,11,63
197,10,64
198,22,64
199,2,64
200,28,65
201,11,65
202,16,66
203,15,67
204,21,67
205,1,67
206,7,67
207,10,67
208,28,68
209,3,68
210,26,68
211,1,68
212,27,68
213,20,69
214,13,70
215,24,71
216,23,71
217,14,71
218,27,71
219,30,72
220,9,73
221,14,73
222,13,74
223,17,74
224,10,74
225,22,74
226,8,74
227,2,75
228,10,75
229,25,75
230,16,75
231,25,76
232,16,77
233,11,77
234,1,77
235,7,77
236,24,78
237,17,78
238,5,78
239,1,78
240,16,79
241,11,79
242,23,79
243,1,79
244,28,80
245,21,80
246,4,81
247,28,81
248,9,81
249,30,81
250,13,82
251,11,82
252,27,82
253,11,83
254,13,84
255,1,84
256,9,84
257,23,84
258,1,85
259,22,85
260,28,85
261,7,85
262,29,86
263,5,86
264,16,86
265,22,86
266,16,87
267,2,87
268,11,87
269,22,87
270,1,88
271,26,89
272,5,89
273,7,89
274,9,89
275,3,89
276,9,90
277,19,90
278,5,90
279,11,90
280,3,90
281,26,91
282,18,91
283,21,91
284,12,92
285,8,92
286,28,92
287,18,93
288,13,93
289,23,93
290,22,93
291,25,94
292,29,95
293,23,95
294,3,95
295,5,96
296,24,96
297,22,97
298,6,97
299,29,98
300,15,98
301,10,98
302,5,98
303,23,99
304,5,100
305,17,100
306,18,100
307,24,100
308,19,101
309,17,101
310,29,101
311,18,102
312,5,102
313,26,102
314,28,102
315,23,102
316,16,103
317,27,103
318,8,103
319,22,103
320,29,103
321,28,104
322,1,104
323,5,104
324,20,104
325,17,104
326,2,105
327,24,105
328,15,105
329,14,106
330,30,106
331,23,106
332,17,106
333,28,106
334,2,107
335,23,107
336,11,108
337,16,108
338,4,108
339,6,108
340,13,108
341,15,109
342,7,109
343,2,109
344,3,110
345,29,110
346,9,110
347,20,110
348,8,110
349,5,111
350,30,111
351,12,112
352,26,113
353,13,114
354,7,114
355,6,114
356,8,115
357,20,115
358,23,115
359,19,116
360,16,117
361,14,117
362,23,117
363,10,117
364,11,118
365,21,118
366,25,118
367,26,119
368,29,119
369,11,120
370,28,120
371,25,120
372,20,120
373,15,121
374,16,122
375,12,122
376,27,123
377,15,123
378,7,124
379,4,124
380,10,124
381,25,125
382,2,125
383,4,125
384,6,125
385,30,125
386,14,126
387,11,127
388,17,127
389,9,127
390,30,127
391,12,127
392,25,128
393,20,128
394,17,128
395,14,129
396,29,129
397,18,129
398,16,130
399,12,130
400,28,130
401,19,130
402,27,130
403,2,131
404,7,132
405,4,132
406,24,133
407,3,133
408,19,133
409,24,134
410,11,134
411,13,135
412,19,136
413,7,136
414,26,136
415,12,136
416,2,136
417,11,137
418,13,137
419,17,138
420,15,138
421,1,138
422,5,138
423,6,139
424,25,139
425,17,139
426,11,139
427,21,139
428,4,140
429,28,140
430,8,141
431,23,141
432,22,141
433,14,142
434,22,142
435,27,142
436,17,142
437,25,143
438,15,144
439,1,144
440,28,144
441,21,144
442,29,145
443,28,145
444,9,145
445,12,145
446,29,146
447,5,146
448,14,146
449,18,146
450,28,146
451,1,147
452,25,147
453,29,147
454,22,147
455,30,148
456,2,148
457,24,148
458,4,149
459,18,149
460,2,149
461,1,149
462,1,150
463,28,150
464,6,150
465,19,151
466,5,151
467,23,152
468,28,152
469,25,152
470,3,153
471,2,153
472,16,153
473,18,153
474,12,153
475,21,154
476,25,154
477,1,154
478,17,154
479,30,154
480,3,155
481,19,155
482,8,155
483,23,155
484,15,155
485,14,156
486,8,156
487,29,156
488,10,156
489,1,157
490,21,157
491,3,157
492,16,157
493,6,158
494,24,158
495,8,158
496,1,158
497,14,158
498,14,159
499,13,159
500,12,159
501,24,160
502,18,160
503,14,160
504,12,160
505,29,160
506,2,161
507,17,161
508,23,162
509,2,162
510,28,163
511,20,164
512,18,164
513,27,164
514,21,165
515,26,165
516,22,166
517,7,166
518,6,166
519,27,167
520,2,167
521,29,168
522,13,169
523,3,169
524,16,170
525,27,170
526,11,170
527,21,171
528,16,171
529,29,172
530,17,172
531,16,172
532,23,172
533,5,173
534,14,173
535,8,173
536,20,173
537,6,174
538,25,174
539,3,174
540,29,174
541,1,175
542,27,175
543,30,175
544,9,175
545,2,176
546,19,176
547,10,176
548,1,176
549,18,176
550,18,177
551,25,178
552,4,178
553,19,178
554,20,178
555,11,179
556,15,180
557,15,181
558,13,181
559,5,181
560,29,181
561,27,182
562,8,182
563,25,182
564,23,182
565,2,182
566,11,183
567,15,183
568,27,183
569,16,183
570,7,183
571,13,184
572,18,184
573,2,184
574,22,184
575,29,185
576,2,186
577,17,186
578,11,186
579,27,187
580,13,187
581,29,188
582,7,188
583,23,188
584,11,189
585,13,189
586,12,190
587,5,191
588,1,192
589,17,192
590,24,193
591,22,193
592,7,193
593,16,193
594,17,194
595,14,194
596,10,194
597,1,194
598,12,194
599,7,195
600,2,195
601,11,195
602,18,195
603,20,195
604,17,196
605,14,197
606,5,197
607,22,197
608,21,198
609,25,198
610,24,198
611,11,198
612,1,199
613,14,199
614,18,199
615,19,199
616,26,199
617,14,200
618,18,200
619,23,201
620,27,201
621,13,201
622,28,201
623,3,202
624,6,202
625,30,202
626,24,202
627,14,203
628,22,204
629,7,204
630,28,204
631,11,204
632,26,204
633,26,205
634,21,206
635,20,206
636,10,206
637,25,206
638,30,206
639,9,207
640,15,207
641,2,207
642,29,208
643,4,208
644,10,209
645,2,209
646,5,209
647,8,209
648,26,210
649,28,210
650,2,210
651,24,211
652,9,212
653,26,212
654,3,212
655,20,212
656,4,212
657,24,213
658,6,214
659,13,214
660,16,214
661,29,214
662,4,214
663,2,215
664,22,215
665,6,215
666,27,215
667,30,216
668,24,216
669,4,216
670,26,216
671,22,217
672,17,217
673,3,218
674,10,218
675,9,219
676,4,219
677,20,219
678,6,219
679,21,219
680,1,220
681,30,220
682,6,220
683,11,220
684,3,220
685,5,221
686,26,221
687,24,221
688,2,221
689,16,221
690,7,222
691,11,222
692,9,222
693,2,222
694,15,222
695,13,223
696,30,223
697,25,223
698,17,223
699,22,224
700,15,224
701,16,224
702,11,224
703,14,225
704,26,226
705,30,226
706,25,226
707,10,227
708,6,227
709,19,227
710,12,227
711,18,227
712,26,228
713,11,229
714,29,229
715,9,229
716,30,229
717,20,230
718,30,230
719,4,230
720,2,230
721,9,230
722,8,264
723,27,264
724,12,231
725,14,231
726,9,231
727,5,232
728,24,232
729,12,232
730,11,233
731,26,233
732,17,233
733,6,233
734,3,233
735,25,234
736,23,234
737,8,234
738,19,234
739,28,235
740,30,235
741,7,236
742,6,236
743,29,237
744,23,237
745,2,237
746,26,237
747,2,238
748,27,238
749,6,238
750,12,238
751,14,238
752,30,239
753,24,239
754,29,239
755,26,239
756,10,239
757,22,240
758,2,240
759,14,240
760,10,240
761,24,240
762,17,241
763,7,242
764,18,243
765,27,244
766,11,244
767,30,244
768,23,245
769,9,245
770,10,245
771,12,246
772,8,246
773,27,246
774,15,247
775,29,247
776,22,247
777,7,247
778,6,248
779,30,248
780,1,248
781,8,248
782,13,248
783,25,249
784,25,250
785,27,250
786,2,250
787,21,251
788,6,251
789,19,251
790,10,252
791,15,252
792,29,252
793,6,252
794,28,252
795,15,253
796,28,253
797,26,253
798,6,254
799,23,254
800,4,255
801,29,255
802,19,255
803,10,255
804,24,256
805,24,257
806,22,257
807,26,257
808,17,257
809,9,258
810,2,258
811,12,258
812,23,258
813,1,258
814,24,259
815,4,259
816,2,260
817,18,260
818,6,260
819,23,260
820,9,261
821,8,261
822,14,261
823,17,262
824,6,262
825,16,262
826,24,262
827,9,263
828,27,263
829,8,265
830,26,265
831,4,265
832,23,265
833,3,265
834,17,266
835,30,266
836,6,266
837,25,266
838,10,266
839,25,267
840,16,268
841,14,268
842,17,268
843,21,268
844,24,269
845,13,269
846,20,269
847,5,269
848,28,269
849,27,270
850,15,270
851,20,270
852,3,270
853,7,270
854,1,271
855,7,271
856,21,271
857,6,271
858,5,272
859,12,272
860,8,272
861,25,272
862,30,272
863,30,273
864,28,273
865,17,274
866,22,274
867,9,274
868,21,274
869,12,275
870,27,276
871,30,276
872,20,277
873,27,278
874,22,278
875,22,279
876,19,279
877,1,280
878,12,280
879,25,280
880,16,280
881,9,281
882,30,281
883,1,281
884,2,281
885,28,282
886,5,283
887,30,283
888,10,283
889,25,284
890,9,284
891,14,284
892,2,285
893,23,285
894,10,285
895,29,285
896,14,285
897,4,286
898,20,286
899,21,286
900,13,286
901,6,286
902,29,287
903,22,287
904,14,287
905,16,287
906,24,288
907,3,288
908,7,288
909,19,288
910,20,289
911,4,289
912,10,289
913,13,289
914,1,289
915,4,290
916,11,290
917,21,290
918,24,291
919,27,292
920,23,292
921,22,292
922,20,292
923,2,292
924,17,293
925,1,293
926,13,294
927,16,294
928,24,294
929,12,294
930,23,294
931,28,295
932,30,295
933,5,295
934,26,295
935,25,296
936,10,296
937,23,296
938,2,297
939,23,297
940,13,297
941,14,297
942,3,297
943,24,429
944,16,429
945,28,429
946,5,298
947,2,298
948,27,298
949,11,298
950,1,298
951,16,299
952,4,299
953,11,300
954,22,301
955,2,301
956,7,301
957,10,302
958,14,302
959,18,302
960,6,302
961,5,302
962,12,303
963,20,303
964,12,304
965,29,304
966,20,304
967,27,304
968,22,304
969,14,305
970,15,305
971,20,305
972,25,305
973,21,305
974,9,306
975,24,307
976,15,307
977,16,307
978,7,307
979,29,307
980,19,308
981,14,308
982,8,308
983,16,308
984,1,309
985,9,309
986,16,309
987,22,310
988,25,310
989,18,310
990,3,310
991,10,311
992,23,311
993,28,311
994,1,312
995,20,312
996,21,312
997,7,312
998,9,312
999,3,313
1000,25,313
1001,26,314
1002,2,314
1003,7,315
1004,12,315
1005,18,315
1006,21,315
1007,23,316
1008,4,317
1009,23,317
1010,28,317
1011,30,318
1012,5,318
1013,23,318
1014,22,318
1015,3,318
1016,12,319
1017,9,319
1018,6,320
1019,15,320
1020,11,320
1021,21,321
1022,22,321
1023,14,321
1024,8,321
1025,6,322
1026,19,322
1027,7,322
1028,1,322
1029,21,323
1030,22,323
1031,20,323
1032,18,324
1033,25,324
1034,12,324
1035,24,324
1036,26,324
1037,6,325
1038,7,326
1039,5,326
1040,4,326
1041,22,327
1042,11,328
1043,13,328
1044,7,328
1045,1,329
1046,21,330
1047,22,330
1048,3,330
1049,11,331
1050,12,332
1051,18,332
1052,11,333
1053,18,333
1054,20,333
1055,19,333
1056,29,333
1057,9,334
1058,16,334
1059,1,334
1060,6,334
1061,3,334
1062,19,335
1063,5,335
1064,20,336
1065,10,336
1066,30,337
1067,19,337
1068,18,337
1069,15,337
1070,25,338
1071,17,338
1072,10,338
1073,3,339
1074,28,339
1075,21,339
1076,18,340
1077,5,340
1078,9,340
1079,29,341
1080,23,342
1081,29,342
1082,15,343
1083,10,343
1084,19,344
1085,30,344
1086,11,344
1087,22,344
1088,5,345
1089,28,345
1090,29,345
1091,12,345
1092,9,346
1093,15,346
1094,21,346
1095,22,347
1096,11,347
1097,16,347
1098,3,348
1099,10,349
1100,9,349
1101,3,349
1102,6,349
1103,16,350
1104,9,351
1105,24,351
1106,8,351
1107,30,351
1108,13,352
1109,20,352
1110,15,352
1111,9,352
1112,14,353
1113,4,353
1114,13,353
1115,17,353
1116,25,353
1117,9,354
1118,4,354
1119,1,354
1120,5,354
1121,29,354
1122,10,355
1123,16,355
1124,9,356
1125,7,356
1126,11,356
1127,30,356
1128,28,357
1129,9,357
1130,24,357
1131,18,358
1132,9,358
1133,30,358
1134,29,358
1135,14,359
1136,20,359
1137,25,359
1138,28,359
1139,23,359
1140,4,360
1141,19,361
1142,15,362
1143,29,362
1144,7,362
1145,22,362
1146,20,362
1147,4,363
1148,5,363
1149,10,363
1150,20,363
1151,21,364
1152,1,364
1153,8,365
1154,20,365
1155,27,365
1156,16,365
1157,29,365
1158,20,366
1159,16,366
1160,18,366
1161,26,366
1162,9,367
1163,21,367
1164,28,367
1165,28,368
1166,8,368
1167,22,368
1168,21,368
1169,16,368
1170,11,369
1171,18,369
1172,29,369
1173,30,369
1174,9,369
1175,24,370
1176,28,370
1177,18,370
1178,12,370
1179,16,370
1180,18,371
1181,3,372
1182,22,372
1183,29,372
1184,5,372
1185,21,372
1186,19,373
1187,7,373
1188,26,374
1189,2,374
1190,29,374
1191,13,375
1192,17,375
1193,25,375
1194,30,376
1195,1,376
1196,26,377
1197,17,378
1198,29,378
1199,24,379
1200,12,379
1201,16,379
1202,2,379
1203,18,379
1204,20,380
1205,6,380
1206,14,380
1207,11,380
1208,17,380
1209,3,381
1210,2,381
1211,25,381
1212,26,381
1213,29,381
1214,26,382
1215,20,382
1216,6,382
1217,16,383
1218,11,383
1219,26,383
1220,27,383
1221,24,384
1222,26,384
1223,8,384
1224,4,384
1225,2,384
1226,4,385
1227,18,385
1228,25,385
1229,24,385
1230,23,386
1231,2,386
1232,11,387
1233,2,387
1234,22,388
1235,17,388
1236,11,388
1237,14,388
1238,3,388
1239,6,389
1240,4,389
1241,7,389
1242,21,390
1243,13,390
1244,15,390
1245,26,390
1246,16,391
1247,25,391
1248,25,392
1249,7,392
1250,9,392
1251,24,393
1252,30,394
1253,28,394
1254,24,394
1255,25,394
1256,26,395
1257,25,395
1258,13,395
1259,30,395
1260,26,396
1261,28,396
1262,30,396
1263,14,396
1264,16,396
1265,23,397
1266,28,397
1267,18,398
1268,6,399
1269,24,399
1270,30,399
1271,1,400
1272,30,400
1273,24,401
1274,6,401
1275,5,401
1276,23,402
1277,19,402
1278,1,402
1279,27,402
1280,22,403
1281,10,403
1282,18,404
1283,8,405
1284,27,405
1285,24,405
1286,11,406
1287,28,407
1288,19,407
1289,2,407
1290,18,408
1291,22,409
1292,26,409
1293,30,410
1294,5,410
1295,14,410
1296,9,410
1297,6,410
1298,19,411
1299,5,411
1300,10,411
1301,9,411
1302,1,411
1303,9,412
1304,11,412
1305,30,412
1306,25,413
1307,9,413
1308,2,413
1309,17,414
1310,14,414
1311,5,414
1312,28,414
1313,3,414
1314,21,415
1315,5,416
1316,8,416
1317,26,416
1318,15,416
1319,27,416
1320,14,417
1321,20,418
1322,7,418
1323,8,418
1324,28,418
1325,1,418
1326,30,419
1327,9,419
1328,23,420
1329,25,420
1330,1,420
1331,8,421
1332,25,421
1333,3,421
1334,13,421
1335,4,422
1336,1,422
1337,30,422
1338,12,423
1339,13,423
1340,24,423
1341,30,423
1342,25,424
1343,6,424
1344,21,424
1345,4,424
1346,12,425
1347,27,425
1348,10,425
1349,16,425
1350,30,425
1351,14,426
1352,9,426
1353,5,426
1354,15,427
1355,24,428
1356,25,430
1357,3,430
1358,5,430
1359,29,430
1360,14,430
1361,10,431
1362,14,431
1363,10,432
1364,16,432
1365,14,433
1366,29,434
1367,9,434
1368,13,434
1369,2,434
1370,30,434
1371,5,435
1372,24,435
1373,2,436
1374,30,437
1375,18,437
1376,4,438
1377,6,438
1378,26,438
1379,23,439
1380,18,439
1381,6,440
1382,3,440
1383,10,441
1384,21,441
1385,11,441
1386,2,441
1387,24,442
1388,12,442
1389,16,442
1390,2,442
1391,8,442
1392,23,443
1393,13,443
1394,1,443
1395,24,443
1396,25,443
1397,17,444
1398,25,444
1399,24,444
1400,5,445
1401,12,445
1402,23,446
1403,28,447
1404,7,447
1405,25,447
1406,15,448
1407,10,448
1408,1,448
1409,12,448
1410,11,448
1411,15,449
1412,29,449
1413,9,449
1414,19,449
1415,28,449
1416,1,450
1417,15,450
1418,9,450
1419,27,450
1420,18,450
1421,25,451
1422,3,451
1423,14,451
1424,12,452
1425,4,452
1426,20,452
1427,12,453
1428,22,453
1429,8,453
1430,20,454
1431,16,454
1432,1,455
1433,23,455
1434,1,456
1435,8,456
1436,2,456
1437,10,456
1438,19,456
1439,22,457
1440,30,457
1441,23,457
1442,8,457
1443,4,458
1444,22,458
1445,24,459
1446,21,460
1447,25,460
1448,25,461
1449,8,461
1450,7,461
1451,15,461
1452,22,462
1453,1,462
1454,12,462
1455,6,462
1456,1,463
1457,18,463
1458,13,463
1459,19,463
1460,30,463
1461,13,464
1462,27,464
1463,3,464
1464,1,465
1465,11,465
1466,23,465
1467,22,465
1468,21,465
1469,23,466
1470,19,466
1471,21,466
1472,13,467
1473,4,467
1474,2,467
1475,16,468
1476,26,468
1477,13,468
1478,29,468
1479,22,469
1480,7,469
1481,8,469
1482,5,469
1483,15,469
1484,28,470
1485,20,470
1486,3,470
1487,11,470
1488,22,470
1489,25,471
1490,2,472
1491,19,472
1492,23,472
1493,10,472
1494,25,472
1495,20,473
1496,14,473
1497,20,474
1498,22,475
1499,28,476
1500,30,476
1501,8,476
1502,1,476
1503,10,477
1504,16,477
1505,4,477
1506,14,477
1507,8,477
1508,9,478
1509,3,478
1510,16,478
1511,4,479
1512,19,479
1513,3,480
1514,16,480
1515,26,481
1516,8,482
1517,16,482
1518,23,483
1519,27,483
1520,19,483
1521,17,483
1522,24,484
1523,5,485
1524,19,486
1525,7,486
1526,25,487
1527,1,488
1528,7,488
1529,22,488
1530,25,488
1531,10,488
1532,15,489
1533,16,490
1534,3,490
1535,21,490
1536,20,491
1537,6,491
1538,2,491
1539,28,491
1540,26,491
1541,30,492
1542,16,492
1543,23,492
1544,7,493
1545,13,493
1546,1,493
1547,3,493
1548,8,494
1549,20,494
1550,12,494
1551,14,494
1552,21,495
1553,18,495
1554,17,495
1555,18,496
1556,4,496
1557,9,496
1558,19,497
1559,17,497
1560,20,497
1561,15,498
1562,4,498
1563,25,499
1564,8,499
1565,27,499
1566,30,499
1567,7,500
1568,2,500
1569,3,500
1570,14,500
\.

-- producto_orden
COPY public.producto_orden (id, cantidad, orden_id, producto_id) FROM stdin WITH (FORMAT CSV, DELIMITER ',');
1,14,1,101
2,5,1,191
3,8,1,252
4,11,2,285
5,20,2,194
6,6,2,453
7,5,2,300
8,19,2,36
9,19,3,229
10,20,3,462
11,8,3,21
12,12,4,100
13,6,5,145
14,16,5,270
15,2,5,76
16,16,5,142
17,9,5,367
18,7,6,224
19,18,6,319
20,6,6,239
21,17,7,302
22,19,7,225
23,7,7,488
24,19,7,218
25,1,7,142
26,4,7,75
27,1,7,308
28,14,7,214
29,1,7,63
30,1,7,397
31,14,8,23
32,19,8,96
33,3,8,200
34,18,8,296
35,6,8,485
36,11,8,423
37,19,8,153
38,7,9,283
39,15,9,176
40,4,9,399
41,3,9,29
42,10,9,45
43,11,9,456
44,14,10,485
45,7,10,115
46,12,10,379
47,19,10,149
48,7,10,86
49,13,10,487
50,17,10,151
51,7,11,265
52,1,11,457
53,8,11,37
54,17,12,87
55,5,12,436
56,8,12,444
57,7,12,89
58,18,12,6
59,2,12,489
60,16,12,200
61,12,13,306
62,1,13,286
63,1,13,406
64,14,13,401
65,7,13,358
66,11,13,39
67,14,14,35
68,7,14,456
69,13,14,379
70,7,14,450
71,3,14,79
72,13,14,371
73,12,14,310
74,11,14,8
75,20,14,359
76,1,14,287
77,17,15,344
78,14,15,47
79,10,16,44
80,18,16,331
81,17,16,325
82,13,16,294
83,20,16,126
84,5,16,88
85,19,16,220
86,8,16,363
87,15,16,302
88,12,16,105
89,19,17,266
90,14,17,10
91,3,17,480
92,15,17,267
93,11,18,298
94,3,18,80
95,9,18,270
96,3,18,265
97,20,18,100
98,2,18,36
99,10,18,16
100,18,18,64
101,8,18,476
102,12,18,474
103,16,19,90
104,4,20,362
105,8,20,302
106,14,20,111
107,7,20,432
108,17,20,155
109,3,20,225
110,11,20,81
111,19,21,480
112,16,21,252
113,20,21,10
114,19,21,403
115,4,22,495
116,7,22,213
117,16,23,219
118,2,23,48
119,15,23,174
120,12,23,63
121,15,24,69
122,5,24,280
123,2,24,137
124,13,24,316
125,2,24,241
126,19,24,71
127,15,24,274
128,5,24,407
129,14,24,281
130,6,24,11
131,2,25,7
132,12,25,293
133,8,25,214
134,7,25,469
135,1,25,75
136,9,26,102
137,16,26,216
138,17,26,492
139,8,26,238
140,5,26,489
141,8,26,56
142,8,26,399
143,4,26,370
144,11,27,352
145,10,27,193
146,17,27,470
147,5,27,466
148,1,27,144
149,14,28,341
150,14,29,163
151,8,29,116
152,9,29,321
153,20,29,253
154,7,29,70
155,10,29,418
156,1,29,28
157,16,30,215
158,16,31,341
159,13,31,143
160,4,31,50
161,6,31,27
162,11,32,307
163,9,32,343
164,6,32,462
165,15,32,115
166,5,32,246
167,19,32,51
168,19,32,182
169,11,32,285
170,5,32,448
171,14,33,347
172,18,33,452
173,12,33,266
174,14,33,210
175,4,33,406
176,12,34,169
177,19,34,464
178,12,35,201
179,18,36,265
180,10,36,459
181,2,36,349
182,10,36,12
183,17,37,206
184,13,37,269
185,17,37,52
186,5,37,18
187,7,37,99
188,11,37,90
189,3,37,380
190,8,37,311
191,5,37,110
192,10,37,147
193,4,38,106
194,17,38,269
195,15,38,381
196,10,39,381
197,17,39,184
198,18,39,328
199,15,39,283
200,7,39,303
201,3,39,250
202,12,39,115
203,20,39,375
204,15,40,79
205,6,40,116
206,11,40,465
207,5,40,490
208,3,40,308
209,19,40,45
210,19,41,261
211,15,41,357
212,14,41,203
213,5,41,35
214,3,41,319
215,17,41,488
216,4,42,452
217,19,42,221
218,4,42,247
219,18,42,27
220,5,43,317
221,10,43,32
222,7,43,385
223,10,44,340
224,20,44,255
225,5,45,346
226,20,45,41
227,16,45,256
228,13,45,472
229,20,45,13
230,7,45,103
231,6,45,499
232,10,46,137
233,6,46,359
234,8,46,142
235,19,46,105
236,9,47,471
237,14,47,46
238,4,47,330
239,10,48,363
240,3,48,55
241,2,48,318
242,19,48,273
243,7,49,158
244,17,49,147
245,9,50,274
246,8,50,25
247,2,50,415
248,20,50,163
249,4,50,27
250,6,51,410
251,12,51,385
252,16,51,345
253,20,52,38
254,12,52,397
255,1,52,234
256,7,52,452
257,6,53,155
258,1,53,298
259,3,53,493
260,2,54,106
261,18,55,314
262,20,55,392
263,15,55,229
264,12,55,29
265,9,55,204
266,13,55,221
267,4,55,370
268,9,56,45
269,9,56,258
270,20,56,470
271,20,56,100
272,8,56,194
273,7,56,450
274,5,56,102
275,15,56,325
276,11,56,148
277,12,56,424
278,6,57,215
279,18,57,231
280,2,58,243
281,13,58,443
282,5,59,220
283,2,59,391
284,9,59,370
285,13,59,201
286,1,59,375
287,3,59,146
288,10,59,477
289,9,59,281
290,18,59,195
291,2,59,497
292,18,60,307
293,9,60,250
294,3,60,132
295,1,60,141
296,5,61,37
297,17,61,4
298,11,62,400
299,12,62,147
300,2,62,494
301,11,62,158
302,5,62,236
303,17,62,413
304,17,62,285
305,15,63,186
306,17,63,31
307,6,63,162
308,6,63,163
309,1,63,457
310,17,63,148
311,6,64,300
312,14,64,239
313,2,64,106
314,8,64,184
315,2,64,40
316,18,64,436
317,16,65,334
318,6,65,183
319,7,65,229
320,5,65,76
321,10,65,417
322,11,66,468
323,17,66,88
324,18,66,477
325,14,66,141
326,1,66,81
327,20,66,252
328,4,66,378
329,16,66,35
330,1,67,113
331,15,67,138
332,13,67,133
333,15,67,445
334,12,67,416
335,16,68,2
336,20,68,195
337,16,68,299
338,5,68,325
339,9,68,471
340,20,68,38
341,11,68,344
342,17,68,104
343,3,68,476
344,5,68,165
345,17,69,254
346,14,69,69
347,13,69,236
348,5,69,284
349,8,69,445
350,15,69,27
351,5,69,446
352,3,70,73
353,7,70,159
354,18,70,22
355,14,70,23
356,17,70,445
357,10,70,128
358,4,70,62
359,19,71,25
360,17,71,352
361,15,71,93
362,1,71,24
363,9,71,59
364,13,71,366
365,6,71,270
366,3,71,418
367,8,72,85
368,13,72,296
369,15,72,144
370,20,72,112
371,13,72,197
372,16,72,108
373,20,72,343
374,1,72,154
375,12,72,105
376,3,73,96
377,10,73,434
378,2,73,417
379,19,73,8
380,15,73,416
381,9,73,271
382,15,73,229
383,18,73,97
384,18,74,63
385,9,74,128
386,17,74,391
387,7,74,364
388,16,74,183
389,13,74,229
390,18,74,223
391,6,74,243
392,13,74,418
393,5,74,400
394,11,75,279
395,8,75,25
396,11,75,306
397,10,75,265
398,4,75,431
399,9,75,440
400,12,75,62
401,14,75,9
402,19,75,131
403,2,76,378
404,17,76,322
405,8,76,497
406,9,77,427
407,9,77,372
408,17,78,334
409,6,78,110
410,6,78,126
411,8,78,84
412,7,78,57
413,20,78,29
414,12,78,212
415,4,78,472
416,6,78,265
417,15,78,87
418,11,79,439
419,4,79,56
420,13,79,181
421,5,80,500
422,19,80,65
423,3,80,33
424,10,80,298
425,1,80,344
426,2,80,21
427,1,80,305
428,13,80,231
429,3,80,31
430,4,80,430
431,5,81,164
432,6,81,441
433,10,81,437
434,2,81,430
435,13,81,226
436,13,81,77
437,13,81,16
438,4,81,405
439,16,81,13
440,4,82,13
441,14,82,197
442,10,82,29
443,7,82,191
444,1,83,479
445,11,83,354
446,18,83,312
447,16,83,205
448,7,83,489
449,18,84,304
450,19,84,88
451,12,84,435
452,15,84,70
453,12,84,450
454,12,84,327
455,16,85,108
456,15,85,423
457,8,85,294
458,7,85,340
459,19,86,414
460,14,86,367
461,15,86,131
462,4,86,301
463,19,86,263
464,4,86,166
465,19,86,445
466,17,86,494
467,18,86,380
468,19,87,366
469,13,87,24
470,5,87,149
471,16,87,406
472,20,87,232
473,17,87,44
474,7,87,16
475,16,87,491
476,8,87,476
477,19,87,212
478,2,88,11
479,20,88,126
480,13,88,117
481,20,88,299
482,1,88,135
483,1,88,324
484,1,88,91
485,9,88,172
486,18,88,15
487,4,88,456
488,10,89,358
489,10,89,328
490,11,89,96
491,10,89,340
492,14,89,329
493,9,89,410
494,4,89,106
495,3,89,147
496,17,90,95
497,6,90,442
498,17,90,284
499,11,90,373
500,4,91,57
501,5,91,444
502,2,91,393
503,2,91,191
504,4,92,414
505,8,92,398
506,10,92,95
507,19,92,73
508,4,92,206
509,12,92,447
510,18,92,365
511,18,92,277
512,1,93,250
513,8,93,455
514,13,93,439
515,19,94,136
516,6,94,192
517,14,94,374
518,7,94,223
519,15,95,430
520,9,95,72
521,11,95,269
522,6,96,39
523,20,97,99
524,6,98,198
525,3,98,55
526,20,99,358
527,9,99,379
528,3,99,198
529,8,99,345
530,11,99,105
531,19,99,482
532,8,99,166
533,6,99,132
534,15,100,283
535,5,100,496
536,10,100,256
537,15,100,463
538,2,100,97
539,2,100,19
540,16,100,109
541,2,101,471
542,6,101,239
543,1,101,466
544,6,101,424
545,1,101,58
546,18,101,494
547,10,102,42
548,2,102,266
549,11,102,142
550,1,102,500
551,2,102,255
552,14,102,36
553,12,102,180
554,11,102,32
555,14,102,140
556,12,103,339
557,6,103,286
558,14,103,372
559,5,103,391
560,13,104,69
561,10,104,108
562,9,105,311
563,8,105,66
564,11,105,385
565,16,106,249
566,10,106,403
567,10,106,300
568,1,106,448
569,15,106,233
570,16,107,89
571,13,107,401
572,1,107,202
573,5,107,446
574,7,107,3
575,13,107,24
576,1,107,224
577,13,108,109
578,15,108,193
579,16,108,127
580,18,109,493
581,2,109,230
582,14,109,271
583,15,109,261
584,7,109,148
585,6,109,400
586,8,109,3
587,11,109,69
588,19,109,17
589,16,109,356
590,2,110,168
591,7,110,44
592,20,110,179
593,17,110,186
594,10,110,171
595,14,110,341
596,1,111,132
597,12,111,407
598,10,111,423
599,1,111,378
600,7,111,386
601,6,111,143
602,3,112,291
603,10,112,246
604,1,112,441
605,1,113,315
606,16,113,302
607,17,114,431
608,9,114,322
609,20,114,226
610,6,114,260
611,5,114,11
612,16,114,330
613,15,114,298
614,16,114,282
615,11,114,159
616,20,115,278
617,6,116,196
618,16,116,64
619,11,117,87
620,7,117,349
621,6,117,369
622,18,117,492
623,2,117,147
624,7,117,491
625,3,117,474
626,1,117,436
627,11,118,167
628,7,118,155
629,14,118,290
630,19,118,244
631,12,118,317
632,9,118,297
633,2,119,127
634,16,119,488
635,16,120,155
636,17,120,227
637,13,120,309
638,20,120,122
639,2,120,414
640,17,120,95
641,19,121,147
642,11,121,293
643,11,121,198
644,15,122,170
645,4,122,63
646,19,122,349
647,5,122,231
648,14,122,37
649,18,122,191
650,12,122,497
651,7,123,436
652,1,123,336
653,3,123,192
654,16,123,43
655,7,123,13
656,11,123,341
657,16,123,383
658,8,123,159
659,10,124,359
660,3,124,173
661,4,124,76
662,20,124,347
663,19,124,42
664,13,124,388
665,8,124,265
666,4,124,412
667,14,124,462
668,2,124,82
669,12,125,26
670,8,125,116
671,12,125,489
672,19,125,144
673,17,125,477
674,6,125,204
675,8,125,316
676,6,125,360
677,6,125,162
678,7,125,320
679,16,126,382
680,11,127,214
681,10,127,405
682,8,127,236
683,7,127,462
684,17,128,77
685,5,128,470
686,13,128,315
687,1,128,381
688,6,128,152
689,20,129,381
690,16,129,42
691,10,129,105
692,5,129,387
693,9,129,432
694,14,129,190
695,17,129,422
696,3,129,473
697,3,130,156
698,5,130,421
699,8,130,347
700,17,130,349
701,20,130,152
702,17,130,364
703,13,130,60
704,11,130,154
705,3,130,309
706,7,130,350
707,10,131,36
708,6,132,28
709,12,132,299
710,14,132,491
711,3,133,358
712,17,133,461
713,10,133,342
714,6,133,307
715,14,133,455
716,11,134,431
717,19,134,397
718,2,135,157
719,13,135,14
720,5,135,255
721,19,135,279
722,5,135,398
723,12,135,181
724,10,135,311
725,3,135,241
726,14,135,139
727,12,136,227
728,10,136,40
729,2,136,78
730,16,136,154
731,8,136,58
732,20,136,194
733,18,136,263
734,11,136,75
735,17,137,129
736,17,137,393
737,13,138,313
738,6,138,384
739,6,138,199
740,15,138,91
741,2,138,420
742,14,138,243
743,13,138,273
744,17,138,495
745,11,139,381
746,19,139,13
747,10,139,236
748,7,139,94
749,10,139,126
750,5,140,302
751,14,140,156
752,2,140,329
753,17,140,211
754,17,140,38
755,19,140,132
756,2,140,236
757,1,141,65
758,15,141,415
759,13,141,378
760,15,141,72
761,18,141,499
762,5,141,357
763,7,142,253
764,19,142,423
765,2,142,102
766,4,143,186
767,9,143,245
768,1,143,94
769,5,143,157
770,18,143,79
771,5,143,183
772,6,143,175
773,19,143,409
774,8,144,200
775,18,144,169
776,7,144,300
777,6,144,369
778,15,145,452
779,14,145,401
780,5,145,70
781,2,145,406
782,13,145,28
783,19,145,172
784,7,145,448
785,12,145,119
786,7,146,304
787,11,146,38
788,13,146,358
789,3,146,20
790,16,146,250
791,10,146,356
792,8,147,446
793,3,148,399
794,11,149,376
795,4,149,323
796,18,149,266
797,12,149,70
798,19,149,328
799,8,149,57
800,13,149,52
801,18,150,292
802,18,150,442
803,9,150,322
804,5,150,342
805,17,150,372
806,11,150,150
807,17,150,364
808,15,150,2
809,13,150,262
810,10,151,51
811,3,151,148
812,7,151,308
813,9,151,15
814,9,151,80
815,6,151,194
816,7,151,204
817,9,151,277
818,5,152,369
819,20,152,43
820,10,152,18
821,15,152,355
822,14,153,40
823,11,153,147
824,3,153,341
825,1,153,388
826,16,153,209
827,6,153,465
828,2,153,368
829,9,153,500
830,12,153,293
831,18,153,34
832,17,154,6
833,12,154,335
834,13,154,293
835,17,154,221
836,14,154,487
837,4,155,223
838,20,155,473
839,12,155,459
840,1,155,76
841,11,156,76
842,12,156,202
843,17,156,194
844,14,156,170
845,19,157,296
846,2,157,262
847,18,157,23
848,1,157,49
849,9,157,438
850,18,158,392
851,13,158,2
852,4,158,26
853,8,158,468
854,5,158,312
855,13,158,363
856,2,158,193
857,19,158,97
858,3,159,475
859,16,159,58
860,2,159,142
861,7,159,308
862,16,160,500
863,5,160,197
864,12,160,471
865,16,160,428
866,14,160,372
867,13,161,341
868,13,161,167
869,15,161,485
870,13,161,10
871,15,161,149
872,7,161,115
873,5,162,376
874,15,162,297
875,15,162,139
876,7,162,106
877,7,162,10
878,14,162,141
879,19,162,492
880,7,162,188
881,15,162,140
882,4,162,44
883,20,163,12
884,1,163,18
885,8,164,240
886,1,164,392
887,4,164,11
888,4,164,341
889,9,165,468
890,1,165,160
891,15,166,113
892,10,166,147
893,20,166,12
894,17,166,103
895,10,166,484
896,15,167,321
897,20,167,440
898,19,167,436
899,7,167,444
900,13,167,237
901,8,167,190
902,12,167,256
903,16,167,352
904,11,168,213
905,8,168,272
906,19,168,374
907,20,168,34
908,12,168,451
909,12,168,346
910,18,168,310
911,17,169,17
912,17,169,457
913,8,169,446
914,20,169,42
915,9,169,474
916,11,169,239
917,10,170,286
918,6,170,279
919,5,171,97
920,1,171,346
921,13,171,91
922,19,171,481
923,8,171,323
924,1,171,339
925,5,171,441
926,8,172,252
927,3,173,282
928,11,173,39
929,15,173,217
930,20,173,159
931,7,173,266
932,10,173,346
933,19,173,400
934,16,174,86
935,16,174,356
936,10,174,194
937,13,174,47
938,10,174,293
939,2,174,11
940,1,174,21
941,2,175,115
942,2,175,261
943,18,175,106
944,17,175,492
945,17,175,491
946,13,176,148
947,19,176,269
948,2,176,357
949,15,176,299
950,6,176,341
951,4,176,57
952,19,177,406
953,10,177,87
954,19,178,433
955,20,178,274
956,2,178,337
957,19,178,51
958,16,178,361
959,12,178,377
960,10,178,95
961,8,178,482
962,4,178,86
963,19,178,133
964,19,179,427
965,6,179,174
966,1,180,273
967,19,180,84
968,8,180,244
969,10,180,74
970,4,180,442
971,16,180,47
972,13,181,469
973,11,181,268
974,9,181,138
975,12,181,447
976,2,181,349
977,9,181,378
978,20,181,34
979,19,181,344
980,4,181,102
981,7,182,192
982,16,182,218
983,1,182,345
984,12,182,488
985,12,182,303
986,17,183,405
987,19,183,45
988,20,183,474
989,6,183,172
990,16,183,163
991,15,183,190
992,18,183,16
993,6,183,291
994,3,184,122
995,10,184,19
996,12,184,112
997,12,184,32
998,19,185,332
999,18,185,347
1000,6,185,302
1001,4,185,31
1002,2,185,188
1003,5,185,391
1004,1,185,295
1005,6,185,1
1006,17,185,384
1007,15,185,193
1008,1,186,54
1009,7,186,153
1010,5,186,154
1011,7,186,116
1012,16,186,220
1013,8,186,83
1014,16,186,482
1015,17,187,257
1016,20,187,12
1017,19,187,113
1018,18,187,102
1019,12,187,84
1020,10,188,398
1021,11,189,213
1022,9,189,190
1023,7,189,157
1024,16,189,65
1025,15,190,312
1026,10,190,13
1027,19,190,483
1028,6,190,43
1029,1,190,472
1030,6,190,68
1031,12,191,49
1032,14,191,77
1033,16,191,494
1034,12,191,338
1035,15,191,404
1036,1,192,299
1037,11,192,319
1038,18,192,371
1039,19,192,392
1040,15,192,95
1041,8,192,66
1042,15,192,409
1043,13,192,174
1044,1,192,53
1045,17,193,416
1046,15,193,385
1047,14,193,245
1048,15,193,441
1049,15,194,111
1050,1,194,143
1051,12,195,124
1052,13,195,319
1053,7,195,55
1054,15,195,271
1055,14,195,160
1056,6,195,30
1057,5,195,190
1058,14,195,464
1059,15,195,342
1060,11,195,408
1061,14,196,67
1062,11,197,486
1063,7,197,226
1064,11,197,25
1065,11,197,187
1066,2,197,411
1067,10,197,42
1068,7,197,116
1069,5,198,356
1070,8,198,307
1071,11,199,172
1072,2,199,2
1073,13,199,448
1074,17,199,213
1075,6,199,434
1076,14,199,442
1077,10,199,12
1078,17,199,162
1079,11,199,373
1080,20,200,395
1081,18,200,276
1082,17,200,160
1083,18,200,118
1084,7,200,113
1085,9,200,11
1086,12,200,274
1087,4,200,48
1088,12,200,43
1089,14,201,210
1090,10,201,439
1091,1,201,359
1092,9,201,83
1093,1,201,246
1094,20,201,130
1095,6,201,8
1096,18,201,118
1097,2,201,378
1098,18,201,268
1099,11,202,339
1100,18,202,165
1101,11,202,480
1102,5,202,423
1103,17,202,433
1104,3,202,177
1105,9,202,78
1106,10,202,98
1107,14,202,311
1108,3,203,437
1109,18,203,400
1110,9,203,47
1111,15,203,396
1112,17,204,131
1113,8,204,370
1114,5,204,479
1115,7,204,375
1116,10,204,372
1117,7,204,2
1118,5,204,377
1119,16,204,320
1120,3,204,161
1121,3,205,80
1122,10,205,190
1123,14,205,438
1124,4,205,16
1125,17,205,349
1126,2,205,79
1127,14,205,266
1128,6,205,456
1129,10,205,333
1130,16,205,315
1131,14,206,464
1132,12,206,86
1133,10,206,31
1134,10,206,186
1135,9,206,324
1136,7,206,137
1137,4,206,418
1138,5,207,404
1139,18,208,130
1140,8,208,379
1141,6,208,494
1142,1,208,24
1143,10,208,341
1144,18,208,182
1145,14,208,42
1146,1,208,490
1147,10,209,217
1148,1,209,135
1149,14,209,290
1150,4,209,445
1151,18,209,348
1152,20,209,57
1153,9,209,396
1154,1,210,274
1155,11,210,277
1156,13,210,40
1157,13,210,78
1158,7,211,34
1159,10,211,262
1160,2,211,304
1161,10,211,302
1162,10,211,36
1163,1,211,189
1164,16,211,89
1165,11,212,62
1166,18,212,405
1167,14,212,314
1168,7,212,198
1169,4,212,415
1170,16,212,128
1171,18,213,46
1172,2,213,189
1173,3,213,279
1174,1,213,122
1175,14,213,226
1176,2,213,329
1177,10,213,159
1178,2,213,160
1179,17,213,235
1180,14,213,366
1181,11,214,95
1182,12,214,102
1183,15,214,490
1184,5,214,168
1185,5,215,394
1186,13,215,385
1187,9,216,390
1188,2,216,191
1189,20,216,52
1190,1,216,184
1191,20,217,339
1192,13,217,171
1193,12,217,462
1194,12,217,296
1195,11,218,103
1196,16,218,71
1197,17,219,96
1198,2,219,287
1199,16,219,272
1200,19,219,346
1201,16,219,125
1202,4,219,261
1203,13,220,144
1204,7,220,18
1205,12,221,289
1206,4,221,297
1207,19,221,348
1208,6,221,77
1209,5,221,168
1210,6,221,132
1211,10,221,162
1212,11,222,22
1213,6,222,184
1214,11,222,463
1215,17,222,452
1216,15,222,200
1217,14,222,46
1218,8,222,4
1219,2,223,405
1220,3,223,427
1221,8,223,286
1222,9,224,464
1223,4,225,37
1224,9,225,46
1225,11,225,271
1226,16,226,72
1227,16,226,145
1228,14,226,424
1229,14,226,173
1230,6,226,379
1231,8,226,295
1232,4,226,370
1233,8,226,113
1234,5,226,83
1235,2,226,439
1236,12,227,15
1237,17,227,108
1238,5,227,454
1239,3,227,361
1240,7,227,442
1241,13,227,235
1242,5,228,500
1243,19,228,200
1244,10,228,463
1245,14,228,344
1246,10,228,70
1247,9,228,222
1248,19,228,479
1249,11,228,303
1250,2,228,111
1251,8,228,436
1252,20,229,366
1253,14,230,406
1254,3,230,23
1255,1,230,180
1256,1,231,437
1257,13,231,217
1258,19,231,148
1259,20,231,408
1260,14,231,430
1261,13,231,268
1262,12,231,65
1263,16,231,321
1264,17,232,293
1265,5,232,18
1266,9,233,260
1267,3,233,249
1268,5,233,403
1269,4,233,180
1270,4,233,57
1271,11,234,205
1272,10,234,257
1273,18,234,404
1274,3,234,295
1275,12,234,318
1276,5,234,391
1277,14,234,119
1278,11,235,257
1279,17,235,272
1280,8,236,106
1281,19,237,15
1282,20,237,253
1283,5,237,62
1284,18,237,317
1285,12,237,97
1286,1,237,95
1287,10,238,192
1288,9,238,173
1289,17,238,104
1290,14,239,355
1291,2,239,368
1292,5,239,58
1293,15,239,443
1294,5,239,128
1295,5,239,13
1296,20,239,266
1297,15,240,173
1298,10,240,118
1299,16,240,234
1300,13,240,86
1301,2,240,32
1302,4,240,390
1303,16,240,351
1304,8,240,171
1305,1,240,335
1306,10,241,159
1307,11,242,102
1308,6,242,47
1309,9,242,360
1310,11,242,281
1311,18,242,19
1312,16,242,414
1313,1,243,245
1314,15,244,177
1315,1,244,96
1316,6,244,107
1317,13,244,305
1318,1,244,493
1319,6,244,367
1320,13,244,150
1321,10,244,385
1322,3,244,215
1323,8,245,494
1324,6,245,348
1325,4,245,309
1326,11,245,186
1327,10,245,41
1328,19,245,310
1329,3,245,168
1330,12,246,39
1331,15,246,168
1332,1,247,170
1333,19,247,156
1334,4,247,497
1335,5,247,259
1336,11,247,193
1337,20,247,234
1338,11,247,483
1339,13,247,175
1340,8,247,479
1341,6,248,38
1342,9,248,481
1343,6,249,390
1344,9,249,155
1345,3,249,406
1346,11,249,68
1347,4,249,460
1348,5,249,189
1349,2,249,210
1350,6,249,477
1351,17,249,363
1352,6,249,223
1353,6,250,27
1354,4,250,460
1355,19,250,387
1356,14,250,194
1357,4,250,156
1358,8,251,50
1359,2,251,391
1360,9,251,450
1361,3,251,60
1362,3,252,39
1363,16,252,414
1364,2,252,261
1365,6,252,241
1366,3,252,385
1367,19,252,480
1368,19,253,186
1369,1,253,185
1370,15,253,498
1371,18,253,403
1372,2,253,456
1373,15,254,163
1374,18,254,120
1375,9,254,259
1376,19,254,422
1377,6,254,276
1378,10,254,280
1379,11,254,184
1380,13,255,340
1381,16,255,236
1382,16,256,261
1383,7,256,163
1384,17,256,15
1385,8,256,199
1386,4,256,176
1387,6,256,195
1388,14,256,322
1389,17,256,54
1390,2,256,440
1391,19,257,275
1392,13,257,130
1393,16,257,110
1394,10,258,209
1395,10,258,212
1396,4,259,431
1397,16,259,77
1398,10,259,322
1399,7,259,41
1400,12,259,376
1401,19,259,418
1402,18,259,31
1403,14,259,180
1404,19,259,266
1405,19,260,447
1406,12,260,500
1407,5,260,259
1408,1,260,120
1409,2,260,123
1410,6,261,495
1411,14,261,199
1412,11,261,237
1413,9,261,489
1414,18,261,429
1415,10,261,430
1416,10,262,49
1417,12,262,439
1418,1,262,154
1419,5,262,180
1420,6,262,141
1421,7,262,362
1422,14,263,131
1423,19,263,477
1424,17,263,245
1425,18,263,316
1426,20,263,224
1427,10,263,456
1428,15,264,489
1429,13,264,108
1430,19,264,204
1431,13,264,347
1432,6,264,143
1433,7,265,345
1434,12,265,184
1435,19,265,199
1436,6,265,485
1437,5,265,338
1438,10,265,178
1439,7,265,450
1440,20,265,234
1441,4,266,241
1442,5,266,240
1443,17,266,395
1444,15,266,74
1445,15,267,109
1446,16,267,301
1447,15,267,167
1448,16,267,77
1449,18,267,368
1450,5,268,283
1451,14,268,113
1452,10,268,252
1453,11,268,168
1454,8,268,20
1455,17,268,482
1456,9,268,172
1457,10,268,326
1458,18,268,213
1459,17,269,391
1460,8,269,367
1461,13,269,483
1462,6,269,346
1463,6,269,436
1464,2,269,293
1465,6,270,325
1466,5,270,490
1467,10,270,181
1468,4,271,210
1469,12,271,452
1470,10,271,130
1471,19,271,121
1472,17,271,436
1473,16,271,473
1474,12,272,370
1475,14,272,13
1476,10,272,292
1477,1,272,44
1478,17,272,471
1479,10,272,64
1480,1,272,470
1481,10,272,157
1482,15,273,454
1483,3,273,443
1484,8,273,446
1485,20,274,452
1486,2,274,157
1487,15,274,460
1488,1,274,12
1489,3,274,69
1490,7,274,298
1491,15,274,52
1492,2,274,351
1493,9,275,352
1494,18,275,476
1495,13,275,438
1496,14,275,1
1497,4,275,196
1498,20,275,313
1499,14,275,263
1500,15,275,171
1501,6,275,129
1502,13,276,39
1503,15,276,388
1504,2,276,386
1505,4,276,475
1506,17,277,479
1507,7,277,427
1508,4,277,248
1509,13,277,458
1510,4,277,210
1511,8,277,330
1512,8,277,299
1513,20,278,47
1514,10,278,425
1515,2,278,454
1516,6,278,368
1517,20,279,82
1518,18,279,423
1519,7,279,54
1520,3,279,483
1521,11,280,263
1522,4,280,314
1523,6,280,401
1524,6,280,458
1525,13,280,355
1526,3,280,242
1527,11,280,96
1528,3,280,279
1529,19,280,333
1530,19,281,8
1531,15,281,78
1532,16,282,426
1533,5,282,134
1534,18,282,295
1535,20,282,23
1536,15,282,195
1537,1,282,297
1538,4,282,178
1539,16,282,462
1540,13,283,279
1541,18,283,226
1542,2,283,55
1543,20,283,133
1544,16,283,131
1545,10,283,26
1546,12,283,415
1547,3,283,473
1548,13,283,208
1549,2,283,216
1550,11,284,498
1551,2,284,417
1552,3,284,142
1553,20,284,414
1554,3,285,152
1555,6,285,250
1556,17,285,245
1557,10,285,125
1558,7,285,141
1559,7,285,221
1560,16,286,113
1561,12,287,96
1562,5,288,274
1563,18,289,119
1564,4,289,174
1565,3,289,1
1566,19,289,493
1567,15,289,374
1568,4,289,306
1569,10,289,116
1570,14,289,186
1571,14,289,292
1572,2,289,372
1573,17,290,58
1574,6,291,471
1575,8,291,274
1576,16,291,486
1577,16,292,126
1578,18,293,239
1579,17,293,18
1580,4,294,303
1581,17,294,196
1582,3,294,411
1583,10,294,233
1584,17,294,59
1585,1,295,442
1586,4,295,390
1587,14,295,8
1588,3,295,291
1589,11,295,100
1590,14,295,21
1591,5,295,50
1592,13,295,423
1593,13,296,467
1594,12,296,345
1595,7,297,397
1596,9,297,260
1597,17,297,202
1598,18,297,133
1599,1,297,146
1600,11,297,322
1601,10,297,227
1602,4,297,2
1603,19,297,110
1604,17,297,197
1605,6,298,414
1606,8,298,367
1607,17,298,189
1608,3,299,405
1609,14,299,413
1610,16,299,239
1611,18,299,344
1612,2,299,229
1613,8,299,155
1614,5,300,477
1615,15,300,100
1616,4,300,319
1617,8,300,248
1618,12,300,161
1619,12,300,169
1620,8,300,196
1621,11,301,196
1622,17,301,467
1623,15,301,192
1624,16,301,406
1625,12,301,119
1626,3,301,210
1627,13,301,272
1628,13,301,429
1629,1,301,312
1630,4,302,31
1631,14,302,51
1632,18,302,356
1633,8,302,64
1634,14,302,119
1635,16,302,209
1636,13,302,416
1637,2,302,342
1638,11,302,82
1639,2,303,22
1640,10,303,397
1641,20,303,485
1642,10,303,149
1643,20,303,147
1644,14,303,444
1645,19,303,340
1646,13,303,132
1647,8,304,93
1648,15,304,191
1649,10,305,402
1650,17,305,50
1651,12,305,433
1652,2,306,89
1653,5,306,203
1654,1,306,132
1655,9,306,407
1656,6,306,242
1657,10,306,276
1658,20,307,304
1659,1,307,417
1660,3,307,288
1661,15,307,31
1662,5,308,157
1663,12,309,253
1664,6,309,235
1665,16,309,6
1666,8,309,224
1667,5,309,486
1668,4,309,363
1669,3,309,35
1670,7,309,211
1671,3,309,102
1672,9,310,497
1673,12,310,460
1674,14,310,390
1675,8,310,237
1676,18,310,258
1677,9,311,277
1678,13,311,316
1679,15,311,232
1680,8,311,489
1681,1,312,389
1682,15,312,302
1683,4,312,35
1684,4,312,291
1685,14,312,460
1686,10,313,238
1687,9,313,52
1688,11,313,207
1689,9,313,354
1690,19,313,49
1691,6,313,468
1692,14,313,466
1693,13,313,187
1694,18,313,308
1695,11,313,32
1696,3,314,354
1697,4,314,358
1698,3,314,268
1699,2,314,98
1700,14,314,417
1701,14,314,175
1702,16,314,441
1703,15,315,306
1704,4,315,87
1705,3,315,147
1706,13,315,213
1707,7,315,225
1708,11,315,343
1709,10,315,297
1710,10,315,263
1711,16,315,268
1712,4,315,359
1713,5,316,249
1714,17,316,256
1715,4,316,335
1716,5,316,237
1717,11,316,389
1718,3,316,226
1719,10,316,110
1720,20,316,275
1721,2,316,125
1722,15,317,270
1723,19,317,382
1724,20,317,48
1725,19,317,44
1726,6,317,451
1727,17,317,433
1728,6,317,53
1729,2,317,170
1730,1,318,337
1731,15,318,371
1732,7,318,252
1733,17,318,185
1734,15,318,21
1735,19,318,69
1736,8,318,269
1737,11,319,319
1738,19,319,229
1739,10,319,398
1740,8,319,437
1741,6,319,59
1742,13,320,201
1743,17,320,293
1744,3,320,36
1745,6,320,436
1746,11,320,490
1747,2,320,131
1748,1,320,344
1749,14,320,92
1750,8,320,395
1751,5,321,463
1752,14,321,23
1753,9,321,199
1754,19,321,46
1755,2,322,264
1756,13,322,380
1757,4,323,1
1758,6,323,175
1759,10,323,441
1760,16,323,90
1761,1,324,73
1762,3,324,450
1763,16,324,168
1764,1,324,428
1765,13,324,1
1766,7,324,36
1767,8,324,43
1768,20,324,201
1769,19,325,327
1770,19,325,133
1771,6,325,313
1772,4,325,482
1773,10,325,97
1774,18,325,96
1775,18,325,71
1776,7,326,253
1777,16,326,148
1778,11,326,365
1779,2,326,456
1780,9,327,26
1781,1,327,142
1782,13,327,319
1783,14,328,3
1784,2,329,398
1785,10,330,33
1786,9,331,400
1787,4,331,125
1788,12,331,86
1789,7,331,77
1790,3,332,86
1791,17,332,331
1792,18,332,182
1793,9,332,230
1794,14,333,311
1795,17,333,59
1796,8,333,280
1797,20,333,103
1798,18,333,132
1799,1,333,87
1800,14,333,175
1801,18,334,214
1802,2,334,401
1803,3,334,210
1804,19,334,212
1805,3,334,222
1806,17,334,423
1807,11,334,239
1808,15,335,98
1809,8,336,193
1810,3,336,133
1811,19,336,292
1812,15,336,304
1813,6,336,117
1814,11,336,370
1815,3,336,127
1816,5,336,284
1817,18,336,389
1818,8,337,229
1819,9,337,483
1820,20,337,311
1821,16,337,373
1822,4,337,172
1823,9,337,178
1824,18,337,83
1825,7,337,109
1826,6,337,157
1827,3,338,195
1828,3,339,39
1829,2,339,133
1830,9,339,476
1831,10,340,284
1832,18,340,206
1833,13,340,168
1834,6,340,154
1835,4,340,234
1836,11,340,30
1837,16,340,435
1838,8,340,362
1839,8,341,423
1840,17,341,148
1841,19,341,309
1842,1,341,436
1843,1,341,232
1844,1,341,143
1845,7,342,177
1846,16,343,431
1847,4,344,92
1848,16,344,404
1849,9,344,346
1850,17,344,290
1851,11,344,130
1852,12,344,152
1853,5,344,474
1854,20,344,325
1855,18,344,138
1856,6,345,188
1857,7,345,221
1858,8,345,469
1859,12,346,29
1860,1,347,273
1861,12,347,58
1862,17,347,163
1863,8,348,329
1864,14,348,244
1865,6,348,115
1866,16,348,155
1867,11,348,461
1868,6,348,354
1869,9,348,191
1870,15,348,437
1871,8,349,66
1872,1,349,17
1873,15,350,301
1874,18,350,321
1875,4,350,10
1876,8,350,113
1877,9,350,351
1878,14,350,464
1879,12,350,142
1880,13,350,284
1881,2,350,104
1882,18,351,415
1883,5,351,182
1884,15,351,130
1885,8,351,210
1886,5,351,53
1887,7,351,116
1888,20,351,79
1889,7,351,212
1890,19,351,343
1891,16,352,13
1892,19,352,197
1893,18,352,210
1894,1,352,275
1895,14,352,468
1896,2,352,464
1897,4,352,171
1898,10,353,47
1899,6,353,137
1900,12,353,456
1901,2,353,300
1902,17,354,274
1903,18,354,220
1904,14,354,358
1905,20,354,459
1906,3,354,151
1907,14,354,190
1908,2,354,188
1909,11,354,52
1910,20,354,333
1911,10,355,320
1912,18,355,456
1913,2,355,298
1914,11,355,189
1915,19,355,145
1916,14,356,421
1917,10,356,64
1918,4,356,469
1919,1,356,412
1920,18,356,341
1921,12,356,81
1922,9,356,115
1923,9,356,413
1924,6,357,419
1925,9,357,104
1926,9,357,291
1927,15,357,198
1928,15,357,325
1929,13,357,237
1930,2,357,465
1931,4,358,212
1932,5,358,140
1933,15,358,337
1934,9,358,12
1935,5,359,245
1936,12,359,402
1937,11,359,46
1938,5,359,179
1939,1,360,51
1940,6,360,103
1941,12,360,220
1942,16,361,469
1943,10,361,32
1944,12,361,298
1945,11,361,341
1946,14,361,467
1947,17,362,245
1948,2,362,183
1949,16,362,218
1950,14,362,188
1951,6,362,165
1952,12,362,90
1953,10,362,386
1954,7,362,283
1955,15,363,32
1956,10,363,261
1957,5,363,387
1958,10,363,28
1959,16,363,448
1960,17,363,119
1961,15,363,102
1962,8,364,397
1963,1,364,94
1964,9,364,170
1965,2,364,96
1966,20,364,277
1967,10,364,295
1968,1,364,142
1969,6,364,173
1970,6,364,492
1971,17,364,89
1972,12,365,480
1973,13,365,479
1974,8,365,37
1975,5,366,402
1976,19,366,70
1977,15,366,139
1978,12,366,214
1979,10,366,257
1980,3,366,472
1981,6,366,46
1982,7,366,341
1983,7,367,279
1984,5,367,467
1985,13,367,10
1986,1,368,250
1987,4,368,2
1988,20,369,186
1989,16,369,422
1990,4,369,128
1991,4,369,144
1992,2,369,204
1993,15,369,256
1994,16,369,270
1995,10,369,168
1996,3,370,402
1997,7,370,9
1998,10,370,355
1999,5,370,437
2000,10,371,117
2001,13,371,376
2002,16,372,248
2003,18,372,188
2004,13,372,362
2005,7,372,261
2006,3,372,385
2007,13,372,14
2008,11,373,492
2009,15,373,35
2010,11,373,164
2011,3,373,373
2012,19,373,469
2013,14,373,465
2014,1,373,296
2015,7,374,272
2016,5,374,202
2017,1,374,347
2018,4,374,141
2019,5,374,225
2020,11,374,321
2021,16,374,48
2022,14,375,266
2023,12,375,385
2024,11,375,400
2025,12,375,305
2026,4,375,193
2027,14,375,267
2028,18,375,388
2029,8,375,116
2030,9,376,64
2031,9,376,226
2032,13,376,462
2033,6,376,162
2034,19,376,95
2035,9,376,458
2036,5,376,216
2037,11,376,301
2038,15,377,243
2039,1,377,429
2040,5,377,439
2041,17,378,31
2042,8,378,344
2043,8,378,195
2044,4,378,497
2045,10,379,207
2046,2,379,266
2047,9,379,497
2048,18,379,79
2049,10,379,32
2050,6,379,214
2051,14,379,365
2052,20,379,72
2053,7,379,433
2054,12,379,441
2055,17,380,328
2056,5,381,83
2057,16,381,176
2058,10,381,131
2059,12,381,112
2060,3,381,66
2061,18,381,335
2062,8,382,362
2063,11,382,382
2064,14,382,427
2065,16,382,143
2066,20,382,281
2067,11,382,167
2068,17,382,423
2069,20,382,445
2070,2,382,417
2071,6,383,64
2072,9,383,121
2073,10,384,30
2074,8,384,413
2075,17,384,213
2076,6,384,304
2077,1,384,146
2078,6,384,426
2079,20,384,98
2080,6,384,165
2081,16,384,441
2082,6,384,425
2083,12,385,57
2084,20,385,297
2085,2,385,358
2086,20,385,36
2087,3,385,29
2088,15,385,149
2089,2,385,151
2090,9,385,50
2091,4,385,133
2092,3,386,437
2093,20,386,196
2094,17,386,238
2095,13,386,389
2096,10,386,495
2097,14,386,71
2098,13,386,115
2099,17,386,498
2100,16,387,228
2101,1,388,84
2102,3,388,464
2103,6,389,295
2104,3,389,147
2105,12,390,344
2106,14,390,83
2107,9,390,385
2108,19,390,11
2109,5,390,340
2110,4,390,356
2111,4,390,498
2112,6,390,324
2113,7,390,398
2114,14,391,132
2115,8,391,239
2116,3,392,299
2117,9,392,174
2118,14,392,310
2119,20,392,436
2120,9,393,25
2121,5,393,403
2122,2,393,311
2123,17,393,86
2124,3,393,495
2125,7,393,206
2126,20,394,267
2127,14,394,304
2128,4,395,100
2129,12,395,168
2130,20,395,263
2131,17,395,193
2132,18,395,396
2133,5,395,98
2134,16,395,198
2135,20,395,96
2136,18,395,450
2137,12,395,435
2138,1,396,275
2139,18,396,322
2140,13,396,144
2141,16,396,469
2142,2,396,78
2143,17,396,153
2144,3,396,247
2145,18,396,67
2146,6,396,174
2147,2,396,319
2148,2,397,262
2149,1,397,268
2150,3,397,335
2151,19,397,188
2152,19,397,397
2153,11,398,273
2154,2,398,116
2155,2,398,98
2156,3,398,85
2157,15,398,55
2158,7,398,272
2159,13,398,151
2160,16,398,210
2161,20,399,144
2162,13,399,94
2163,15,399,80
2164,9,399,105
2165,9,399,171
2166,11,399,28
2167,1,399,50
2168,3,399,300
2169,15,400,282
2170,13,400,453
2171,2,400,29
2172,12,400,78
2173,9,400,341
2174,2,400,174
2175,19,400,242
2176,14,400,473
2177,8,400,157
2178,3,400,496
2179,14,401,423
2180,15,401,352
2181,18,402,264
2182,15,402,407
2183,8,402,207
2184,1,402,382
2185,1,402,353
2186,6,402,15
2187,20,403,6
2188,4,403,323
2189,10,403,17
2190,15,403,243
2191,19,403,479
2192,15,403,430
2193,15,403,9
2194,11,403,226
2195,5,403,19
2196,20,404,12
2197,20,404,323
2198,8,404,245
2199,2,404,263
2200,15,404,146
2201,4,405,192
2202,1,405,174
2203,3,405,93
2204,20,405,451
2205,9,405,245
2206,4,405,19
2207,3,405,401
2208,14,405,13
2209,15,405,321
2210,14,406,331
2211,1,406,107
2212,14,406,125
2213,11,407,364
2214,10,407,465
2215,17,407,263
2216,11,407,430
2217,6,407,84
2218,16,407,391
2219,13,407,362
2220,1,407,500
2221,18,408,111
2222,14,408,296
2223,11,408,23
2224,4,408,466
2225,5,408,312
2226,13,408,225
2227,4,408,187
2228,15,408,207
2229,10,408,242
2230,17,409,19
2231,4,409,359
2232,19,409,400
2233,14,409,49
2234,14,409,338
2235,17,409,154
2236,4,409,250
2237,14,410,96
2238,13,410,65
2239,4,410,427
2240,7,410,433
2241,4,410,252
2242,17,410,90
2243,18,410,321
2244,10,410,233
2245,12,410,257
2246,6,410,415
2247,15,411,474
2248,4,411,204
2249,18,411,119
2250,6,411,161
2251,9,411,376
2252,17,411,222
2253,10,411,417
2254,5,412,265
2255,18,412,454
2256,5,412,472
2257,7,412,382
2258,15,412,49
2259,13,412,384
2260,2,412,461
2261,4,412,195
2262,11,412,114
2263,17,413,426
2264,15,413,177
2265,6,413,361
2266,17,413,19
2267,17,414,185
2268,18,414,265
2269,7,414,389
2270,12,414,52
2271,5,414,424
2272,14,414,199
2273,12,414,177
2274,7,414,451
2275,8,414,183
2276,8,414,5
2277,1,415,476
2278,18,415,269
2279,18,416,311
2280,2,416,43
2281,20,416,50
2282,6,416,59
2283,15,416,287
2284,4,417,380
2285,19,417,288
2286,5,417,156
2287,6,417,362
2288,9,417,269
2289,11,417,436
2290,20,417,224
2291,12,418,430
2292,3,418,183
2293,5,418,8
2294,16,418,30
2295,20,418,368
2296,18,418,156
2297,3,418,403
2298,9,419,10
2299,15,419,280
2300,2,419,336
2301,6,419,399
2302,6,419,442
2303,1,419,43
2304,11,419,298
2305,1,419,6
2306,6,419,251
2307,4,419,19
2308,8,420,292
2309,18,420,75
2310,4,420,345
2311,10,420,111
2312,4,420,36
2313,1,420,302
2314,1,420,422
2315,20,421,450
2316,13,421,426
2317,5,421,181
2318,16,421,280
2319,18,421,69
2320,2,421,383
2321,17,421,59
2322,8,422,35
2323,13,422,103
2324,8,422,257
2325,2,422,213
2326,8,422,368
2327,9,422,212
2328,18,422,92
2329,8,422,446
2330,11,422,427
2331,12,422,120
2332,3,423,484
2333,16,423,155
2334,20,423,281
2335,11,423,334
2336,11,423,491
2337,14,424,210
2338,16,424,166
2339,12,425,144
2340,11,425,483
2341,3,425,250
2342,10,425,479
2343,6,425,407
2344,6,425,197
2345,10,426,36
2346,11,426,348
2347,13,426,471
2348,12,426,66
2349,19,426,111
2350,6,426,415
2351,1,426,373
2352,17,426,499
2353,8,426,310
2354,11,427,325
2355,7,427,350
2356,15,427,453
2357,2,427,323
2358,4,427,480
2359,19,427,384
2360,15,427,218
2361,14,428,442
2362,12,429,427
2363,2,429,275
2364,6,429,193
2365,6,429,399
2366,10,429,460
2367,16,430,372
2368,16,430,14
2369,3,430,411
2370,13,430,459
2371,11,430,436
2372,17,430,346
2373,4,430,469
2374,7,430,246
2375,13,430,134
2376,9,430,296
2377,16,431,315
2378,3,431,360
2379,6,431,405
2380,2,431,319
2381,20,431,454
2382,6,431,260
2383,19,432,445
2384,8,432,211
2385,6,432,221
2386,6,432,390
2387,13,432,248
2388,10,432,305
2389,3,432,123
2390,17,432,153
2391,12,432,380
2392,15,432,317
2393,16,433,91
2394,6,433,7
2395,17,433,435
2396,5,433,388
2397,20,433,419
2398,7,433,310
2399,3,433,223
2400,10,434,149
2401,18,435,396
2402,14,435,49
2403,12,436,451
2404,3,436,484
2405,1,436,274
2406,9,437,132
2407,17,437,373
2408,10,437,258
2409,4,437,163
2410,1,437,494
2411,18,437,343
2412,5,437,344
2413,9,437,155
2414,19,437,33
2415,18,437,91
2416,18,438,85
2417,2,439,368
2418,20,439,120
2419,16,439,141
2420,12,439,312
2421,4,439,271
2422,15,439,268
2423,15,439,250
2424,18,440,266
2425,17,441,282
2426,16,441,70
2427,12,441,344
2428,8,441,470
2429,10,441,49
2430,6,441,251
2431,10,441,377
2432,8,441,360
2433,4,442,346
2434,20,442,111
2435,3,442,90
2436,4,442,61
2437,20,442,102
2438,9,442,299
2439,8,442,137
2440,3,442,442
2441,12,442,431
2442,1,442,141
2443,4,443,497
2444,5,443,76
2445,19,444,426
2446,11,444,147
2447,8,444,212
2448,20,445,234
2449,7,445,294
2450,13,445,228
2451,8,446,79
2452,4,446,333
2453,15,446,445
2454,10,446,346
2455,18,446,404
2456,16,446,219
2457,16,447,268
2458,2,448,217
2459,19,448,282
2460,15,448,431
2461,20,448,439
2462,4,448,362
2463,13,448,127
2464,6,448,11
2465,6,448,17
2466,4,449,428
2467,12,449,268
2468,15,449,480
2469,6,449,376
2470,3,449,124
2471,6,449,92
2472,17,449,81
2473,9,450,386
2474,10,450,158
2475,9,450,86
2476,5,450,431
2477,16,450,381
2478,6,450,152
2479,18,450,319
2480,13,450,346
2481,17,450,23
2482,10,451,472
2483,1,452,469
2484,5,452,307
2485,8,453,11
2486,12,453,132
2487,2,453,358
2488,5,453,428
2489,10,454,335
2490,13,454,317
2491,18,454,416
2492,8,454,405
2493,2,454,198
2494,1,455,427
2495,1,455,101
2496,15,455,241
2497,19,455,84
2498,10,455,284
2499,20,455,204
2500,16,455,97
2501,14,455,323
2502,7,455,267
2503,19,456,370
2504,16,456,182
2505,14,457,312
2506,14,457,270
2507,8,457,435
2508,19,458,224
2509,5,458,228
2510,9,458,321
2511,6,458,116
2512,11,458,332
2513,16,458,264
2514,13,458,372
2515,11,458,124
2516,11,458,243
2517,17,458,144
2518,13,459,404
2519,9,460,199
2520,8,460,442
2521,3,460,441
2522,4,460,452
2523,11,460,422
2524,19,460,100
2525,6,460,116
2526,16,461,193
2527,20,461,166
2528,4,461,326
2529,13,461,264
2530,18,461,321
2531,14,461,310
2532,16,461,393
2533,5,461,70
2534,8,461,215
2535,9,462,442
2536,12,462,381
2537,15,463,81
2538,15,464,45
2539,12,464,129
2540,16,464,73
2541,18,464,482
2542,8,465,83
2543,20,466,49
2544,12,466,433
2545,10,466,487
2546,19,466,451
2547,20,466,400
2548,6,466,376
2549,19,467,98
2550,19,467,140
2551,20,467,268
2552,7,467,418
2553,1,467,112
2554,11,468,243
2555,1,469,288
2556,10,469,220
2557,17,469,466
2558,2,469,179
2559,1,469,267
2560,7,469,164
2561,15,470,325
2562,13,470,78
2563,15,471,63
2564,8,472,93
2565,3,472,273
2566,12,472,132
2567,19,472,60
2568,1,472,32
2569,4,472,401
2570,19,472,402
2571,10,473,455
2572,14,473,353
2573,7,473,340
2574,16,473,430
2575,18,473,301
2576,1,473,405
2577,8,473,358
2578,13,474,66
2579,15,474,145
2580,11,474,433
2581,13,474,362
2582,4,474,209
2583,19,474,223
2584,3,475,138
2585,1,475,16
2586,8,475,429
2587,17,475,475
2588,15,475,177
2589,15,475,395
2590,7,476,122
2591,18,476,474
2592,3,476,26
2593,19,476,108
2594,13,476,10
2595,13,476,299
2596,15,476,385
2597,18,477,115
2598,2,478,93
2599,10,478,74
2600,11,478,39
2601,5,478,437
2602,6,478,255
2603,14,478,342
2604,4,478,291
2605,18,478,157
2606,2,478,17
2607,13,478,155
2608,18,479,45
2609,9,479,97
2610,17,480,211
2611,7,480,318
2612,10,480,396
2613,4,480,231
2614,20,480,345
2615,9,480,212
2616,15,481,360
2617,20,481,266
2618,14,481,355
2619,11,481,165
2620,9,481,226
2621,7,481,114
2622,5,481,145
2623,12,482,43
2624,13,482,192
2625,7,482,96
2626,17,482,233
2627,16,482,488
2628,11,482,400
2629,11,482,457
2630,10,482,191
2631,12,482,258
2632,16,482,239
2633,4,483,226
2634,11,483,233
2635,10,483,272
2636,18,483,102
2637,9,484,157
2638,18,484,85
2639,6,484,308
2640,2,484,155
2641,11,485,319
2642,2,485,194
2643,7,485,7
2644,9,485,355
2645,15,485,388
2646,6,485,296
2647,18,485,394
2648,11,485,147
2649,4,485,213
2650,8,485,27
2651,8,486,215
2652,18,486,276
2653,4,486,260
2654,6,486,188
2655,4,486,395
2656,11,486,451
2657,16,486,78
2658,1,487,269
2659,9,487,89
2660,17,487,434
2661,19,487,84
2662,12,487,346
2663,1,488,63
2664,7,488,170
2665,4,488,167
2666,12,488,149
2667,16,488,113
2668,10,488,325
2669,12,489,484
2670,3,489,166
2671,13,489,132
2672,18,489,284
2673,12,489,283
2674,9,489,320
2675,11,489,381
2676,1,489,384
2677,15,490,200
2678,5,490,477
2679,17,490,232
2680,14,490,187
2681,6,491,334
2682,8,491,423
2683,6,491,412
2684,15,491,354
2685,4,491,446
2686,1,491,175
2687,18,491,66
2688,9,492,351
2689,5,492,190
2690,20,492,13
2691,7,492,477
2692,8,493,242
2693,16,493,125
2694,14,493,50
2695,18,493,435
2696,16,493,63
2697,9,493,257
2698,1,493,152
2699,13,494,444
2700,9,494,303
2701,17,495,217
2702,14,495,393
2703,5,495,249
2704,9,495,324
2705,2,495,15
2706,4,495,269
2707,5,495,31
2708,16,496,427
2709,10,497,364
2710,2,497,156
2711,17,497,354
2712,1,497,446
2713,1,497,388
2714,11,497,88
2715,20,497,86
2716,5,497,490
2717,7,497,391
2718,12,497,116
2719,4,498,192
2720,6,498,386
2721,15,498,99
2722,12,498,11
2723,2,498,431
2724,8,498,75
2725,16,498,320
2726,19,499,287
2727,17,499,396
2728,6,499,310
2729,8,499,323
2730,6,500,353
2731,14,500,272
2732,10,500,270
2733,12,500,253
2734,2,500,424
2735,4,500,108
2736,7,500,119
2737,11,500,436
2738,16,501,144
2739,20,502,229
2740,8,502,422
2741,10,502,338
2742,9,503,90
2743,12,504,46
2744,6,504,395
2745,13,504,172
2746,12,504,248
2747,2,505,371
2748,7,506,263
2749,7,507,189
2750,20,507,388
2751,1,507,320
2752,20,507,438
2753,1,507,432
2754,5,507,390
2755,14,507,495
2756,1,507,249
2757,1,507,179
2758,17,508,88
2759,1,509,93
2760,1,509,54
2761,16,509,489
2762,15,509,462
2763,18,509,179
2764,1,509,25
2765,10,509,201
2766,10,509,457
2767,12,509,67
2768,17,510,218
2769,12,510,41
2770,17,510,118
2771,19,510,193
2772,16,510,433
2773,12,510,121
2774,18,511,143
2775,20,511,56
2776,13,511,1
2777,16,512,191
2778,10,512,418
2779,5,512,346
2780,14,512,83
2781,10,512,465
2782,3,512,326
2783,13,512,222
2784,15,512,371
2785,11,512,335
2786,13,512,33
2787,7,513,201
2788,3,513,195
2789,9,513,29
2790,12,513,118
2791,17,513,252
2792,9,513,320
2793,3,513,27
2794,1,513,37
2795,2,513,211
2796,20,513,365
2797,1,514,120
2798,6,514,297
2799,1,514,358
2800,3,514,67
2801,1,514,94
2802,9,514,265
2803,7,515,327
2804,7,516,491
2805,10,516,402
2806,18,516,443
2807,1,516,99
2808,14,516,128
2809,3,516,139
2810,1,516,94
2811,13,516,207
2812,12,516,289
2813,15,516,432
2814,16,517,431
2815,4,517,352
2816,20,517,253
2817,9,517,173
2818,7,517,169
2819,13,517,117
2820,20,517,359
2821,7,517,466
2822,16,517,155
2823,4,517,247
2824,16,518,151
2825,15,518,346
2826,19,518,121
2827,8,518,275
2828,12,518,13
2829,20,518,471
2830,20,519,262
2831,4,519,17
2832,18,519,260
2833,17,519,259
2834,7,519,269
2835,9,519,277
2836,3,519,162
2837,18,519,354
2838,7,519,179
2839,4,519,343
2840,9,520,300
2841,18,520,400
2842,10,520,128
2843,5,520,141
2844,18,520,150
2845,6,520,257
2846,13,520,422
2847,6,520,240
2848,7,520,479
2849,11,521,457
2850,10,521,485
2851,7,521,212
2852,8,521,404
2853,10,521,1
2854,16,521,157
2855,10,521,104
2856,10,521,347
2857,7,521,378
2858,6,522,222
2859,19,522,430
2860,16,522,96
2861,10,522,449
2862,7,522,466
2863,19,523,71
2864,8,524,211
2865,17,524,150
2866,4,524,310
2867,1,524,277
2868,12,524,391
2869,8,525,305
2870,18,525,91
2871,8,525,177
2872,12,525,169
2873,6,525,407
2874,6,525,90
2875,4,525,274
2876,8,525,101
2877,1,525,466
2878,8,526,386
2879,5,526,64
2880,17,526,126
2881,12,526,175
2882,15,526,39
2883,20,526,460
2884,18,526,283
2885,5,527,214
2886,12,527,85
2887,2,527,226
2888,12,527,245
2889,6,527,67
2890,8,527,142
2891,11,527,60
2892,19,527,7
2893,2,527,490
2894,14,528,24
2895,7,529,307
2896,13,529,352
2897,19,529,366
2898,17,529,292
2899,3,529,347
2900,4,530,165
2901,19,530,56
2902,5,530,61
2903,17,530,51
2904,10,531,87
2905,16,531,191
2906,4,532,461
2907,8,532,287
2908,4,532,225
2909,17,532,261
2910,5,533,429
2911,2,533,383
2912,13,533,457
2913,13,533,115
2914,17,533,435
2915,18,533,135
2916,17,534,423
2917,10,534,253
2918,4,534,171
2919,10,535,28
2920,16,535,127
2921,20,535,407
2922,12,535,168
2923,19,535,122
2924,10,535,20
2925,18,535,336
2926,12,535,357
2927,18,535,396
2928,8,535,308
2929,7,536,247
2930,13,536,105
2931,1,536,432
2932,10,536,375
2933,2,536,404
2934,9,536,322
2935,16,537,199
2936,2,537,320
2937,16,537,39
2938,19,538,350
2939,10,538,1
2940,2,539,376
2941,10,539,271
2942,4,539,90
2943,16,539,208
2944,20,539,240
2945,2,539,475
2946,7,540,22
2947,1,540,478
2948,15,540,347
2949,9,540,263
2950,4,540,190
2951,12,540,196
2952,15,540,410
2953,4,540,432
2954,17,540,92
2955,17,540,382
2956,6,541,421
2957,14,541,81
2958,18,541,94
2959,6,541,284
2960,8,541,158
2961,5,541,310
2962,17,541,241
2963,4,541,201
2964,15,541,352
2965,17,542,401
2966,9,542,276
2967,13,542,312
2968,17,542,22
2969,9,542,223
2970,5,542,207
2971,15,542,372
2972,3,542,345
2973,3,542,18
2974,19,542,309
2975,18,543,337
2976,8,543,122
2977,12,543,322
2978,19,543,34
2979,15,543,429
2980,11,543,161
2981,13,543,256
2982,20,543,343
2983,13,544,332
2984,4,544,330
2985,5,544,450
2986,6,544,279
2987,6,545,472
2988,9,545,311
2989,14,545,475
2990,19,545,265
2991,17,545,90
2992,20,545,344
2993,7,545,489
2994,8,545,78
2995,19,546,446
2996,12,546,398
2997,9,546,72
2998,5,546,451
2999,19,546,453
3000,16,546,483
3001,2,546,294
3002,10,547,167
3003,5,547,15
3004,5,547,4
3005,20,547,101
3006,11,548,495
3007,3,548,41
3008,4,548,396
3009,9,548,36
3010,16,548,63
3011,1,549,189
3012,7,549,152
3013,2,549,292
3014,7,550,399
3015,8,550,191
3016,12,550,467
3017,5,550,143
3018,6,550,17
3019,11,550,430
3020,12,550,409
3021,5,551,26
3022,5,551,256
3023,6,551,328
3024,17,551,266
3025,6,551,321
3026,15,551,477
3027,15,552,142
3028,17,553,277
3029,12,553,479
3030,14,553,152
3031,6,553,44
3032,7,553,376
3033,18,553,144
3034,12,553,391
3035,11,553,155
3036,1,553,99
3037,3,553,122
3038,5,554,128
3039,8,554,185
3040,3,554,396
3041,19,554,307
3042,7,554,202
3043,2,554,21
3044,19,555,211
3045,9,555,154
3046,16,555,108
3047,2,556,247
3048,5,556,341
3049,9,557,239
3050,13,557,262
3051,13,557,12
3052,12,557,152
3053,12,557,40
3054,11,557,494
3055,6,558,138
3056,6,558,28
3057,9,558,276
3058,12,558,349
3059,12,558,398
3060,2,558,88
3061,20,558,455
3062,17,558,225
3063,4,559,190
3064,16,559,384
3065,14,559,378
3066,2,559,208
3067,6,559,447
3068,19,559,352
3069,2,559,81
3070,2,559,336
3071,15,560,115
3072,12,561,49
3073,10,561,364
3074,2,561,269
3075,10,561,414
3076,17,561,63
3077,6,562,51
3078,14,562,275
3079,4,562,499
3080,2,562,112
3081,13,562,147
3082,2,563,149
3083,16,563,97
3084,16,563,75
3085,8,563,24
3086,6,563,53
3087,17,563,124
3088,19,563,15
3089,5,563,77
3090,12,564,142
3091,2,564,470
3092,3,565,296
3093,9,565,400
3094,14,565,333
3095,4,565,444
3096,6,565,358
3097,12,565,463
3098,11,565,247
3099,2,565,233
3100,11,565,443
3101,9,565,368
3102,15,566,428
3103,20,566,6
3104,14,566,10
3105,14,567,410
3106,17,568,484
3107,16,568,454
3108,13,568,254
3109,3,568,54
3110,5,568,123
3111,12,568,493
3112,16,568,483
3113,16,569,136
3114,5,569,461
3115,8,569,438
3116,6,570,471
3117,13,570,466
3118,5,570,31
3119,11,570,323
3120,17,571,48
3121,13,571,251
3122,2,572,385
3123,18,572,112
3124,10,572,378
3125,2,572,387
3126,20,572,467
3127,16,572,348
3128,8,572,301
3129,12,572,263
3130,4,572,91
3131,14,572,470
3132,8,573,232
3133,6,573,165
3134,1,573,394
3135,13,573,276
3136,7,574,367
3137,8,574,420
3138,13,574,243
3139,3,574,129
3140,17,574,125
3141,10,574,350
3142,14,574,157
3143,15,575,33
3144,17,575,189
3145,4,575,443
3146,8,575,301
3147,4,576,150
3148,8,576,142
3149,10,576,319
3150,5,576,218
3151,20,576,294
3152,12,576,394
3153,7,576,441
3154,4,576,15
3155,11,577,454
3156,9,577,473
3157,10,577,393
3158,10,577,232
3159,10,577,338
3160,2,577,326
3161,2,578,122
3162,3,578,49
3163,2,578,409
3164,15,578,68
3165,17,578,462
3166,20,578,420
3167,19,578,164
3168,7,578,80
3169,7,578,322
3170,7,578,48
3171,15,579,287
3172,16,579,106
3173,12,579,139
3174,5,580,39
3175,4,580,476
3176,16,581,354
3177,11,581,133
3178,6,581,16
3179,3,581,249
3180,7,581,210
3181,1,581,84
3182,18,582,391
3183,14,582,203
3184,12,582,266
3185,1,582,68
3186,11,582,416
3187,7,582,475
3188,7,582,330
3189,15,582,63
3190,5,583,155
3191,8,583,70
3192,3,584,476
3193,6,584,472
3194,15,584,266
3195,8,584,345
3196,20,584,364
3197,6,584,192
3198,4,584,388
3199,11,584,309
3200,19,585,149
3201,7,585,123
3202,1,586,411
3203,16,586,441
3204,6,587,117
3205,18,588,320
3206,6,588,334
3207,10,589,26
3208,15,589,199
3209,18,589,495
3210,12,589,96
3211,14,589,116
3212,6,589,294
3213,19,589,73
3214,14,589,29
3215,16,590,56
3216,14,590,82
3217,16,590,473
3218,18,590,424
3219,2,590,375
3220,7,590,64
3221,13,590,173
3222,2,590,236
3223,17,590,373
3224,2,590,35
3225,19,591,25
3226,10,591,157
3227,1,591,164
3228,13,591,84
3229,3,592,111
3230,19,592,124
3231,15,592,366
3232,13,592,281
3233,20,592,284
3234,12,592,333
3235,12,592,356
3236,16,592,50
3237,1,592,406
3238,2,592,153
3239,16,593,274
3240,17,593,279
3241,5,593,94
3242,12,593,265
3243,17,593,253
3244,20,593,48
3245,18,594,292
3246,9,594,62
3247,16,594,131
3248,8,595,106
3249,19,595,140
3250,14,595,14
3251,9,595,7
3252,6,595,159
3253,20,595,494
3254,13,595,422
3255,7,595,307
3256,17,595,115
3257,17,596,99
3258,12,597,359
3259,1,597,22
3260,16,597,396
3261,17,597,105
3262,9,598,30
3263,16,598,21
3264,14,599,425
3265,4,599,485
3266,8,600,348
3267,2,600,259
3268,2,600,428
3269,11,600,103
3270,19,600,19
3271,5,600,210
3272,1,600,378
3273,20,600,282
3274,1,601,145
3275,20,601,361
3276,19,601,394
3277,7,601,161
3278,15,601,478
3279,8,601,21
3280,16,602,5
3281,11,602,430
3282,20,602,494
3283,3,602,204
3284,6,602,253
3285,13,603,258
3286,8,603,417
3287,6,603,429
3288,19,603,142
3289,13,603,235
3290,16,604,254
3291,15,604,36
3292,3,604,124
3293,12,604,276
3294,1,604,198
3295,15,604,372
3296,19,604,232
3297,16,604,408
3298,18,605,33
3299,1,605,423
3300,1,605,96
3301,3,605,187
3302,18,605,87
3303,19,606,394
3304,17,606,471
3305,6,606,192
3306,13,606,53
3307,15,606,477
3308,6,606,244
3309,10,607,380
3310,12,607,272
3311,6,607,185
3312,15,607,170
3313,8,608,177
3314,16,608,423
3315,17,608,495
3316,17,608,167
3317,10,608,197
3318,1,608,189
3319,14,608,392
3320,8,608,213
3321,14,608,29
3322,8,608,330
3323,9,609,231
3324,17,609,291
3325,11,609,262
3326,3,609,35
3327,7,609,329
3328,4,609,245
3329,1,609,51
3330,20,610,204
3331,9,610,108
3332,4,610,125
3333,11,610,103
3334,14,610,377
3335,8,610,479
3336,19,611,164
3337,6,611,7
3338,1,611,496
3339,7,612,323
3340,10,612,458
3341,2,612,470
3342,2,612,21
3343,20,612,206
3344,3,612,201
3345,11,612,30
3346,3,612,2
3347,4,612,132
3348,5,612,265
3349,14,613,227
3350,13,613,274
3351,6,613,17
3352,11,613,498
3353,10,613,90
3354,19,613,308
3355,18,613,56
3356,14,614,59
3357,1,614,40
3358,13,614,441
3359,7,614,398
3360,6,614,291
3361,14,614,200
3362,10,614,388
3363,9,614,92
3364,3,614,395
3365,9,614,51
3366,4,615,310
3367,12,616,156
3368,5,616,21
3369,18,616,151
3370,13,616,136
3371,4,616,491
3372,8,617,340
3373,16,618,63
3374,19,618,321
3375,10,618,373
3376,10,618,7
3377,14,618,342
3378,4,618,190
3379,12,618,158
3380,19,618,142
3381,1,619,415
3382,14,620,270
3383,2,620,254
3384,3,620,480
3385,14,620,63
3386,3,620,136
3387,1,620,343
3388,1,620,401
3389,11,620,162
3390,19,620,22
3391,10,621,57
3392,17,621,84
3393,5,621,80
3394,2,621,248
3395,16,621,227
3396,2,621,165
3397,9,622,230
3398,15,622,323
3399,11,622,67
3400,3,622,208
3401,10,622,392
3402,12,623,419
3403,14,623,131
3404,6,624,283
3405,17,625,260
3406,19,625,331
3407,6,625,309
3408,3,625,443
3409,3,625,301
3410,7,626,159
3411,17,626,399
3412,10,626,248
3413,1,627,57
3414,17,627,377
3415,12,627,298
3416,4,627,165
3417,1,628,486
3418,19,628,134
3419,12,629,355
3420,9,629,274
3421,10,629,319
3422,9,629,32
3423,5,629,333
3424,6,629,371
3425,17,630,247
3426,14,630,168
3427,13,630,426
3428,19,631,114
3429,15,631,344
3430,9,631,23
3431,2,631,99
3432,7,631,152
3433,13,632,149
3434,5,632,150
3435,14,632,436
3436,15,632,6
3437,1,632,246
3438,15,632,272
3439,9,632,411
3440,20,632,93
3441,10,632,263
3442,7,633,172
3443,8,633,254
3444,6,633,431
3445,12,633,147
3446,19,633,354
3447,20,633,274
3448,2,633,314
3449,11,633,444
3450,19,633,209
3451,5,634,481
3452,14,634,40
3453,1,635,280
3454,13,635,114
3455,1,635,228
3456,15,635,338
3457,15,636,404
3458,12,636,298
3459,18,636,61
3460,15,636,38
3461,8,636,219
3462,16,636,416
3463,18,636,417
3464,9,636,277
3465,18,637,500
3466,11,637,23
3467,1,637,367
3468,2,637,478
3469,13,637,66
3470,10,637,275
3471,1,637,211
3472,10,637,351
3473,15,638,42
3474,9,638,38
3475,7,638,207
3476,9,638,50
3477,8,638,396
3478,15,639,280
3479,3,640,67
3480,10,641,449
3481,6,641,492
3482,1,641,225
3483,8,641,33
3484,17,641,32
3485,2,641,353
3486,17,641,306
3487,6,641,138
3488,19,641,489
3489,10,641,447
3490,20,642,424
3491,15,642,216
3492,19,642,139
3493,11,642,350
3494,11,643,280
3495,4,643,210
3496,10,643,355
3497,19,643,429
3498,20,643,168
3499,20,643,7
3500,20,643,486
3501,18,644,231
3502,8,644,152
3503,19,644,189
3504,11,645,20
3505,8,645,455
3506,2,645,337
3507,14,645,28
3508,4,645,102
3509,5,645,257
3510,15,645,364
3511,19,645,367
3512,6,645,362
3513,7,646,181
3514,17,646,54
3515,20,647,133
3516,11,647,50
3517,2,647,145
3518,14,647,35
3519,4,647,451
3520,20,647,460
3521,6,647,267
3522,13,647,454
3523,9,647,388
3524,11,648,428
3525,9,648,492
3526,14,648,188
3527,7,648,164
3528,18,648,236
3529,14,648,83
3530,17,648,168
3531,9,648,214
3532,13,648,453
3533,16,649,193
3534,14,649,214
3535,18,649,47
3536,12,649,431
3537,12,649,340
3538,3,649,321
3539,6,649,157
3540,3,649,287
3541,4,650,456
3542,6,651,253
3543,13,651,448
3544,14,651,13
3545,12,651,75
3546,8,651,257
3547,1,651,360
3548,7,651,312
3549,5,651,87
3550,10,651,264
3551,10,651,377
3552,13,652,40
3553,14,652,231
3554,15,652,181
3555,14,652,51
3556,7,652,42
3557,20,652,385
3558,4,652,259
3559,17,653,64
3560,20,653,77
3561,1,653,40
3562,12,653,211
3563,5,653,4
3564,12,653,406
3565,6,653,258
3566,15,653,325
3567,11,653,165
3568,19,654,55
3569,10,654,79
3570,17,654,250
3571,8,654,40
3572,3,655,389
3573,16,655,194
3574,15,655,369
3575,9,655,21
3576,13,656,163
3577,13,656,39
3578,3,656,108
3579,3,656,279
3580,13,657,405
3581,10,657,220
3582,19,657,166
3583,5,657,358
3584,13,658,334
3585,15,658,221
3586,8,658,235
3587,1,658,34
3588,3,658,318
3589,8,658,18
3590,15,658,210
3591,2,659,432
3592,15,660,483
3593,13,660,221
3594,16,660,485
3595,18,660,289
3596,7,660,318
3597,19,660,461
3598,10,660,351
3599,20,661,164
3600,11,661,468
3601,12,661,75
3602,5,662,279
3603,18,662,180
3604,2,663,491
3605,9,663,261
3606,19,663,479
3607,15,663,190
3608,1,663,334
3609,9,663,387
3610,11,663,339
3611,13,664,237
3612,19,664,291
3613,15,664,136
3614,4,664,152
3615,8,664,121
3616,7,664,431
3617,12,664,56
3618,5,664,473
3619,8,664,66
3620,13,665,121
3621,12,665,477
3622,11,665,348
3623,18,665,143
3624,14,665,208
3625,8,665,265
3626,4,665,107
3627,7,666,156
3628,15,666,321
3629,20,666,277
3630,8,666,100
3631,9,666,373
3632,6,666,257
3633,16,667,175
3634,9,667,326
3635,6,667,33
3636,19,668,126
3637,4,668,221
3638,4,668,8
3639,5,668,365
3640,9,668,372
3641,15,668,7
3642,6,668,64
3643,15,668,103
3644,17,668,165
3645,15,668,246
3646,5,669,378
3647,3,669,197
3648,10,669,219
3649,18,669,336
3650,11,669,167
3651,20,670,241
3652,13,670,377
3653,7,670,418
3654,8,670,238
3655,20,670,498
3656,4,670,323
3657,12,670,52
3658,13,670,22
3659,18,670,60
3660,15,671,246
3661,18,671,405
3662,18,671,8
3663,2,671,180
3664,2,671,140
3665,1,671,46
3666,1,671,215
3667,10,671,440
3668,8,672,456
3669,15,672,62
3670,17,672,50
3671,10,672,119
3672,4,672,38
3673,20,672,408
3674,11,672,231
3675,9,672,329
3676,14,672,199
3677,8,672,5
3678,2,673,170
3679,10,674,53
3680,10,674,369
3681,3,674,1
3682,17,674,220
3683,2,674,48
3684,4,674,322
3685,15,674,39
3686,1,675,11
3687,10,675,439
3688,7,675,183
3689,9,675,85
3690,8,675,215
3691,1,675,376
3692,16,675,433
3693,15,675,28
3694,17,675,177
3695,18,675,265
3696,18,676,142
3697,1,676,329
3698,12,676,234
3699,16,676,13
3700,10,676,294
3701,9,676,246
3702,8,676,155
3703,9,676,48
3704,6,676,352
3705,2,677,250
3706,10,677,95
3707,1,677,42
3708,12,677,337
3709,7,677,380
3710,2,677,216
3711,16,677,35
3712,17,677,230
3713,4,678,4
3714,9,678,396
3715,2,678,469
3716,3,678,176
3717,20,679,115
3718,2,679,332
3719,20,679,303
3720,4,679,238
3721,16,680,473
3722,3,680,427
3723,7,680,358
3724,16,680,386
3725,2,680,223
3726,8,681,498
3727,20,681,37
3728,11,681,223
3729,14,681,313
3730,3,682,416
3731,7,682,452
3732,8,683,450
3733,17,683,95
3734,19,683,477
3735,18,683,377
3736,6,683,132
3737,12,683,465
3738,20,683,344
3739,4,683,295
3740,12,683,466
3741,8,683,270
3742,3,684,282
3743,2,685,343
3744,13,685,22
3745,7,685,400
3746,17,685,261
3747,19,685,291
3748,20,685,398
3749,14,685,170
3750,1,685,390
3751,7,685,357
3752,16,685,384
3753,19,686,17
3754,13,686,424
3755,20,686,8
3756,6,686,493
3757,2,686,329
3758,7,686,109
3759,3,686,474
3760,4,687,300
3761,7,687,327
3762,9,687,491
3763,4,687,262
3764,6,687,458
3765,13,687,180
3766,9,687,366
3767,8,687,362
3768,1,688,170
3769,15,688,137
3770,8,688,66
3771,1,688,144
3772,8,688,47
3773,8,688,61
3774,2,688,318
3775,6,688,220
3776,3,688,150
3777,1,689,383
3778,6,689,433
3779,3,689,188
3780,20,689,422
3781,18,689,158
3782,8,689,498
3783,4,689,495
3784,10,689,166
3785,6,690,9
3786,11,690,446
3787,4,691,27
3788,2,692,176
3789,11,692,414
3790,9,692,210
3791,12,692,413
3792,19,693,333
3793,1,693,10
3794,8,693,420
3795,13,693,375
3796,3,693,402
3797,17,693,165
3798,8,693,456
3799,20,693,469
3800,18,694,227
3801,5,694,393
3802,6,694,213
3803,10,694,269
3804,18,694,198
3805,11,695,179
3806,2,695,196
3807,17,695,135
3808,18,695,199
3809,5,695,491
3810,16,695,175
3811,4,695,485
3812,14,695,385
3813,19,695,186
3814,17,695,246
3815,4,696,35
3816,12,696,398
3817,18,696,250
3818,14,696,264
3819,3,696,180
3820,17,696,229
3821,3,696,266
3822,2,696,361
3823,4,696,308
3824,6,696,472
3825,13,697,123
3826,8,698,488
3827,16,698,404
3828,20,698,117
3829,2,699,440
3830,8,699,304
3831,13,699,418
3832,15,699,159
3833,20,699,65
3834,13,700,168
3835,12,700,329
3836,15,700,481
3837,13,701,38
3838,14,702,383
3839,12,702,462
3840,1,702,433
3841,16,703,202
3842,3,703,187
3843,1,703,176
3844,14,704,307
3845,7,704,225
3846,15,704,114
3847,5,705,145
3848,8,705,284
3849,9,705,322
3850,11,705,133
3851,10,705,262
3852,5,706,15
3853,6,706,157
3854,16,706,96
3855,2,706,297
3856,18,706,151
3857,3,706,289
3858,13,707,231
3859,13,707,321
3860,6,707,168
3861,7,707,257
3862,10,707,430
3863,5,707,330
3864,13,708,89
3865,10,708,139
3866,15,708,383
3867,5,708,390
3868,19,708,175
3869,18,708,133
3870,9,709,373
3871,5,709,39
3872,5,709,213
3873,2,709,24
3874,17,709,23
3875,9,709,241
3876,17,709,438
3877,15,710,266
3878,19,711,447
3879,12,711,405
3880,8,711,268
3881,7,711,24
3882,10,711,12
3883,17,711,140
3884,17,711,374
3885,9,712,115
3886,1,712,366
3887,4,712,31
3888,16,713,457
3889,13,713,36
3890,20,713,290
3891,18,714,139
3892,9,714,259
3893,19,714,260
3894,13,714,391
3895,11,714,165
3896,8,714,441
3897,3,714,383
3898,6,715,63
3899,2,716,110
3900,2,716,162
3901,11,716,333
3902,4,716,41
3903,3,716,390
3904,1,716,160
3905,16,716,476
3906,8,717,173
3907,13,717,68
3908,20,717,431
3909,3,717,454
3910,5,717,12
3911,4,717,274
3912,12,717,37
3913,9,717,489
3914,2,717,203
3915,15,718,258
3916,1,719,437
3917,14,719,293
3918,2,719,62
3919,8,719,119
3920,10,719,4
3921,16,720,210
3922,1,720,123
3923,9,720,268
3924,10,720,494
3925,10,720,418
3926,7,720,269
3927,18,720,179
3928,8,720,149
3929,9,720,489
3930,14,721,260
3931,16,721,461
3932,15,721,296
3933,14,721,231
3934,10,722,169
3935,17,722,235
3936,3,722,7
3937,19,723,91
3938,17,723,175
3939,5,723,359
3940,14,724,76
3941,14,724,102
3942,2,725,382
3943,20,725,69
3944,16,726,381
3945,20,726,34
3946,14,726,244
3947,18,726,129
3948,6,726,427
3949,13,726,362
3950,8,726,418
3951,9,726,210
3952,1,727,49
3953,10,727,396
3954,5,727,460
3955,4,727,239
3956,9,727,181
3957,13,727,368
3958,15,727,231
3959,14,728,253
3960,5,728,277
3961,15,728,425
3962,17,728,478
3963,7,728,21
3964,3,728,302
3965,5,728,419
3966,18,729,219
3967,14,729,496
3968,14,729,373
3969,12,729,24
3970,2,729,357
3971,9,729,164
3972,17,729,468
3973,15,729,230
3974,5,730,58
3975,6,730,362
3976,13,730,306
3977,2,730,340
3978,4,730,437
3979,9,730,238
3980,5,731,16
3981,5,731,153
3982,4,731,207
3983,2,731,304
3984,17,731,42
3985,17,731,279
3986,17,732,418
3987,9,732,496
3988,8,733,432
3989,7,733,394
3990,12,734,225
3991,16,734,354
3992,3,734,78
3993,17,734,348
3994,2,734,268
3995,6,734,169
3996,15,735,120
3997,7,735,342
3998,9,735,410
3999,5,735,309
4000,15,735,334
4001,14,735,151
4002,17,735,328
4003,20,735,187
4004,10,736,255
4005,8,736,92
4006,5,736,492
4007,11,737,495
4008,5,737,294
4009,5,737,433
4010,2,737,311
4011,7,737,115
4012,3,738,328
4013,13,738,451
4014,20,738,51
4015,1,738,252
4016,5,738,152
4017,10,738,356
4018,13,738,471
4019,14,738,13
4020,12,738,77
4021,2,739,150
4022,4,739,406
4023,4,739,281
4024,18,740,482
4025,12,740,416
4026,7,740,276
4027,13,741,373
4028,15,741,475
4029,3,741,206
4030,15,742,158
4031,15,742,282
4032,6,742,378
4033,16,743,423
4034,3,743,462
4035,6,744,230
4036,18,744,28
4037,5,744,332
4038,20,744,311
4039,20,745,403
4040,10,745,242
4041,3,745,428
4042,20,745,405
4043,17,745,340
4044,5,745,69
4045,5,746,409
4046,4,746,225
4047,9,746,474
4048,2,746,217
4049,15,747,184
4050,16,747,179
4051,9,747,290
4052,16,747,464
4053,10,747,53
4054,1,747,363
4055,18,747,309
4056,17,747,243
4057,14,747,45
4058,15,748,232
4059,14,748,197
4060,11,748,487
4061,15,748,202
4062,5,748,127
4063,19,748,246
4064,6,748,83
4065,5,749,10
4066,15,749,14
4067,2,749,323
4068,1,749,25
4069,18,749,277
4070,4,749,96
4071,7,749,299
4072,11,749,439
4073,18,750,57
4074,7,750,243
4075,15,750,483
4076,1,750,452
4077,3,751,225
4078,3,751,137
4079,6,751,496
4080,19,752,351
4081,2,752,281
4082,7,752,311
4083,19,752,410
4084,13,752,332
4085,18,752,366
4086,1,752,137
4087,9,753,194
4088,16,753,208
4089,5,753,446
4090,11,753,17
4091,18,753,209
4092,15,754,234
4093,15,754,375
4094,20,754,128
4095,8,755,32
4096,5,755,343
4097,20,755,390
4098,15,755,146
4099,11,756,72
4100,10,756,309
4101,5,756,210
4102,18,756,33
4103,14,756,44
4104,8,756,43
4105,11,756,171
4106,5,757,225
4107,3,757,496
4108,15,757,52
4109,15,757,364
4110,16,757,262
4111,7,757,367
4112,5,757,445
4113,20,758,27
4114,2,759,461
4115,15,760,3
4116,6,760,460
4117,7,760,19
4118,20,760,408
4119,19,760,497
4120,1,761,238
4121,9,761,309
4122,19,761,253
4123,20,761,231
4124,8,761,495
4125,13,761,59
4126,12,761,113
4127,1,761,223
4128,16,761,384
4129,7,762,112
4130,11,762,343
4131,13,762,153
4132,9,762,350
4133,16,762,23
4134,15,762,133
4135,7,762,256
4136,18,762,110
4137,16,762,353
4138,20,762,456
4139,2,763,311
4140,16,763,268
4141,17,763,280
4142,5,763,36
4143,1,764,67
4144,3,764,315
4145,20,764,275
4146,1,764,462
4147,16,764,216
4148,18,764,384
4149,16,765,498
4150,13,765,298
4151,11,765,428
4152,1,765,183
4153,10,765,338
4154,13,765,487
4155,7,766,25
4156,18,766,251
4157,13,766,315
4158,4,766,155
4159,20,766,183
4160,5,766,436
4161,14,767,257
4162,5,767,83
4163,9,767,2
4164,13,767,428
4165,1,767,34
4166,16,767,141
4167,19,767,357
4168,16,767,143
4169,4,768,474
4170,16,768,78
4171,17,768,75
4172,19,768,10
4173,10,769,255
4174,10,769,291
4175,9,769,389
4176,20,769,366
4177,1,769,467
4178,20,769,351
4179,12,769,26
4180,1,769,382
4181,18,769,450
4182,8,769,286
4183,2,770,319
4184,14,771,452
4185,3,772,183
4186,5,772,442
4187,15,772,276
4188,13,772,351
4189,4,772,431
4190,9,772,336
4191,20,773,76
4192,16,773,427
4193,17,773,121
4194,1,773,379
4195,1,773,190
4196,1,773,281
4197,6,773,11
4198,16,773,242
4199,10,773,10
4200,1,773,24
4201,13,774,243
4202,6,774,37
4203,14,774,117
4204,6,775,222
4205,2,775,492
4206,1,775,364
4207,12,775,22
4208,4,776,148
4209,5,776,450
4210,7,776,201
4211,9,776,321
4212,13,776,49
4213,3,776,48
4214,13,776,493
4215,6,776,366
4216,4,777,86
4217,2,777,321
4218,15,777,309
4219,6,777,462
4220,9,777,252
4221,5,778,475
4222,4,778,152
4223,17,778,437
4224,16,778,78
4225,19,778,315
4226,13,778,34
4227,16,778,66
4228,11,778,3
4229,13,779,446
4230,12,779,339
4231,19,779,233
4232,8,779,344
4233,1,779,278
4234,19,779,302
4235,13,779,150
4236,18,780,369
4237,19,780,320
4238,5,780,403
4239,9,780,141
4240,4,780,287
4241,10,780,33
4242,20,780,454
4243,7,781,283
4244,7,782,321
4245,10,782,214
4246,14,782,246
4247,2,782,203
4248,8,782,340
4249,10,782,257
4250,12,782,306
4251,17,782,294
4252,6,782,133
4253,2,782,287
4254,9,783,173
4255,5,783,479
4256,6,783,163
4257,5,783,62
4258,18,783,370
4259,20,783,427
4260,15,783,372
4261,4,783,428
4262,14,783,87
4263,4,783,90
4264,8,784,357
4265,8,784,220
4266,9,784,324
4267,11,784,108
4268,12,784,129
4269,2,784,176
4270,11,784,92
4271,11,784,159
4272,6,784,168
4273,18,784,453
4274,13,785,200
4275,2,785,369
4276,15,785,420
4277,7,785,275
4278,13,786,5
4279,5,786,311
4280,14,786,399
4281,8,787,419
4282,12,787,115
4283,19,787,114
4284,15,787,344
4285,10,787,203
4286,1,787,220
4287,1,788,198
4288,12,788,388
4289,15,788,399
4290,1,789,265
4291,3,789,221
4292,16,790,434
4293,8,790,460
4294,6,790,317
4295,16,790,234
4296,10,790,377
4297,8,790,384
4298,12,790,373
4299,12,790,220
4300,20,790,329
4301,14,791,345
4302,6,791,128
4303,4,791,429
4304,15,791,114
4305,7,791,72
4306,11,791,492
4307,1,792,45
4308,15,792,359
4309,15,792,288
4310,9,792,330
4311,19,792,485
4312,18,792,303
4313,12,793,91
4314,10,793,216
4315,20,793,13
4316,18,793,485
4317,3,794,134
4318,19,794,132
4319,10,794,53
4320,13,794,434
4321,19,795,388
4322,10,795,334
4323,12,795,367
4324,9,795,351
4325,2,795,365
4326,8,795,410
4327,8,795,307
4328,4,796,196
4329,2,796,103
4330,11,796,34
4331,16,796,442
4332,13,796,6
4333,20,796,230
4334,7,796,374
4335,6,796,82
4336,12,796,448
4337,3,796,330
4338,13,797,315
4339,3,797,456
4340,11,797,112
4341,8,797,440
4342,12,798,132
4343,10,798,313
4344,7,798,446
4345,17,799,69
4346,20,799,34
4347,3,799,397
4348,9,799,240
4349,3,799,79
4350,17,799,357
4351,7,799,159
4352,20,799,115
4353,2,800,79
4354,16,800,221
4355,3,800,281
4356,18,800,137
4357,8,800,148
4358,19,801,461
4359,4,801,193
4360,8,801,238
4361,14,801,115
4362,10,801,164
4363,10,801,230
4364,15,801,175
4365,17,801,391
4366,8,802,397
4367,11,803,110
4368,8,803,182
4369,12,803,320
4370,12,803,225
4371,19,803,71
4372,7,803,15
4373,20,803,412
4374,19,803,140
4375,19,803,4
4376,17,804,127
4377,2,805,135
4378,19,805,270
4379,1,805,366
4380,19,805,244
4381,4,805,394
4382,3,805,353
4383,19,805,80
4384,17,805,367
4385,4,805,178
4386,9,806,135
4387,13,806,211
4388,19,807,53
4389,6,807,433
4390,17,807,2
4391,12,807,465
4392,3,807,71
4393,6,807,118
4394,14,807,468
4395,15,807,93
4396,8,807,424
4397,4,807,286
4398,4,808,69
4399,3,809,435
4400,2,809,439
4401,12,809,289
4402,18,809,1
4403,3,809,427
4404,1,809,452
4405,5,809,208
4406,8,809,477
4407,4,809,415
4408,11,810,402
4409,1,810,106
4410,17,810,249
4411,18,810,413
4412,12,810,349
4413,2,810,130
4414,16,810,294
4415,17,810,493
4416,18,810,271
4417,16,810,317
4418,19,811,381
4419,17,812,151
4420,3,812,259
4421,5,812,60
4422,12,812,434
4423,10,812,36
4424,4,812,158
4425,12,812,369
4426,14,812,122
4427,2,812,117
4428,6,812,402
4429,7,813,246
4430,8,813,91
4431,7,813,275
4432,6,813,243
4433,5,813,466
4434,10,814,84
4435,14,814,360
4436,20,814,49
4437,13,815,395
4438,12,815,299
4439,6,815,149
4440,10,815,452
4441,9,815,145
4442,20,815,216
4443,19,816,178
4444,12,816,117
4445,20,817,88
4446,6,817,173
4447,10,817,415
4448,19,817,483
4449,2,817,17
4450,20,818,233
4451,3,818,357
4452,7,818,92
4453,13,819,267
4454,13,819,344
4455,8,820,168
4456,10,820,440
4457,18,820,229
4458,13,820,466
4459,9,820,499
4460,17,820,270
4461,1,820,162
4462,2,820,408
4463,2,821,158
4464,13,821,94
4465,19,821,150
4466,13,821,226
4467,10,822,172
4468,20,822,494
4469,1,822,412
4470,4,822,276
4471,8,822,350
4472,13,822,345
4473,15,822,439
4474,19,822,105
4475,13,823,384
4476,10,823,260
4477,16,823,403
4478,12,824,234
4479,5,824,13
4480,19,824,283
4481,10,824,107
4482,12,824,43
4483,2,824,431
4484,13,824,300
4485,14,824,195
4486,20,825,272
4487,2,826,294
4488,12,826,234
4489,7,826,445
4490,4,826,249
4491,11,826,265
4492,10,826,333
4493,13,827,461
4494,10,827,500
4495,2,828,422
4496,16,828,4
4497,8,828,394
4498,16,828,18
4499,14,828,269
4500,11,828,256
4501,3,829,422
4502,3,829,68
4503,1,829,43
4504,3,829,15
4505,14,829,17
4506,6,829,484
4507,13,829,1
4508,3,829,434
4509,2,829,135
4510,16,830,186
4511,8,830,478
4512,15,830,12
4513,3,830,248
4514,14,830,339
4515,11,831,74
4516,7,831,16
4517,19,831,148
4518,4,831,190
4519,7,831,43
4520,1,831,105
4521,2,832,64
4522,16,832,69
4523,17,832,417
4524,8,832,19
4525,10,832,460
4526,2,832,102
4527,12,833,385
4528,2,833,239
4529,9,833,461
4530,4,833,199
4531,19,833,27
4532,9,834,49
4533,2,834,115
4534,16,834,256
4535,8,834,413
4536,11,834,383
4537,13,834,228
4538,4,834,82
4539,11,835,200
4540,15,835,392
4541,16,835,186
4542,12,835,495
4543,15,835,368
4544,4,836,51
4545,8,836,203
4546,1,836,242
4547,20,837,73
4548,14,837,15
4549,9,837,70
4550,17,838,418
4551,17,838,393
4552,17,838,438
4553,19,838,123
4554,5,838,197
4555,20,839,375
4556,10,839,436
4557,13,839,68
4558,14,839,477
4559,16,839,95
4560,13,839,429
4561,12,839,224
4562,1,839,63
4563,9,839,248
4564,2,839,148
4565,3,840,296
4566,2,840,176
4567,6,840,307
4568,17,840,303
4569,7,840,449
4570,19,840,229
4571,12,840,460
4572,17,841,490
4573,9,841,43
4574,3,841,154
4575,7,841,160
4576,20,842,65
4577,18,842,324
4578,5,842,363
4579,6,842,493
4580,9,842,406
4581,2,842,104
4582,19,842,116
4583,10,842,50
4584,20,842,336
4585,13,842,237
4586,18,843,405
4587,6,844,62
4588,7,845,182
4589,4,846,458
4590,7,847,398
4591,6,847,240
4592,12,847,83
4593,17,847,230
4594,6,847,410
4595,18,847,283
4596,20,848,33
4597,6,848,192
4598,9,848,375
4599,12,848,61
4600,4,848,343
4601,15,848,216
4602,18,848,326
4603,7,848,452
4604,17,849,309
4605,12,849,244
4606,16,849,341
4607,4,850,422
4608,20,850,119
4609,15,850,11
4610,20,850,419
4611,20,850,342
4612,10,850,28
4613,14,851,149
4614,14,851,226
4615,1,851,81
4616,4,852,173
4617,12,853,385
4618,8,853,201
4619,3,853,51
4620,4,853,68
4621,18,853,325
4622,20,854,347
4623,11,854,111
4624,10,855,453
4625,7,856,115
4626,1,856,349
4627,19,856,337
4628,10,856,483
4629,17,857,29
4630,13,857,130
4631,9,857,81
4632,2,858,400
4633,14,858,447
4634,1,858,138
4635,13,858,65
4636,20,858,317
4637,7,858,193
4638,10,858,275
4639,12,858,117
4640,14,858,217
4641,7,858,344
4642,8,859,38
4643,15,859,288
4644,11,859,207
4645,7,859,474
4646,5,859,363
4647,9,860,484
4648,2,860,438
4649,19,860,4
4650,16,860,248
4651,12,860,206
4652,13,860,400
4653,4,860,240
4654,2,860,392
4655,1,860,80
4656,3,860,233
4657,7,861,59
4658,17,861,429
4659,15,861,211
4660,16,861,359
4661,17,861,413
4662,10,861,364
4663,1,861,129
4664,12,861,449
4665,15,861,113
4666,12,862,356
4667,18,862,262
4668,12,862,266
4669,17,862,204
4670,15,863,260
4671,6,863,30
4672,6,863,318
4673,18,863,244
4674,11,863,456
4675,16,863,484
4676,15,864,363
4677,2,864,164
4678,10,864,408
4679,18,864,371
4680,12,864,358
4681,15,864,269
4682,6,864,230
4683,16,864,42
4684,5,865,340
4685,13,865,96
4686,5,866,210
4687,12,866,300
4688,9,866,201
4689,13,867,142
4690,15,867,46
4691,10,867,395
4692,17,867,34
4693,4,867,416
4694,3,867,166
4695,17,867,313
4696,13,867,98
4697,17,868,295
4698,4,868,415
4699,7,869,34
4700,10,869,221
4701,20,869,230
4702,1,869,139
4703,19,870,266
4704,8,870,221
4705,12,870,98
4706,12,870,427
4707,10,870,486
4708,17,870,487
4709,18,871,421
4710,12,871,469
4711,6,871,224
4712,3,872,63
4713,1,872,410
4714,16,873,395
4715,20,873,352
4716,9,873,236
4717,7,873,88
4718,12,873,162
4719,2,873,117
4720,8,873,374
4721,1,874,428
4722,13,874,359
4723,5,874,55
4724,9,874,196
4725,16,874,283
4726,17,874,382
4727,8,874,467
4728,7,874,42
4729,19,874,349
4730,10,875,2
4731,15,875,199
4732,15,875,192
4733,18,875,409
4734,7,875,483
4735,14,876,206
4736,4,876,483
4737,7,876,184
4738,10,877,428
4739,10,878,32
4740,10,878,325
4741,20,878,144
4742,14,878,479
4743,6,878,52
4744,12,878,236
4745,9,879,232
4746,15,879,421
4747,13,879,213
4748,15,879,286
4749,18,880,343
4750,12,880,208
4751,5,880,287
4752,11,880,23
4753,1,880,378
4754,19,880,123
4755,10,880,89
4756,20,881,70
4757,8,881,427
4758,1,881,183
4759,18,881,71
4760,10,882,154
4761,17,882,268
4762,19,882,310
4763,10,882,257
4764,14,882,386
4765,13,883,452
4766,7,883,90
4767,4,883,189
4768,17,883,462
4769,7,883,410
4770,12,883,298
4771,4,883,494
4772,16,883,232
4773,13,883,391
4774,12,884,212
4775,15,884,389
4776,1,884,39
4777,15,884,221
4778,1,884,355
4779,6,884,467
4780,19,884,195
4781,1,884,101
4782,5,885,4
4783,11,885,112
4784,10,885,66
4785,4,885,397
4786,13,885,173
4787,20,885,267
4788,13,886,371
4789,20,886,280
4790,13,886,228
4791,2,886,276
4792,17,887,19
4793,16,888,266
4794,4,888,277
4795,4,888,433
4796,12,888,29
4797,18,888,320
4798,17,888,125
4799,17,889,90
4800,6,889,320
4801,7,889,55
4802,16,889,404
4803,14,889,302
4804,15,890,339
4805,3,890,195
4806,17,890,358
4807,15,890,380
4808,1,890,304
4809,13,890,168
4810,9,890,402
4811,12,891,240
4812,18,891,202
4813,19,891,118
4814,4,891,299
4815,15,891,211
4816,9,891,114
4817,12,891,309
4818,4,892,284
4819,9,892,96
4820,6,892,150
4821,12,892,347
4822,13,892,443
4823,6,893,26
4824,15,893,189
4825,7,893,315
4826,20,894,498
4827,6,894,222
4828,3,894,43
4829,14,894,58
4830,6,894,159
4831,3,894,347
4832,17,894,440
4833,6,894,403
4834,2,894,359
4835,6,895,331
4836,18,895,459
4837,11,895,295
4838,3,896,238
4839,12,896,35
4840,8,896,195
4841,14,896,370
4842,14,896,283
4843,18,896,160
4844,7,897,287
4845,5,897,312
4846,10,897,402
4847,8,897,29
4848,11,897,359
4849,7,897,307
4850,9,898,410
4851,15,898,272
4852,2,898,427
4853,16,898,84
4854,15,898,188
4855,12,898,120
4856,16,899,59
4857,2,899,120
4858,17,899,110
4859,19,899,369
4860,20,900,446
4861,14,900,267
4862,15,900,319
4863,11,900,25
4864,18,901,475
4865,19,901,404
4866,13,901,312
4867,3,902,77
4868,3,902,242
4869,19,902,366
4870,6,902,350
4871,6,902,189
4872,13,902,267
4873,11,902,401
4874,18,902,33
4875,16,903,448
4876,19,903,160
4877,5,903,380
4878,17,903,127
4879,18,903,429
4880,16,903,475
4881,19,903,456
4882,7,903,352
4883,12,903,466
4884,12,903,262
4885,6,904,369
4886,7,904,189
4887,13,904,416
4888,18,904,366
4889,16,904,88
4890,3,904,421
4891,14,904,193
4892,12,904,113
4893,2,905,91
4894,3,905,89
4895,17,905,479
4896,8,906,8
4897,18,906,92
4898,17,906,245
4899,10,906,213
4900,20,907,115
4901,15,907,486
4902,2,907,11
4903,13,907,315
4904,18,907,412
4905,3,908,392
4906,18,908,258
4907,17,908,210
4908,9,908,344
4909,9,908,118
4910,11,908,248
4911,18,908,472
4912,16,908,82
4913,20,909,495
4914,2,909,443
4915,13,909,246
4916,2,909,143
4917,6,910,442
4918,13,910,410
4919,11,910,13
4920,8,910,83
4921,11,910,254
4922,17,910,455
4923,16,910,273
4924,16,911,165
4925,13,911,50
4926,10,911,454
4927,12,911,64
4928,8,911,245
4929,14,911,347
4930,2,911,457
4931,15,911,417
4932,20,911,147
4933,4,912,174
4934,11,913,497
4935,18,913,398
4936,6,913,499
4937,10,914,49
4938,17,915,386
4939,1,915,352
4940,14,915,223
4941,18,915,335
4942,14,915,323
4943,6,915,440
4944,14,915,48
4945,13,915,450
4946,9,915,120
4947,9,916,15
4948,6,916,330
4949,8,916,455
4950,2,917,184
4951,18,917,83
4952,5,917,361
4953,7,917,156
4954,7,917,317
4955,6,917,61
4956,12,917,221
4957,13,917,88
4958,19,917,141
4959,20,917,356
4960,4,918,280
4961,18,918,29
4962,18,918,67
4963,9,918,389
4964,20,918,103
4965,19,918,30
4966,2,918,357
4967,12,918,72
4968,19,919,449
4969,5,919,335
4970,13,919,489
4971,18,919,71
4972,8,919,75
4973,10,920,36
4974,4,920,500
4975,6,921,432
4976,3,922,378
4977,2,922,128
4978,4,922,295
4979,12,923,326
4980,4,924,322
4981,9,924,211
4982,9,924,473
4983,10,924,261
4984,18,924,74
4985,14,924,286
4986,6,925,171
4987,11,925,35
4988,16,925,430
4989,12,925,89
4990,2,925,166
4991,9,925,394
4992,6,925,377
4993,8,925,474
4994,9,926,496
4995,13,927,125
4996,8,928,385
4997,16,928,61
4998,20,928,165
4999,11,928,253
5000,2,928,480
5001,15,928,380
5002,17,928,462
5003,15,928,291
5004,17,928,38
5005,6,928,320
5006,17,929,325
5007,20,929,67
5008,13,929,11
5009,4,929,302
5010,13,929,141
5011,11,929,156
5012,2,929,355
5013,11,929,243
5014,5,929,272
5015,6,929,398
5016,12,930,309
5017,4,930,128
5018,4,931,247
5019,18,931,302
5020,11,931,152
5021,2,931,305
5022,10,931,124
5023,7,931,421
5024,4,931,138
5025,2,931,76
5026,4,931,67
5027,6,932,183
5028,6,932,322
5029,10,933,139
5030,8,933,459
5031,5,933,51
5032,19,933,103
5033,5,933,308
5034,6,933,490
5035,17,934,158
5036,2,934,443
5037,7,934,268
5038,16,934,261
5039,8,934,475
5040,1,935,7
5041,17,935,452
5042,6,935,394
5043,4,935,341
5044,4,935,247
5045,9,935,206
5046,1,935,241
5047,17,935,408
5048,10,935,269
5049,19,936,161
5050,1,936,255
5051,1,937,231
5052,4,937,360
5053,2,937,368
5054,19,937,358
5055,15,937,348
5056,16,937,354
5057,5,938,179
5058,8,938,429
5059,5,939,386
5060,3,939,407
5061,13,939,240
5062,4,939,86
5063,12,939,199
5064,9,939,114
5065,10,939,378
5066,11,940,331
5067,20,940,52
5068,18,940,375
5069,14,940,274
5070,5,940,23
5071,7,940,148
5072,18,940,372
5073,8,940,6
5074,6,940,228
5075,10,941,147
5076,7,941,473
5077,12,941,32
5078,4,941,9
5079,6,941,368
5080,10,942,69
5081,20,942,251
5082,8,943,218
5083,3,943,163
5084,11,943,242
5085,18,943,18
5086,18,943,437
5087,15,943,128
5088,10,943,70
5089,2,943,417
5090,5,944,205
5091,4,945,345
5092,8,945,298
5093,2,945,109
5094,9,945,373
5095,5,945,197
5096,18,945,76
5097,9,945,420
5098,18,946,368
5099,20,946,164
5100,7,946,422
5101,19,946,75
5102,1,947,303
5103,5,947,310
5104,14,948,452
5105,15,948,284
5106,17,948,448
5107,3,948,148
5108,4,949,52
5109,4,949,307
5110,18,949,318
5111,3,949,192
5112,7,949,421
5113,2,949,476
5114,1,949,462
5115,3,950,70
5116,9,950,421
5117,12,950,12
5118,18,950,487
5119,1,951,451
5120,19,951,474
5121,4,951,333
5122,20,951,56
5123,12,951,182
5124,15,951,183
5125,12,951,72
5126,5,951,59
5127,12,952,344
5128,17,952,183
5129,11,953,157
5130,4,953,205
5131,5,954,6
5132,1,954,267
5133,4,955,319
5134,16,955,226
5135,16,955,432
5136,8,955,490
5137,10,955,133
5138,5,955,253
5139,4,956,120
5140,11,956,138
5141,8,956,171
5142,19,956,47
5143,5,956,145
5144,12,956,463
5145,1,956,286
5146,16,956,178
5147,20,956,292
5148,15,957,193
5149,18,957,316
5150,18,957,466
5151,15,958,449
5152,13,958,279
5153,6,958,275
5154,3,958,377
5155,11,958,389
5156,18,958,118
5157,3,958,416
5158,19,958,182
5159,14,959,179
5160,17,959,87
5161,10,960,328
5162,16,960,74
5163,15,960,292
5164,20,960,487
5165,10,960,363
5166,1,960,275
5167,11,961,79
5168,20,961,276
5169,15,962,216
5170,18,963,459
5171,1,963,160
5172,18,963,253
5173,5,963,382
5174,14,963,97
5175,1,963,337
5176,19,963,342
5177,7,964,391
5178,12,964,464
5179,19,964,9
5180,16,964,1
5181,2,964,47
5182,18,964,262
5183,8,964,108
5184,13,964,280
5185,11,964,135
5186,5,964,263
5187,3,965,125
5188,18,965,254
5189,11,965,163
5190,16,965,313
5191,20,965,172
5192,17,965,415
5193,6,965,363
5194,2,965,390
5195,6,965,496
5196,12,966,456
5197,16,966,83
5198,14,967,89
5199,3,967,26
5200,7,967,206
5201,14,967,233
5202,13,967,495
5203,17,967,367
5204,7,968,471
5205,15,968,205
5206,20,968,316
5207,8,968,183
5208,10,968,190
5209,4,969,88
5210,12,969,42
5211,5,969,322
5212,10,969,498
5213,12,969,350
5214,12,969,109
5215,13,969,157
5216,11,970,372
5217,10,970,412
5218,3,970,406
5219,2,970,390
5220,6,970,211
5221,11,970,231
5222,13,970,42
5223,12,971,183
5224,12,972,424
5225,15,972,153
5226,13,972,265
5227,1,972,469
5228,10,972,137
5229,2,973,223
5230,10,973,264
5231,8,974,11
5232,19,974,239
5233,6,974,340
5234,20,974,117
5235,18,974,49
5236,7,975,492
5237,8,975,133
5238,18,976,368
5239,17,976,267
5240,2,977,397
5241,18,977,100
5242,19,977,197
5243,2,978,44
5244,4,978,457
5245,15,978,21
5246,17,979,270
5247,20,979,92
5248,13,979,144
5249,8,980,348
5250,2,980,420
5251,1,980,373
5252,8,980,206
5253,7,980,67
5254,20,980,93
5255,16,980,51
5256,17,980,108
5257,1,981,217
5258,15,981,133
5259,16,981,168
5260,9,981,42
5261,2,981,483
5262,3,981,451
5263,20,981,8
5264,4,981,312
5265,9,981,337
5266,20,982,238
5267,18,982,317
5268,6,982,295
5269,11,982,290
5270,3,982,371
5271,4,982,255
5272,7,982,267
5273,19,982,234
5274,20,983,61
5275,13,983,348
5276,18,984,154
5277,10,984,279
5278,12,984,409
5279,2,984,421
5280,8,984,41
5281,2,984,456
5282,3,985,162
5283,8,985,66
5284,20,985,328
5285,7,985,312
5286,7,985,226
5287,5,985,351
5288,11,985,405
5289,19,985,343
5290,18,985,289
5291,16,985,22
5292,20,986,222
5293,4,986,494
5294,9,986,149
5295,2,986,4
5296,18,987,85
5297,17,987,453
5298,8,987,155
5299,8,987,416
5300,6,987,16
5301,7,987,466
5302,15,987,361
5303,17,987,131
5304,1,988,464
5305,1,988,47
5306,7,988,179
5307,18,988,458
5308,18,988,437
5309,11,989,385
5310,7,989,101
5311,1,989,108
5312,6,989,480
5313,4,989,322
5314,2,989,117
5315,15,989,213
5316,15,989,350
5317,11,989,300
5318,11,990,342
5319,2,990,191
5320,19,991,137
5321,9,991,188
5322,7,991,227
5323,1,991,30
5324,11,991,294
5325,20,991,91
5326,2,991,494
5327,9,991,193
5328,8,991,340
5329,18,991,269
5330,19,992,351
5331,2,992,256
5332,15,992,453
5333,3,992,15
5334,12,992,204
5335,14,992,268
5336,4,992,242
5337,20,992,174
5338,17,992,124
5339,16,993,207
5340,18,993,208
5341,7,993,373
5342,3,993,90
5343,7,993,221
5344,10,993,386
5345,10,993,362
5346,1,993,256
5347,6,993,19
5348,4,993,233
5349,10,994,31
5350,7,994,353
5351,19,994,393
5352,17,995,43
5353,8,995,62
5354,16,995,215
5355,6,995,418
5356,13,995,172
5357,17,995,133
5358,14,995,146
5359,15,995,143
5360,9,995,54
5361,13,996,261
5362,11,996,205
5363,2,996,369
5364,5,996,370
5365,20,996,3
5366,15,996,171
5367,3,996,202
5368,5,996,31
5369,6,996,270
5370,19,997,191
5371,7,997,281
5372,5,997,76
5373,9,998,432
5374,20,998,345
5375,3,998,154
5376,19,998,383
5377,19,998,250
5378,9,998,184
5379,19,998,198
5380,16,998,487
5381,2,998,476
5382,15,999,375
5383,12,999,443
5384,13,999,121
5385,2,999,124
5386,6,999,368
5387,18,999,287
5388,18,999,213
5389,13,999,357
5390,2,1000,477
5391,11,1000,70
5392,20,1000,134
5393,8,1000,320
5394,10,1000,431
5395,15,1000,40
5396,16,1000,27
5397,17,1000,392
5398,1,1000,354
5399,12,1000,266
5400,14,1001,111
5401,1,1001,323
5402,1,1001,139
5403,13,1001,419
5404,8,1001,51
5405,16,1001,337
5406,2,1001,474
5407,9,1002,99
5408,11,1002,213
5409,14,1002,142
5410,11,1002,37
5411,2,1002,495
5412,19,1002,238
5413,8,1002,227
5414,19,1002,310
5415,5,1003,96
5416,12,1003,271
5417,15,1003,495
5418,20,1003,356
5419,17,1003,130
5420,16,1003,325
5421,2,1003,37
5422,13,1003,487
5423,16,1004,195
5424,11,1005,155
5425,4,1005,244
5426,18,1005,288
5427,6,1005,280
5428,15,1006,163
5429,3,1006,258
5430,3,1006,496
5431,2,1006,452
5432,7,1006,268
5433,13,1007,63
5434,19,1007,450
5435,17,1008,403
5436,18,1008,245
5437,1,1009,54
5438,2,1009,305
5439,18,1009,191
5440,16,1009,59
5441,3,1009,406
5442,15,1010,67
5443,12,1010,96
5444,19,1010,380
5445,2,1010,189
5446,12,1010,489
5447,11,1010,364
5448,1,1011,136
5449,13,1011,338
5450,16,1011,130
5451,3,1011,41
5452,4,1011,281
5453,6,1011,361
5454,19,1011,429
5455,10,1011,235
5456,15,1012,463
5457,16,1012,338
5458,8,1012,494
5459,3,1012,256
5460,19,1013,374
5461,16,1013,383
5462,13,1013,350
5463,20,1013,273
5464,16,1014,70
5465,3,1015,254
5466,17,1015,69
5467,12,1015,317
5468,8,1015,283
5469,15,1015,73
5470,18,1015,338
5471,8,1015,346
5472,4,1015,460
5473,5,1015,363
5474,2,1016,211
5475,8,1016,473
5476,2,1016,191
5477,9,1016,325
5478,4,1016,388
5479,6,1016,500
5480,13,1016,239
5481,19,1016,46
5482,18,1016,300
5483,3,1017,244
5484,12,1017,320
5485,19,1018,44
5486,12,1018,179
5487,16,1018,101
5488,10,1018,135
5489,17,1018,292
5490,17,1018,203
5491,1,1018,499
5492,20,1019,77
5493,6,1019,199
5494,7,1020,267
5495,2,1021,457
5496,3,1021,276
5497,4,1021,326
5498,17,1021,141
5499,2,1021,53
5500,5,1021,187
5501,5,1021,383
5502,18,1022,251
5503,19,1022,351
5504,20,1022,146
5505,15,1022,462
5506,4,1022,300
5507,5,1022,45
5508,1,1022,301
5509,5,1023,59
5510,20,1024,60
5511,6,1024,362
5512,12,1024,2
5513,2,1024,344
5514,12,1024,479
5515,18,1025,412
5516,16,1025,355
5517,12,1025,171
5518,1,1025,300
5519,16,1025,247
5520,4,1025,175
5521,7,1025,392
5522,18,1025,393
5523,6,1025,481
5524,7,1026,499
5525,13,1027,295
5526,7,1027,456
5527,6,1027,359
5528,14,1027,489
5529,15,1027,158
5530,11,1027,164
5531,3,1027,232
5532,5,1027,24
5533,17,1027,76
5534,1,1028,244
5535,4,1028,93
5536,7,1028,78
5537,14,1028,42
5538,19,1028,63
5539,1,1029,389
5540,9,1029,333
5541,9,1029,200
5542,3,1029,55
5543,12,1030,156
5544,5,1030,42
5545,9,1030,45
5546,6,1030,56
5547,15,1030,310
5548,13,1030,35
5549,6,1030,375
5550,16,1030,260
5551,7,1030,217
5552,16,1031,424
5553,20,1031,313
5554,16,1031,12
5555,8,1031,454
5556,12,1031,74
5557,16,1031,477
5558,10,1031,147
5559,8,1031,96
5560,18,1031,257
5561,20,1032,145
5562,16,1032,367
5563,3,1032,70
5564,14,1033,288
5565,7,1033,153
5566,18,1033,131
5567,12,1033,407
5568,8,1034,246
5569,19,1034,232
5570,18,1035,421
5571,4,1035,264
5572,18,1036,430
5573,7,1036,371
5574,16,1037,247
5575,7,1037,191
5576,19,1037,311
5577,13,1038,70
5578,13,1038,95
5579,8,1038,311
5580,4,1038,103
5581,20,1039,88
5582,12,1039,421
5583,5,1039,374
5584,7,1039,64
5585,16,1039,301
5586,11,1039,39
5587,9,1039,445
5588,20,1039,319
5589,7,1040,188
5590,9,1040,487
5591,13,1040,482
5592,17,1040,192
5593,2,1040,474
5594,2,1040,10
5595,18,1040,178
5596,7,1041,109
5597,2,1041,228
5598,12,1041,234
5599,20,1041,339
5600,19,1041,476
5601,17,1041,214
5602,18,1042,267
5603,9,1042,493
5604,11,1042,285
5605,9,1043,295
5606,18,1043,208
5607,15,1043,115
5608,1,1043,81
5609,11,1044,325
5610,13,1044,99
5611,8,1044,105
5612,14,1044,297
5613,8,1044,245
5614,10,1044,201
5615,10,1045,174
5616,6,1045,139
5617,5,1045,339
5618,10,1045,426
5619,16,1045,465
5620,20,1045,6
5621,5,1045,154
5622,3,1045,4
5623,10,1045,231
5624,14,1046,320
5625,16,1046,435
5626,17,1047,11
5627,15,1047,90
5628,8,1047,32
5629,11,1047,57
5630,10,1048,196
5631,20,1048,499
5632,12,1048,330
5633,14,1048,289
5634,10,1048,184
5635,18,1048,315
5636,3,1048,159
5637,11,1048,430
5638,3,1049,107
5639,4,1049,187
5640,12,1049,430
5641,13,1050,154
5642,3,1050,380
5643,10,1050,159
5644,14,1050,184
5645,7,1050,92
5646,7,1050,29
5647,17,1050,313
5648,15,1051,154
5649,19,1051,248
5650,14,1051,331
5651,20,1051,173
5652,19,1051,276
5653,14,1051,137
5654,4,1051,293
5655,9,1052,483
5656,15,1052,163
5657,3,1052,138
5658,6,1052,446
5659,16,1052,45
5660,12,1052,269
5661,10,1053,327
5662,5,1053,362
5663,16,1053,152
5664,4,1053,212
5665,12,1053,455
5666,12,1054,397
5667,14,1054,428
5668,10,1054,140
5669,2,1055,118
5670,3,1055,156
5671,2,1055,1
5672,13,1055,332
5673,11,1055,377
5674,11,1055,354
5675,4,1055,79
5676,16,1055,214
5677,6,1056,323
5678,20,1056,406
5679,6,1056,379
5680,13,1056,157
5681,14,1056,181
5682,18,1057,232
5683,5,1057,125
5684,17,1057,211
5685,12,1057,37
5686,18,1057,448
5687,5,1057,129
5688,5,1057,330
5689,20,1057,324
5690,8,1057,173
5691,13,1057,6
5692,13,1058,325
5693,3,1058,232
5694,9,1058,320
5695,20,1058,333
5696,9,1058,416
5697,5,1058,184
5698,11,1058,170
5699,12,1058,286
5700,18,1058,240
5701,6,1058,222
5702,3,1059,68
5703,7,1059,165
5704,14,1059,429
5705,8,1059,357
5706,16,1059,447
5707,2,1059,292
5708,2,1059,61
5709,19,1059,34
5710,4,1059,232
5711,17,1060,23
5712,2,1060,39
5713,2,1060,3
5714,12,1061,134
5715,18,1061,143
5716,3,1061,334
5717,6,1061,123
5718,14,1061,148
5719,6,1061,304
5720,19,1061,201
5721,19,1061,232
5722,10,1062,88
5723,5,1062,298
5724,16,1062,475
5725,16,1062,233
5726,15,1062,80
5727,9,1062,419
5728,5,1062,216
5729,2,1062,288
5730,12,1062,322
5731,9,1062,126
5732,15,1063,396
5733,8,1063,365
5734,1,1063,453
5735,9,1063,383
5736,16,1063,498
5737,11,1063,6
5738,2,1064,378
5739,15,1064,280
5740,6,1064,184
5741,1,1064,110
5742,20,1065,438
5743,7,1065,339
5744,9,1065,269
5745,1,1066,346
5746,11,1067,337
5747,15,1067,373
5748,8,1067,427
5749,3,1067,335
5750,18,1067,384
5751,7,1067,417
5752,11,1067,294
5753,18,1068,186
5754,7,1068,460
5755,18,1068,8
5756,15,1068,422
5757,13,1068,130
5758,14,1068,480
5759,4,1068,476
5760,17,1068,206
5761,17,1068,194
5762,11,1068,50
5763,12,1069,206
5764,4,1069,396
5765,13,1069,27
5766,11,1069,361
5767,20,1069,140
5768,5,1069,85
5769,15,1069,285
5770,17,1070,380
5771,19,1071,485
5772,16,1071,486
5773,7,1071,4
5774,2,1071,325
5775,9,1071,365
5776,11,1071,123
5777,6,1072,88
5778,18,1072,394
5779,6,1072,203
5780,9,1073,489
5781,19,1073,439
5782,13,1073,211
5783,4,1073,35
5784,13,1074,86
5785,20,1074,337
5786,9,1074,66
5787,19,1074,29
5788,5,1074,125
5789,8,1074,388
5790,20,1074,413
5791,16,1074,19
5792,2,1074,464
5793,4,1074,47
5794,2,1075,357
5795,12,1075,407
5796,3,1075,288
5797,17,1075,24
5798,12,1075,15
5799,18,1076,17
5800,1,1077,244
5801,17,1077,155
5802,18,1077,112
5803,11,1077,412
5804,8,1077,239
5805,3,1077,419
5806,14,1078,351
5807,10,1078,365
5808,6,1078,292
5809,18,1078,397
5810,15,1078,472
5811,6,1079,277
5812,10,1079,145
5813,6,1079,21
5814,2,1079,94
5815,9,1079,1
5816,1,1079,5
5817,18,1079,396
5818,5,1080,15
5819,7,1080,369
5820,13,1080,287
5821,2,1080,36
5822,20,1080,251
5823,7,1081,291
5824,19,1081,300
5825,3,1081,34
5826,6,1081,322
5827,19,1081,124
5828,3,1081,432
5829,16,1081,443
5830,17,1082,74
5831,1,1082,289
5832,2,1082,105
5833,3,1082,263
5834,15,1083,58
5835,19,1083,160
5836,7,1083,231
5837,20,1083,297
5838,17,1083,357
5839,2,1083,390
5840,8,1083,274
5841,11,1083,340
5842,16,1084,443
5843,2,1084,169
5844,20,1084,498
5845,13,1084,375
5846,5,1084,372
5847,4,1085,376
5848,4,1085,348
5849,14,1085,494
5850,5,1085,253
5851,18,1085,474
5852,8,1085,346
5853,18,1086,7
5854,18,1086,13
5855,4,1087,271
5856,14,1088,292
5857,13,1088,440
5858,10,1088,311
5859,18,1088,135
5860,12,1088,456
5861,9,1088,264
5862,19,1088,267
5863,14,1088,59
5864,10,1088,119
5865,5,1089,500
5866,4,1089,394
5867,6,1089,198
5868,3,1089,41
5869,17,1089,418
5870,16,1090,313
5871,19,1091,270
5872,8,1091,111
5873,11,1091,207
5874,8,1091,401
5875,11,1091,219
5876,2,1091,200
5877,4,1091,378
5878,5,1091,36
5879,8,1091,342
5880,17,1091,319
5881,15,1092,422
5882,8,1092,459
5883,10,1092,282
5884,16,1092,328
5885,11,1092,289
5886,2,1093,121
5887,16,1093,117
5888,5,1093,301
5889,18,1093,142
5890,3,1093,248
5891,20,1093,284
5892,10,1093,481
5893,2,1094,291
5894,11,1094,329
5895,13,1094,421
5896,10,1094,137
5897,13,1094,126
5898,11,1094,3
5899,10,1094,496
5900,16,1094,182
5901,14,1095,232
5902,6,1095,60
5903,16,1095,353
5904,16,1095,271
5905,11,1095,355
5906,7,1095,497
5907,13,1095,236
5908,11,1095,84
5909,9,1096,473
5910,7,1096,499
5911,9,1097,443
5912,17,1097,364
5913,13,1097,101
5914,16,1097,193
5915,8,1097,8
5916,1,1098,103
5917,6,1099,424
5918,18,1099,416
5919,8,1099,107
5920,18,1099,91
5921,15,1099,443
5922,14,1099,32
5923,15,1100,190
5924,6,1100,26
5925,9,1100,395
5926,16,1100,320
5927,1,1100,314
5928,8,1100,114
5929,18,1101,287
5930,18,1101,223
5931,13,1101,473
5932,14,1101,424
5933,18,1101,271
5934,6,1101,41
5935,4,1102,104
5936,16,1102,213
5937,11,1102,317
5938,5,1102,409
5939,9,1102,189
5940,4,1103,493
5941,13,1103,471
5942,20,1103,330
5943,4,1103,225
5944,6,1103,481
5945,7,1103,155
5946,11,1103,206
5947,4,1104,258
5948,18,1104,406
5949,20,1104,286
5950,18,1104,220
5951,19,1104,97
5952,8,1104,499
5953,19,1104,372
5954,12,1104,347
5955,19,1104,53
5956,3,1104,338
5957,12,1105,427
5958,2,1105,238
5959,10,1105,263
5960,6,1105,234
5961,20,1105,84
5962,16,1105,423
5963,10,1105,39
5964,9,1105,431
5965,20,1105,7
5966,3,1106,4
5967,12,1107,346
5968,19,1107,434
5969,9,1107,330
5970,4,1108,415
5971,20,1108,354
5972,7,1108,156
5973,15,1109,153
5974,5,1109,74
5975,15,1109,108
5976,20,1109,122
5977,3,1109,268
5978,7,1109,406
5979,8,1109,226
5980,1,1110,101
5981,8,1110,319
5982,6,1110,430
5983,15,1110,243
5984,13,1110,48
5985,5,1110,228
5986,10,1110,347
5987,2,1110,236
5988,4,1111,60
5989,3,1111,460
5990,3,1111,463
5991,6,1111,150
5992,16,1111,452
5993,9,1111,144
5994,20,1111,424
5995,1,1111,100
5996,20,1112,417
5997,18,1112,100
5998,3,1112,53
5999,10,1112,341
6000,6,1112,47
6001,10,1112,6
6002,20,1112,441
6003,15,1112,172
6004,20,1113,129
6005,3,1113,229
6006,6,1113,214
6007,17,1113,68
6008,11,1113,218
6009,6,1113,54
6010,3,1114,22
6011,8,1114,322
6012,9,1115,432
6013,18,1115,94
6014,8,1115,6
6015,11,1115,85
6016,13,1116,336
6017,9,1116,454
6018,3,1116,486
6019,9,1116,105
6020,7,1116,45
6021,14,1116,259
6022,15,1117,184
6023,2,1117,479
6024,12,1117,176
6025,17,1117,425
6026,8,1117,330
6027,6,1117,52
6028,15,1117,22
6029,10,1117,426
6030,9,1118,242
6031,17,1118,160
6032,13,1118,477
6033,15,1118,276
6034,10,1118,170
6035,17,1118,126
6036,19,1119,330
6037,14,1119,384
6038,12,1119,135
6039,15,1119,73
6040,1,1119,484
6041,16,1119,262
6042,6,1119,176
6043,14,1119,308
6044,10,1119,50
6045,17,1120,250
6046,10,1120,225
6047,10,1120,78
6048,5,1120,379
6049,5,1120,342
6050,4,1120,132
6051,4,1120,394
6052,5,1121,193
6053,15,1121,90
6054,16,1121,131
6055,4,1121,359
6056,7,1122,270
6057,3,1122,457
6058,3,1122,91
6059,10,1122,412
6060,5,1123,168
6061,2,1124,141
6062,15,1124,444
6063,7,1124,475
6064,1,1125,343
6065,1,1125,140
6066,3,1125,353
6067,12,1125,302
6068,19,1126,383
6069,7,1126,246
6070,2,1126,282
6071,12,1126,234
6072,17,1127,480
6073,17,1127,381
6074,17,1127,251
6075,2,1127,158
6076,15,1127,181
6077,1,1127,125
6078,10,1128,273
6079,8,1128,94
6080,17,1128,408
6081,9,1128,29
6082,5,1128,147
6083,19,1128,67
6084,7,1128,155
6085,19,1129,165
6086,2,1129,415
6087,6,1129,436
6088,3,1129,291
6089,8,1129,365
6090,16,1129,201
6091,4,1129,227
6092,5,1129,284
6093,9,1129,202
6094,17,1129,223
6095,9,1130,326
6096,7,1130,495
6097,7,1130,279
6098,19,1131,3
6099,17,1131,332
6100,10,1132,76
6101,8,1132,490
6102,13,1132,130
6103,16,1132,388
6104,13,1132,112
6105,11,1132,167
6106,2,1132,329
6107,7,1133,335
6108,4,1133,138
6109,19,1133,250
6110,9,1133,292
6111,16,1134,359
6112,3,1134,451
6113,3,1135,419
6114,2,1135,232
6115,20,1135,117
6116,8,1135,399
6117,11,1135,271
6118,2,1136,191
6119,16,1136,290
6120,11,1136,337
6121,13,1136,305
6122,6,1136,105
6123,10,1136,189
6124,18,1136,326
6125,8,1137,246
6126,17,1137,413
6127,18,1137,459
6128,12,1137,405
6129,1,1137,308
6130,16,1137,301
6131,18,1137,319
6132,20,1137,29
6133,13,1137,140
6134,18,1137,229
6135,3,1138,279
6136,15,1138,111
6137,2,1138,17
6138,2,1138,349
6139,17,1138,39
6140,7,1138,254
6141,17,1138,146
6142,16,1138,66
6143,11,1138,234
6144,19,1138,271
6145,15,1139,380
6146,2,1139,312
6147,14,1139,317
6148,16,1139,373
6149,19,1139,108
6150,8,1139,335
6151,1,1139,125
6152,18,1139,43
6153,20,1139,8
6154,12,1140,352
6155,16,1140,453
6156,14,1140,379
6157,1,1140,16
6158,20,1140,470
6159,17,1140,171
6160,4,1140,93
6161,5,1140,446
6162,17,1141,262
6163,2,1141,144
6164,14,1141,33
6165,13,1141,392
6166,7,1141,344
6167,1,1141,246
6168,2,1141,19
6169,20,1141,193
6170,13,1141,275
6171,12,1141,419
6172,5,1142,363
6173,16,1143,137
6174,15,1143,78
6175,16,1144,163
6176,11,1144,75
6177,1,1144,63
6178,20,1144,427
6179,6,1144,70
6180,5,1144,308
6181,9,1145,121
6182,9,1145,209
6183,6,1145,176
6184,19,1145,376
6185,19,1145,272
6186,17,1145,454
6187,8,1145,92
6188,14,1145,66
6189,14,1145,461
6190,5,1145,439
6191,16,1146,94
6192,4,1146,494
6193,8,1146,387
6194,17,1146,433
6195,18,1146,354
6196,10,1146,260
6197,18,1146,12
6198,2,1146,116
6199,10,1146,113
6200,6,1147,60
6201,17,1147,231
6202,9,1147,405
6203,6,1147,388
6204,20,1147,39
6205,14,1147,309
6206,20,1147,396
6207,10,1147,62
6208,17,1147,127
6209,5,1148,342
6210,16,1148,369
6211,10,1148,274
6212,3,1148,317
6213,8,1148,212
6214,15,1148,12
6215,4,1148,250
6216,4,1148,421
6217,5,1148,303
6218,19,1148,201
6219,18,1149,252
6220,8,1149,119
6221,18,1149,357
6222,10,1149,35
6223,20,1149,158
6224,17,1150,61
6225,10,1150,464
6226,9,1150,376
6227,16,1151,300
6228,18,1151,403
6229,4,1151,62
6230,8,1151,368
6231,13,1151,404
6232,7,1151,140
6233,14,1151,88
6234,5,1151,434
6235,19,1152,281
6236,8,1152,444
6237,2,1152,17
6238,18,1152,320
6239,12,1152,92
6240,9,1152,107
6241,6,1153,138
6242,6,1153,89
6243,4,1153,369
6244,6,1153,66
6245,3,1153,339
6246,16,1153,500
6247,16,1153,449
6248,3,1153,335
6249,5,1153,464
6250,6,1153,33
6251,14,1154,451
6252,18,1154,333
6253,11,1154,52
6254,4,1154,324
6255,3,1154,341
6256,19,1154,169
6257,8,1154,192
6258,6,1154,300
6259,9,1154,342
6260,19,1155,402
6261,20,1155,58
6262,11,1155,146
6263,14,1155,451
6264,20,1155,479
6265,12,1155,222
6266,7,1155,455
6267,18,1155,49
6268,15,1156,53
6269,16,1156,445
6270,2,1156,313
6271,6,1157,210
6272,19,1158,139
6273,5,1158,405
6274,18,1158,37
6275,15,1159,402
6276,8,1159,68
6277,3,1159,405
6278,13,1160,66
6279,13,1160,455
6280,2,1160,368
6281,11,1160,84
6282,3,1160,242
6283,2,1160,298
6284,13,1160,266
6285,10,1160,272
6286,9,1160,299
6287,7,1160,376
6288,10,1161,65
6289,11,1161,307
6290,8,1161,64
6291,11,1161,405
6292,5,1161,289
6293,11,1161,196
6294,17,1161,206
6295,12,1161,131
6296,9,1162,80
6297,3,1163,232
6298,16,1163,353
6299,5,1163,118
6300,18,1163,269
6301,17,1163,29
6302,3,1163,333
6303,20,1163,180
6304,20,1163,410
6305,16,1164,252
6306,11,1165,435
6307,3,1165,234
6308,17,1165,58
6309,13,1165,264
6310,9,1165,395
6311,8,1165,69
6312,1,1165,482
6313,1,1165,27
6314,10,1165,296
6315,12,1166,74
6316,7,1166,441
6317,20,1166,271
6318,8,1167,255
6319,19,1167,491
6320,1,1167,161
6321,16,1167,473
6322,6,1167,184
6323,16,1167,397
6324,9,1167,245
6325,18,1167,15
6326,15,1167,337
6327,4,1168,36
6328,2,1168,241
6329,11,1168,427
6330,8,1168,353
6331,16,1168,378
6332,14,1168,125
6333,17,1169,131
6334,17,1169,440
6335,3,1169,122
6336,9,1169,492
6337,3,1170,474
6338,15,1170,202
6339,19,1170,42
6340,9,1170,83
6341,14,1170,442
6342,17,1170,228
6343,16,1170,415
6344,13,1170,494
6345,18,1170,295
6346,18,1171,267
6347,6,1171,390
6348,15,1171,23
6349,9,1172,235
6350,18,1172,49
6351,18,1172,5
6352,14,1172,208
6353,2,1172,23
6354,6,1172,292
6355,18,1172,244
6356,4,1172,239
6357,6,1172,15
6358,8,1172,340
6359,12,1173,211
6360,20,1173,199
6361,9,1173,40
6362,18,1173,386
6363,3,1173,197
6364,14,1173,228
6365,3,1173,149
6366,17,1173,436
6367,7,1174,145
6368,5,1174,10
6369,13,1174,496
6370,19,1174,259
6371,20,1174,231
6372,3,1174,331
6373,17,1175,300
6374,19,1175,9
6375,14,1175,482
6376,11,1175,360
6377,18,1175,85
6378,20,1175,346
6379,12,1176,53
6380,3,1176,458
6381,8,1176,423
6382,11,1176,132
6383,17,1176,328
6384,6,1177,132
6385,12,1177,108
6386,12,1177,292
6387,15,1177,109
6388,10,1177,238
6389,14,1177,382
6390,4,1177,6
6391,8,1178,33
6392,16,1178,287
6393,9,1178,173
6394,10,1178,283
6395,6,1178,428
6396,17,1179,485
6397,15,1179,44
6398,11,1179,344
6399,3,1179,400
6400,7,1179,327
6401,18,1179,26
6402,13,1179,178
6403,6,1180,197
6404,15,1180,412
6405,4,1180,350
6406,6,1180,5
6407,1,1181,248
6408,18,1181,300
6409,1,1181,212
6410,13,1181,450
6411,19,1181,436
6412,7,1181,405
6413,16,1181,264
6414,19,1182,306
6415,2,1182,246
6416,12,1182,342
6417,13,1182,249
6418,2,1183,389
6419,19,1183,21
6420,12,1183,211
6421,9,1183,402
6422,10,1183,469
6423,9,1183,159
6424,4,1184,313
6425,20,1184,418
6426,20,1184,101
6427,14,1184,271
6428,10,1184,364
6429,13,1184,311
6430,1,1184,86
6431,15,1184,283
6432,15,1184,265
6433,12,1184,365
6434,2,1185,341
6435,9,1185,412
6436,18,1185,359
6437,3,1185,444
6438,5,1185,352
6439,15,1186,424
6440,7,1186,218
6441,13,1186,460
6442,19,1186,175
6443,15,1186,465
6444,15,1186,93
6445,15,1187,453
6446,6,1187,225
6447,12,1187,295
6448,20,1187,120
6449,4,1187,310
6450,20,1187,386
6451,7,1187,375
6452,16,1187,17
6453,10,1188,252
6454,9,1188,13
6455,10,1188,286
6456,19,1188,123
6457,15,1188,95
6458,16,1188,207
6459,18,1188,167
6460,6,1189,253
6461,8,1189,414
6462,14,1189,31
6463,18,1189,278
6464,19,1189,451
6465,8,1189,250
6466,20,1189,265
6467,16,1190,369
6468,8,1190,228
6469,7,1190,240
6470,17,1190,496
6471,4,1190,408
6472,16,1190,251
6473,3,1190,266
6474,2,1190,234
6475,16,1190,46
6476,15,1190,436
6477,10,1191,81
6478,2,1191,178
6479,8,1191,446
6480,18,1191,49
6481,7,1191,342
6482,7,1192,201
6483,4,1192,488
6484,19,1193,487
6485,18,1194,478
6486,10,1194,176
6487,4,1194,170
6488,13,1194,434
6489,10,1194,353
6490,9,1194,125
6491,18,1195,452
6492,3,1195,333
6493,20,1196,406
6494,5,1196,294
6495,2,1196,85
6496,19,1196,454
6497,20,1196,354
6498,4,1196,211
6499,13,1196,496
6500,10,1197,208
6501,19,1197,240
6502,15,1197,79
6503,13,1198,350
6504,5,1198,180
6505,7,1198,18
6506,17,1198,135
6507,6,1199,402
6508,5,1199,311
6509,18,1199,168
6510,15,1200,70
6511,18,1200,187
6512,2,1201,394
6513,1,1201,308
6514,9,1201,475
6515,3,1201,366
6516,5,1201,175
6517,11,1201,31
6518,13,1201,79
6519,16,1201,205
6520,9,1202,192
6521,4,1202,427
6522,17,1202,374
6523,6,1203,21
6524,13,1203,203
6525,17,1203,295
6526,2,1203,74
6527,8,1203,156
6528,8,1203,77
6529,10,1203,468
6530,5,1203,408
6531,15,1203,71
6532,2,1204,340
6533,11,1204,76
6534,15,1204,455
6535,14,1205,4
6536,11,1205,360
6537,12,1205,261
6538,15,1205,405
6539,4,1205,220
6540,20,1205,470
6541,20,1205,84
6542,15,1205,309
6543,14,1205,280
6544,13,1206,319
6545,5,1206,264
6546,17,1206,306
6547,20,1206,142
6548,15,1206,154
6549,1,1206,472
6550,9,1206,137
6551,9,1206,209
6552,16,1206,247
6553,18,1207,316
6554,4,1207,210
6555,12,1207,483
6556,12,1207,467
6557,19,1207,469
6558,17,1207,370
6559,3,1208,398
6560,17,1208,248
6561,8,1208,225
6562,20,1208,414
6563,16,1208,314
6564,17,1209,298
6565,3,1209,127
6566,17,1209,180
6567,8,1209,398
6568,1,1209,388
6569,1,1209,494
6570,10,1209,86
6571,10,1209,335
6572,19,1210,271
6573,11,1210,499
6574,20,1211,216
6575,5,1211,117
6576,7,1212,127
6577,6,1212,395
6578,2,1212,354
6579,11,1212,475
6580,20,1213,29
6581,15,1213,361
6582,5,1213,102
6583,8,1213,500
6584,3,1214,251
6585,19,1214,102
6586,2,1214,105
6587,11,1214,265
6588,5,1214,165
6589,5,1214,426
6590,6,1214,143
6591,17,1215,280
6592,17,1215,9
6593,16,1215,467
6594,6,1215,119
6595,19,1215,140
6596,18,1215,341
6597,5,1215,272
6598,8,1215,199
6599,5,1215,247
6600,15,1215,55
6601,10,1216,474
6602,4,1216,148
6603,12,1217,155
6604,19,1217,380
6605,14,1217,402
6606,3,1217,65
6607,13,1217,343
6608,7,1218,406
6609,1,1218,5
6610,17,1218,64
6611,11,1219,119
6612,3,1219,183
6613,9,1219,445
6614,13,1219,418
6615,10,1220,431
6616,1,1220,243
6617,13,1220,448
6618,7,1220,15
6619,8,1220,85
6620,17,1220,245
6621,7,1220,11
6622,3,1221,236
6623,18,1221,358
6624,15,1221,169
6625,7,1221,40
6626,16,1221,274
6627,11,1221,21
6628,17,1221,14
6629,8,1222,444
6630,8,1222,56
6631,8,1222,105
6632,6,1222,195
6633,2,1222,460
6634,10,1222,152
6635,8,1222,363
6636,12,1222,1
6637,16,1223,306
6638,19,1223,213
6639,13,1223,138
6640,1,1224,32
6641,3,1224,116
6642,7,1224,261
6643,14,1224,49
6644,8,1224,136
6645,14,1224,15
6646,14,1225,304
6647,9,1225,134
6648,17,1225,478
6649,18,1225,327
6650,1,1225,6
6651,7,1225,249
6652,3,1225,147
6653,3,1226,147
6654,13,1226,361
6655,16,1227,11
6656,1,1228,490
6657,13,1228,375
6658,7,1228,30
6659,16,1228,405
6660,14,1228,280
6661,2,1228,237
6662,20,1228,32
6663,10,1228,426
6664,9,1229,377
6665,3,1229,76
6666,5,1229,195
6667,9,1229,458
6668,7,1229,244
6669,16,1229,57
6670,9,1229,137
6671,15,1229,448
6672,3,1229,376
6673,20,1230,413
6674,8,1230,235
6675,17,1230,192
6676,16,1230,193
6677,1,1230,327
6678,11,1230,411
6679,4,1230,435
6680,2,1230,86
6681,13,1230,373
6682,13,1231,481
6683,14,1232,384
6684,12,1233,39
6685,2,1233,359
6686,19,1233,182
6687,16,1234,172
6688,16,1234,122
6689,11,1234,143
6690,4,1234,446
6691,1,1234,49
6692,3,1235,278
6693,3,1235,352
6694,15,1235,199
6695,2,1235,281
6696,10,1235,153
6697,4,1235,336
6698,4,1235,332
6699,10,1235,163
6700,2,1235,317
6701,9,1235,294
6702,11,1236,497
6703,4,1236,194
6704,15,1236,406
6705,14,1236,359
6706,13,1236,108
6707,11,1237,267
6708,4,1237,415
6709,11,1237,351
6710,2,1237,10
6711,4,1237,13
6712,1,1237,314
6713,11,1237,2
6714,9,1237,246
6715,16,1237,23
6716,1,1238,217
6717,3,1239,411
6718,9,1239,275
6719,19,1239,169
6720,12,1240,178
6721,6,1241,497
6722,13,1241,483
6723,20,1241,387
6724,6,1241,377
6725,14,1241,141
6726,8,1241,124
6727,15,1241,410
6728,12,1241,263
6729,10,1241,103
6730,5,1241,306
6731,2,1242,287
6732,17,1242,213
6733,20,1242,230
6734,7,1242,461
6735,18,1242,298
6736,11,1242,192
6737,17,1243,42
6738,1,1243,111
6739,8,1243,157
6740,16,1244,354
6741,16,1245,283
6742,6,1245,242
6743,5,1245,220
6744,6,1245,339
6745,9,1245,169
6746,8,1245,353
6747,20,1245,500
6748,5,1245,397
6749,10,1245,372
6750,8,1246,84
6751,16,1247,441
6752,12,1247,456
6753,12,1247,415
6754,16,1247,407
6755,14,1247,127
6756,14,1248,194
6757,8,1249,138
6758,7,1249,330
6759,4,1249,83
6760,7,1249,65
6761,20,1250,318
6762,13,1250,138
6763,20,1250,426
6764,2,1251,6
6765,2,1251,243
6766,16,1251,337
6767,7,1252,213
6768,7,1252,105
6769,11,1252,341
6770,18,1252,260
6771,17,1252,119
6772,19,1252,276
6773,17,1252,222
6774,17,1253,247
6775,14,1253,281
6776,8,1253,209
6777,9,1253,70
6778,11,1254,390
6779,8,1254,313
6780,19,1254,227
6781,19,1255,60
6782,10,1255,328
6783,10,1255,77
6784,17,1255,480
6785,11,1255,11
6786,2,1255,68
6787,9,1255,386
6788,4,1256,36
6789,8,1256,206
6790,4,1256,76
6791,8,1256,404
6792,20,1256,224
6793,5,1256,500
6794,19,1256,244
6795,19,1256,23
6796,17,1256,263
6797,10,1256,13
6798,18,1257,341
6799,8,1257,283
6800,13,1257,20
6801,11,1257,147
6802,1,1257,225
6803,3,1257,98
6804,19,1258,97
6805,7,1258,226
6806,5,1258,316
6807,2,1258,306
6808,3,1258,303
6809,6,1258,51
6810,11,1258,441
6811,8,1259,108
6812,10,1260,267
6813,16,1260,229
6814,14,1260,377
6815,5,1260,22
6816,20,1260,386
6817,1,1261,280
6818,7,1261,68
6819,8,1261,41
6820,4,1261,166
6821,15,1261,103
6822,4,1261,74
6823,12,1261,154
6824,8,1261,167
6825,6,1261,240
6826,13,1262,152
6827,17,1262,118
6828,19,1262,446
6829,16,1262,453
6830,6,1262,221
6831,18,1263,459
6832,7,1264,151
6833,5,1264,470
6834,1,1264,341
6835,11,1264,363
6836,5,1264,209
6837,1,1264,255
6838,13,1264,274
6839,18,1264,458
6840,8,1265,154
6841,13,1266,483
6842,18,1267,364
6843,11,1267,156
6844,1,1267,284
6845,20,1267,244
6846,18,1267,478
6847,2,1267,121
6848,14,1267,1
6849,7,1267,67
6850,4,1267,308
6851,7,1267,59
6852,15,1268,313
6853,9,1268,355
6854,7,1268,164
6855,8,1268,482
6856,17,1268,116
6857,9,1268,498
6858,8,1268,417
6859,9,1268,363
6860,2,1269,282
6861,16,1269,170
6862,7,1269,136
6863,10,1270,245
6864,10,1271,223
6865,3,1271,376
6866,17,1272,286
6867,11,1272,233
6868,16,1272,315
6869,12,1272,392
6870,18,1272,87
6871,6,1272,323
6872,17,1272,474
6873,7,1272,13
6874,19,1272,359
6875,11,1273,32
6876,16,1273,48
6877,20,1273,63
6878,11,1273,333
6879,9,1273,308
6880,14,1273,405
6881,6,1273,473
6882,7,1273,174
6883,5,1273,57
6884,8,1274,191
6885,20,1274,196
6886,5,1274,459
6887,3,1274,279
6888,17,1274,445
6889,4,1274,180
6890,4,1275,369
6891,8,1275,50
6892,10,1275,112
6893,7,1275,116
6894,13,1275,239
6895,14,1275,480
6896,9,1275,246
6897,2,1275,201
6898,14,1276,424
6899,1,1276,349
6900,5,1276,190
6901,4,1276,15
6902,13,1276,451
6903,6,1276,459
6904,13,1276,345
6905,8,1276,156
6906,5,1277,265
6907,6,1277,321
6908,1,1277,109
6909,7,1277,20
6910,3,1277,268
6911,12,1277,391
6912,18,1277,390
6913,17,1277,187
6914,5,1278,12
6915,18,1278,377
6916,20,1279,82
6917,2,1279,343
6918,1,1279,475
6919,14,1280,47
6920,20,1280,288
6921,5,1280,33
6922,9,1280,309
6923,4,1280,279
6924,8,1280,201
6925,7,1280,463
6926,18,1280,428
6927,20,1280,159
6928,10,1281,491
6929,15,1281,461
6930,2,1281,325
6931,13,1281,213
6932,3,1281,180
6933,15,1281,256
6934,2,1281,473
6935,4,1282,20
6936,15,1282,205
6937,2,1283,25
6938,7,1283,494
6939,20,1283,3
6940,11,1283,10
6941,14,1283,275
6942,4,1283,150
6943,17,1283,392
6944,19,1283,491
6945,1,1284,327
6946,8,1284,330
6947,2,1284,178
6948,7,1284,76
6949,13,1284,16
6950,13,1284,139
6951,17,1284,265
6952,19,1284,55
6953,17,1284,112
6954,15,1285,15
6955,1,1285,283
6956,18,1285,131
6957,17,1286,164
6958,6,1286,3
6959,3,1286,282
6960,10,1286,494
6961,8,1286,386
6962,2,1286,369
6963,20,1286,40
6964,9,1287,143
6965,20,1287,243
6966,2,1287,24
6967,3,1287,120
6968,4,1287,47
6969,7,1287,224
6970,2,1287,214
6971,13,1288,236
6972,19,1288,487
6973,20,1288,191
6974,14,1288,156
6975,3,1288,73
6976,8,1288,135
6977,9,1288,281
6978,13,1288,491
6979,8,1288,334
6980,5,1289,3
6981,12,1289,49
6982,9,1289,303
6983,4,1289,128
6984,2,1290,62
6985,15,1290,350
6986,14,1290,12
6987,15,1290,183
6988,1,1290,257
6989,1,1290,427
6990,8,1290,296
6991,17,1290,371
6992,1,1291,257
6993,1,1291,19
6994,4,1292,217
6995,5,1292,132
6996,19,1292,34
6997,18,1292,184
6998,13,1292,153
6999,3,1293,343
7000,1,1293,54
7001,16,1293,90
7002,16,1293,172
7003,13,1293,319
7004,8,1293,240
7005,14,1293,34
7006,3,1293,282
7007,15,1294,119
7008,17,1294,252
7009,8,1294,35
7010,19,1294,16
7011,19,1295,232
7012,9,1372,468
7013,3,1372,479
7014,15,1372,342
7015,14,1372,499
7016,5,1372,308
7017,4,1372,272
7018,1,1372,338
7019,2,1372,497
7020,18,1296,266
7021,17,1296,332
7022,14,1296,307
7023,3,1296,240
7024,5,1296,417
7025,13,1296,393
7026,4,1296,477
7027,10,1296,207
7028,7,1296,166
7029,2,1296,282
7030,14,1297,492
7031,17,1297,398
7032,3,1297,30
7033,10,1297,374
7034,1,1297,358
7035,4,1298,289
7036,17,1298,3
7037,3,1299,76
7038,18,1299,134
7039,20,1299,500
7040,11,1299,251
7041,11,1299,110
7042,7,1299,430
7043,7,1299,293
7044,4,1299,263
7045,4,1299,118
7046,4,1300,222
7047,8,1300,173
7048,3,1300,7
7049,14,1300,196
7050,11,1300,205
7051,11,1301,23
7052,20,1301,240
7053,4,1301,32
7054,2,1301,358
7055,19,1301,402
7056,11,1301,498
7057,12,1301,485
7058,2,1302,278
7059,12,1302,442
7060,20,1302,402
7061,2,1302,83
7062,20,1302,388
7063,16,1302,275
7064,1,1303,336
7065,20,1303,181
7066,4,1303,76
7067,5,1304,238
7068,16,1304,45
7069,2,1304,221
7070,2,1304,344
7071,19,1304,458
7072,13,1304,496
7073,11,1304,9
7074,10,1305,243
7075,2,1305,277
7076,6,1305,483
7077,3,1305,445
7078,2,1305,25
7079,9,1305,14
7080,15,1305,290
7081,18,1305,149
7082,20,1306,419
7083,18,1306,101
7084,3,1306,172
7085,4,1306,486
7086,5,1306,381
7087,12,1307,457
7088,1,1308,419
7089,18,1308,325
7090,8,1308,382
7091,14,1308,417
7092,2,1308,500
7093,13,1308,232
7094,19,1308,405
7095,3,1309,167
7096,13,1309,181
7097,17,1310,227
7098,16,1310,388
7099,6,1310,476
7100,10,1310,492
7101,19,1310,431
7102,10,1310,279
7103,13,1310,85
7104,15,1311,86
7105,17,1311,237
7106,12,1311,321
7107,18,1311,214
7108,5,1311,483
7109,2,1311,341
7110,3,1311,247
7111,9,1311,363
7112,20,1311,151
7113,7,1311,458
7114,7,1312,326
7115,15,1312,102
7116,6,1312,403
7117,13,1312,185
7118,12,1312,289
7119,1,1312,40
7120,3,1313,388
7121,1,1313,450
7122,4,1313,385
7123,10,1313,349
7124,4,1313,296
7125,14,1314,412
7126,1,1314,391
7127,11,1314,377
7128,2,1314,224
7129,15,1314,314
7130,9,1314,219
7131,17,1314,13
7132,18,1314,99
7133,8,1315,374
7134,7,1315,203
7135,20,1315,266
7136,18,1315,409
7137,14,1315,33
7138,2,1316,101
7139,2,1316,76
7140,18,1316,109
7141,3,1316,197
7142,10,1316,36
7143,5,1316,476
7144,6,1317,449
7145,1,1317,227
7146,5,1317,454
7147,20,1317,277
7148,20,1317,149
7149,6,1317,239
7150,18,1317,237
7151,13,1317,54
7152,15,1317,389
7153,7,1317,161
7154,4,1318,404
7155,14,1318,8
7156,5,1318,355
7157,19,1318,85
7158,19,1318,433
7159,2,1319,412
7160,16,1319,21
7161,8,1320,305
7162,9,1320,230
7163,8,1320,135
7164,5,1320,7
7165,11,1320,165
7166,17,1320,358
7167,12,1320,208
7168,18,1320,201
7169,16,1320,118
7170,11,1320,359
7171,16,1321,394
7172,10,1321,110
7173,11,1321,469
7174,10,1322,424
7175,5,1323,205
7176,1,1324,367
7177,15,1324,274
7178,17,1324,42
7179,10,1324,304
7180,2,1325,75
7181,1,1325,278
7182,5,1325,21
7183,19,1325,317
7184,19,1325,270
7185,6,1325,437
7186,4,1325,46
7187,19,1325,402
7188,11,1325,7
7189,2,1325,315
7190,9,1326,342
7191,17,1326,123
7192,5,1326,390
7193,18,1326,335
7194,5,1326,264
7195,20,1326,134
7196,16,1326,138
7197,7,1326,256
7198,11,1326,416
7199,5,1327,119
7200,15,1327,489
7201,3,1327,468
7202,16,1327,353
7203,15,1327,309
7204,18,1328,379
7205,5,1328,1
7206,4,1328,431
7207,13,1328,293
7208,8,1328,435
7209,19,1328,472
7210,5,1328,412
7211,17,1328,468
7212,10,1328,204
7213,15,1328,497
7214,18,1329,322
7215,18,1329,238
7216,13,1329,499
7217,3,1329,394
7218,1,1329,229
7219,20,1329,20
7220,16,1329,254
7221,13,1329,333
7222,16,1329,383
7223,16,1329,440
7224,6,1330,252
7225,12,1331,5
7226,18,1331,450
7227,10,1331,187
7228,15,1331,48
7229,12,1331,248
7230,14,1331,446
7231,20,1331,494
7232,4,1331,119
7233,11,1332,111
7234,4,1332,171
7235,1,1332,56
7236,8,1332,360
7237,17,1332,38
7238,8,1332,23
7239,5,1332,13
7240,11,1333,164
7241,14,1333,453
7242,5,1333,141
7243,1,1333,8
7244,6,1333,210
7245,4,1333,435
7246,10,1333,445
7247,7,1333,98
7248,3,1333,109
7249,18,1334,207
7250,16,1334,196
7251,15,1334,236
7252,9,1334,360
7253,6,1334,376
7254,6,1335,124
7255,3,1336,275
7256,4,1336,127
7257,13,1336,382
7258,20,1337,428
7259,20,1337,449
7260,13,1338,233
7261,15,1338,351
7262,2,1338,367
7263,1,1338,434
7264,9,1338,148
7265,6,1339,140
7266,9,1339,85
7267,5,1339,356
7268,2,1339,141
7269,8,1339,261
7270,4,1339,393
7271,17,1340,437
7272,7,1340,292
7273,10,1340,302
7274,9,1340,224
7275,6,1340,290
7276,7,1340,363
7277,11,1340,455
7278,10,1340,469
7279,17,1341,94
7280,3,1342,281
7281,7,1342,218
7282,8,1342,65
7283,3,1342,116
7284,16,1342,234
7285,17,1342,115
7286,9,1343,419
7287,6,1343,94
7288,18,1343,398
7289,16,1343,221
7290,3,1343,30
7291,3,1343,451
7292,4,1343,308
7293,5,1343,468
7294,9,1343,340
7295,19,1343,49
7296,18,1344,18
7297,20,1344,9
7298,10,1344,477
7299,11,1344,354
7300,7,1344,328
7301,20,1344,2
7302,9,1345,392
7303,16,1345,488
7304,16,1345,466
7305,19,1346,483
7306,9,1346,199
7307,16,1346,468
7308,16,1346,309
7309,7,1347,29
7310,4,1347,144
7311,14,1347,6
7312,2,1347,99
7313,10,1347,274
7314,12,1348,29
7315,12,1348,165
7316,6,1348,248
7317,16,1348,452
7318,18,1349,467
7319,12,1349,37
7320,3,1349,222
7321,18,1349,107
7322,7,1350,454
7323,9,1350,21
7324,14,1350,54
7325,15,1350,299
7326,1,1350,308
7327,1,1350,355
7328,20,1351,134
7329,14,1351,101
7330,15,1351,485
7331,20,1351,401
7332,1,1351,16
7333,20,1351,425
7334,15,1352,132
7335,13,1352,196
7336,14,1352,20
7337,15,1353,312
7338,8,1353,47
7339,18,1353,175
7340,15,1354,376
7341,1,1355,76
7342,6,1355,441
7343,10,1356,60
7344,13,1356,301
7345,7,1356,418
7346,8,1357,486
7347,12,1357,295
7348,14,1357,27
7349,13,1357,10
7350,8,1357,298
7351,17,1357,299
7352,13,1357,489
7353,8,1358,221
7354,3,1358,11
7355,1,1358,431
7356,4,1358,193
7357,9,1358,351
7358,12,1358,36
7359,13,1358,68
7360,15,1359,467
7361,3,1359,288
7362,14,1359,250
7363,11,1359,429
7364,1,1359,378
7365,12,1359,431
7366,13,1360,131
7367,14,1361,219
7368,19,1361,132
7369,8,1361,280
7370,19,1361,333
7371,19,1361,72
7372,12,1361,130
7373,8,1361,22
7374,2,1361,45
7375,3,1362,469
7376,15,1362,370
7377,6,1362,396
7378,6,1363,367
7379,9,1363,384
7380,12,1364,265
7381,20,1364,222
7382,11,1364,366
7383,20,1364,133
7384,3,1364,18
7385,12,1364,306
7386,11,1364,85
7387,7,1364,455
7388,1,1365,207
7389,7,1365,497
7390,7,1365,275
7391,20,1365,380
7392,8,1365,299
7393,5,1365,372
7394,8,1365,167
7395,6,1365,328
7396,11,1365,294
7397,8,1365,255
7398,17,1366,235
7399,13,1367,267
7400,5,1367,20
7401,10,1367,195
7402,5,1367,358
7403,9,1368,190
7404,19,1368,313
7405,5,1368,104
7406,9,1369,24
7407,4,1369,325
7408,1,1369,423
7409,16,1369,147
7410,11,1369,482
7411,17,1369,217
7412,8,1369,441
7413,20,1369,251
7414,5,1369,410
7415,9,1369,440
7416,3,1370,42
7417,11,1370,374
7418,11,1370,484
7419,12,1370,232
7420,6,1370,152
7421,12,1370,137
7422,12,1370,103
7423,14,1370,228
7424,7,1370,129
7425,4,1371,153
7426,19,1371,166
7427,13,1371,210
7428,13,1371,212
7429,8,1371,443
7430,16,1371,407
7431,20,1371,424
7432,5,1373,218
7433,13,1373,148
7434,18,1373,424
7435,20,1373,376
7436,11,1373,244
7437,20,1374,307
7438,16,1374,100
7439,15,1375,394
7440,8,1375,221
7441,19,1375,498
7442,19,1375,116
7443,10,1375,468
7444,2,1375,202
7445,13,1375,11
7446,19,1375,111
7447,17,1375,226
7448,8,1376,408
7449,14,1376,479
7450,10,1377,419
7451,9,1377,329
7452,9,1377,411
7453,5,1377,218
7454,12,1378,199
7455,19,1379,117
7456,8,1379,61
7457,3,1379,52
7458,18,1380,395
7459,16,1380,452
7460,2,1380,297
7461,17,1380,44
7462,14,1380,93
7463,5,1380,391
7464,14,1380,410
7465,9,1381,399
7466,19,1381,341
7467,16,1381,303
7468,8,1381,382
7469,14,1381,98
7470,13,1381,255
7471,15,1382,172
7472,11,1382,416
7473,1,1382,382
7474,12,1382,175
7475,18,1382,33
7476,6,1382,345
7477,3,1382,487
7478,2,1382,432
7479,8,1382,185
7480,4,1382,454
7481,6,1383,99
7482,15,1383,445
7483,11,1383,368
7484,12,1383,170
7485,7,1383,272
7486,14,1383,96
7487,6,1384,76
7488,7,1384,377
7489,12,1384,388
7490,14,1384,31
7491,17,1384,399
7492,19,1384,275
7493,4,1384,213
7494,3,1384,326
7495,19,1384,179
7496,6,1385,483
7497,9,1385,94
7498,19,1385,479
7499,9,1385,182
7500,2,1385,50
7501,8,1385,349
7502,14,1385,42
7503,18,1386,399
7504,18,1386,43
7505,5,1386,78
7506,13,1386,260
7507,14,1386,164
7508,6,1386,359
7509,17,1386,277
7510,4,1386,203
7511,18,1386,278
7512,18,1386,366
7513,7,1387,416
7514,1,1387,499
7515,6,1388,460
7516,15,1388,58
7517,10,1388,143
7518,16,1388,119
7519,1,1389,86
7520,7,1389,224
7521,20,1389,118
7522,3,1389,85
7523,20,1389,78
7524,11,1389,328
7525,9,1389,479
7526,11,1389,304
7527,9,1389,155
7528,12,1389,210
7529,17,1390,72
7530,4,1390,56
7531,18,1390,389
7532,3,1390,37
7533,20,1390,5
7534,19,1390,49
7535,6,1391,403
7536,13,1391,74
7537,5,1391,186
7538,8,1391,346
7539,18,1391,48
7540,8,1391,205
7541,1,1392,17
7542,16,1392,118
7543,12,1392,432
7544,16,1392,83
7545,11,1392,401
7546,18,1392,416
7547,2,1392,461
7548,7,1392,322
7549,18,1392,41
7550,8,1392,378
7551,19,1393,290
7552,20,1393,413
7553,10,1393,272
7554,14,1393,47
7555,8,1393,43
7556,2,1394,127
7557,11,1394,98
7558,14,1394,15
7559,18,1394,239
7560,1,1395,7
7561,1,1395,108
7562,18,1395,465
7563,4,1395,480
7564,16,1396,347
7565,11,1396,276
7566,6,1396,78
7567,20,1396,131
7568,14,1396,183
7569,4,1396,99
7570,15,1396,363
7571,5,1396,109
7572,14,1396,498
7573,11,1396,114
7574,2,1397,267
7575,3,1397,132
7576,1,1397,421
7577,7,1397,249
7578,3,1397,16
7579,9,1397,88
7580,11,1397,207
7581,18,1398,334
7582,3,1398,382
7583,14,1398,340
7584,10,1398,45
7585,17,1398,486
7586,17,1399,377
7587,3,1399,433
7588,1,1399,251
7589,7,1399,249
7590,12,1399,384
7591,19,1399,370
7592,10,1399,44
7593,20,1399,402
7594,11,1400,448
7595,12,1400,469
7596,15,1400,492
7597,9,1401,162
7598,13,1401,182
7599,20,1401,285
7600,15,1401,88
7601,2,1401,218
7602,1,1401,98
7603,7,1401,326
7604,5,1401,138
7605,7,1401,271
7606,3,1402,280
7607,6,1402,125
7608,7,1402,476
7609,5,1402,167
7610,16,1402,134
7611,9,1403,263
7612,6,1403,231
7613,15,1403,277
7614,9,1403,195
7615,14,1403,178
7616,7,1403,317
7617,3,1403,261
7618,8,1404,226
7619,17,1405,485
7620,16,1405,259
7621,11,1405,117
7622,10,1405,143
7623,14,1405,168
7624,20,1405,433
7625,2,1406,63
7626,18,1406,472
7627,11,1406,289
7628,2,1406,145
7629,2,1406,403
7630,17,1406,106
7631,16,1406,421
7632,17,1406,312
7633,8,1406,412
7634,5,1406,98
7635,3,1407,487
7636,4,1407,39
7637,17,1407,116
7638,15,1407,385
7639,2,1407,100
7640,19,1407,134
7641,10,1408,306
7642,4,1408,448
7643,18,1408,382
7644,3,1408,36
7645,11,1408,124
7646,10,1408,133
7647,9,1408,142
7648,9,1408,201
7649,10,1408,359
7650,14,1408,342
7651,10,1409,409
7652,13,1409,424
7653,7,1409,285
7654,8,1409,109
7655,8,1409,249
7656,7,1409,270
7657,1,1409,331
7658,11,1409,184
7659,15,1409,304
7660,12,1410,198
7661,12,1410,478
7662,6,1410,293
7663,12,1410,269
7664,4,1410,171
7665,11,1410,366
7666,8,1410,160
7667,18,1410,376
7668,15,1410,255
7669,6,1411,251
7670,12,1411,365
7671,11,1412,44
7672,17,1412,200
7673,14,1412,378
7674,14,1412,6
7675,19,1413,194
7676,1,1413,154
7677,13,1413,282
7678,12,1414,258
7679,9,1414,255
7680,8,1414,79
7681,20,1414,390
7682,6,1414,88
7683,20,1414,403
7684,3,1415,428
7685,19,1415,215
7686,15,1415,246
7687,10,1416,376
7688,5,1416,157
\.

-- pago
COPY public.pago (id, fecha_pago, fecha_validacion, monto, validado, orden_id) FROM stdin WITH (FORMAT CSV, DELIMITER ',', FORCE_NULL (fecha_validacion));
1,2015-02-15 02:49:37.807671 +00:00,2015-02-15 03:00:35.807671 +00:00,11701.00,true,1
2,2020-02-11 16:58:45.490026 +00:00,2020-02-11 16:59:17.490026 +00:00,5604.00,true,2
3,2022-06-16 23:00:28.238201 +00:00,2022-06-17 09:45:22.238201 +00:00,15508.00,true,2
4,2022-05-04 01:46:32.747076 +00:00,2022-05-12 23:55:43.747076 +00:00,7183.00,true,2
5,2025-08-30 09:11:22.094262 +00:00,2025-08-30 09:18:55.094262 +00:00,27203.00,true,3
6,2017-10-25 13:58:01.539760 +00:00,2017-10-25 14:07:57.539760 +00:00,53.00,true,4
7,2022-05-29 05:20:23.505932 +00:00,2022-06-06 15:58:28.505932 +00:00,57.00,true,4
8,2024-11-08 12:33:03.395420 +00:00,2024-11-10 13:53:55.395420 +00:00,855.00,true,4
9,2018-10-22 09:48:27.689699 +00:00,2018-10-31 19:25:54.689699 +00:00,35.00,true,4
10,2022-05-06 05:26:30.176323 +00:00,,420.00,false,4
11,2023-04-09 10:13:01.886854 +00:00,2023-04-18 03:00:13.886854 +00:00,764.00,true,4
12,2025-08-24 06:29:22.010454 +00:00,2025-08-24 06:34:56.010454 +00:00,1517.00,true,5
13,2025-09-18 08:56:30.397339 +00:00,2025-09-23 22:44:04.397339 +00:00,5639.00,true,5
14,2025-09-20 02:48:29.803713 +00:00,2025-09-30 08:44:43.803713 +00:00,9864.00,true,5
15,2025-09-02 14:08:25.247427 +00:00,2025-09-07 20:57:32.247427 +00:00,16513.00,true,5
16,2025-07-17 18:34:39.416858 +00:00,2025-07-17 18:36:36.416858 +00:00,2247.00,true,6
17,2025-09-27 02:17:48.421846 +00:00,2025-09-27 19:06:19.421846 +00:00,302.00,true,6
18,2025-07-30 15:33:05.580779 +00:00,2025-08-03 21:57:17.580779 +00:00,21193.00,true,6
19,2011-10-08 20:45:19.378441 +00:00,2011-10-08 20:45:52.378441 +00:00,41569.00,true,7
20,2017-06-14 04:38:41.442872 +00:00,2017-06-18 22:25:39.442872 +00:00,5706.00,true,7
21,2020-05-22 10:55:04.644772 +00:00,2020-05-22 11:08:05.644772 +00:00,27234.00,true,8
22,2025-08-22 13:27:11.070355 +00:00,2025-08-26 17:16:09.070355 +00:00,24645.00,true,8
23,2023-11-22 11:03:28.047328 +00:00,2023-12-01 00:37:03.047328 +00:00,3938.00,true,8
24,2020-09-08 21:31:52.631121 +00:00,2020-09-10 19:46:05.631121 +00:00,922.00,true,8
25,2018-01-27 20:06:31.105401 +00:00,2018-01-27 20:07:56.105401 +00:00,5784.00,true,9
26,2019-06-27 07:21:22.889048 +00:00,2019-06-29 02:49:19.889048 +00:00,1746.00,true,9
27,2022-08-06 22:54:36.468872 +00:00,2022-08-16 00:45:29.468872 +00:00,263.00,true,9
28,2018-07-25 09:06:49.223752 +00:00,2018-08-01 18:41:13.223752 +00:00,13869.00,true,9
29,2018-06-15 23:53:33.937974 +00:00,2018-06-27 10:00:37.937974 +00:00,102.00,true,9
30,2023-11-10 04:29:41.069182 +00:00,2023-11-10 04:39:53.069182 +00:00,5013.00,true,10
31,2025-09-08 10:54:48.431571 +00:00,2025-09-12 10:57:22.431571 +00:00,19214.00,true,10
32,2025-01-31 23:02:05.664896 +00:00,2025-02-03 18:53:27.664896 +00:00,2285.00,true,10
33,2025-01-25 12:57:36.526682 +00:00,2025-01-25 22:12:56.526682 +00:00,4243.00,true,10
34,2024-08-28 10:05:53.168101 +00:00,2024-08-29 15:40:12.168101 +00:00,113.00,true,10
35,2025-09-11 16:14:55.998371 +00:00,2025-09-11 16:16:02.998371 +00:00,5070.00,true,11
36,2025-10-04 21:20:46.719456 +00:00,,1173.00,false,11
37,2023-02-15 23:10:49.981880 +00:00,2023-02-15 23:16:29.981880 +00:00,51312.00,true,12
38,2017-04-18 18:37:23.227494 +00:00,2017-04-18 18:53:40.227494 +00:00,36614.00,true,13
39,2010-05-21 01:49:37.916885 +00:00,2010-05-21 01:49:53.916885 +00:00,9056.00,true,14
40,2023-01-20 01:16:00.039030 +00:00,2023-01-30 08:15:24.039030 +00:00,11266.00,true,14
41,2020-04-26 12:54:51.162837 +00:00,2020-05-02 01:17:31.162837 +00:00,7197.00,true,14
42,2023-10-15 06:37:34.043577 +00:00,2023-10-24 04:32:10.043577 +00:00,1592.00,true,14
43,2010-11-11 17:38:41.202593 +00:00,2010-11-20 11:56:22.202593 +00:00,19447.00,true,14
44,2019-10-29 02:10:40.220099 +00:00,2019-10-29 02:23:46.220099 +00:00,371.00,true,15
45,2022-11-07 11:07:47.247475 +00:00,2022-11-09 08:30:08.247475 +00:00,3279.00,true,15
46,2021-07-19 14:19:55.835418 +00:00,2021-07-26 22:19:45.835418 +00:00,406.00,true,15
47,2023-06-24 04:50:57.292623 +00:00,2023-07-02 03:18:05.292623 +00:00,1084.00,true,15
48,2025-02-05 07:45:08.388451 +00:00,2025-02-08 23:57:33.388451 +00:00,1898.00,true,15
49,2021-09-07 04:32:53.899249 +00:00,2021-09-16 21:17:41.899249 +00:00,2366.00,true,15
50,2019-08-03 13:45:27.648873 +00:00,2019-08-03 13:47:40.648873 +00:00,33041.00,true,16
51,2022-04-25 15:38:02.382849 +00:00,2022-05-03 13:28:34.382849 +00:00,10545.00,true,16
52,2025-07-12 16:02:25.011547 +00:00,2025-07-12 16:10:16.011547 +00:00,13134.00,true,17
53,2025-08-04 16:08:32.710753 +00:00,2025-08-07 05:28:26.710753 +00:00,3876.00,true,17
54,2025-07-31 03:35:53.705725 +00:00,2025-08-10 08:21:42.705725 +00:00,867.00,true,17
55,2025-09-23 23:57:27.903004 +00:00,2025-09-30 18:12:57.903004 +00:00,4788.00,true,17
56,2025-08-22 23:16:44.499866 +00:00,2025-08-25 06:11:42.499866 +00:00,1112.00,true,17
57,2023-10-04 14:20:28.542081 +00:00,2023-10-04 14:28:39.542081 +00:00,5938.00,true,18
58,2025-06-04 18:23:28.595689 +00:00,2025-06-07 04:52:50.595689 +00:00,18342.00,true,18
59,2024-04-27 05:39:57.051155 +00:00,2024-04-28 04:33:24.051155 +00:00,23504.00,true,18
60,2025-07-15 05:26:43.306251 +00:00,2025-07-15 05:40:43.306251 +00:00,542.00,true,19
61,2025-08-02 20:43:23.379186 +00:00,,4258.00,false,19
62,2025-09-20 14:07:00.024677 +00:00,2025-09-20 14:08:56.024677 +00:00,6993.00,true,20
63,2025-09-21 06:29:35.940130 +00:00,2025-09-24 20:39:24.940130 +00:00,4466.00,true,20
64,2025-10-02 03:01:53.359361 +00:00,2025-10-03 03:22:10.359361 +00:00,7053.00,true,20
65,2025-09-29 02:37:25.389558 +00:00,,17803.00,false,20
66,2025-08-23 04:09:25.873680 +00:00,2025-08-23 04:15:45.873680 +00:00,45924.00,true,21
67,2017-03-07 22:31:48.006528 +00:00,2017-03-07 22:33:47.006528 +00:00,2125.00,true,22
68,2018-09-07 03:00:16.171638 +00:00,2018-09-18 16:03:47.171638 +00:00,2102.00,true,22
69,2022-09-30 14:46:57.165458 +00:00,2022-10-09 09:36:30.165458 +00:00,174.00,true,22
70,2011-04-14 07:15:23.910396 +00:00,2011-04-14 07:25:00.910396 +00:00,7495.00,true,23
71,2020-11-28 16:54:47.639701 +00:00,2020-12-08 13:32:00.639701 +00:00,4803.00,true,23
72,2023-04-01 18:38:43.008356 +00:00,2023-04-04 04:49:22.008356 +00:00,7999.00,true,23
73,2012-08-27 23:09:33.152525 +00:00,2012-09-06 15:29:22.152525 +00:00,3398.00,true,23
74,2017-02-14 16:07:28.277939 +00:00,2017-02-14 16:09:50.277939 +00:00,54976.00,true,24
75,2019-04-07 07:59:31.655590 +00:00,2019-04-07 08:01:01.655590 +00:00,13966.00,true,25
76,2025-09-14 06:54:22.206010 +00:00,2025-09-14 07:04:38.206010 +00:00,6650.00,true,26
77,2025-09-22 17:28:58.114485 +00:00,2025-10-02 15:48:55.114485 +00:00,5120.00,true,26
78,2025-10-01 05:12:32.488072 +00:00,2025-10-03 21:13:10.488072 +00:00,2197.00,true,26
79,2025-09-19 09:37:40.621883 +00:00,2025-09-22 04:52:58.621883 +00:00,3310.00,true,26
80,2025-09-28 05:38:17.670212 +00:00,,12731.00,false,26
81,2025-09-16 07:16:21.153985 +00:00,2025-09-27 04:21:57.153985 +00:00,3280.00,true,26
82,2022-11-02 09:05:37.207011 +00:00,2022-11-02 09:06:49.207011 +00:00,3584.00,true,27
83,2025-02-26 19:32:54.880816 +00:00,2025-03-04 11:30:57.880816 +00:00,3119.00,true,27
84,2025-08-26 05:10:42.794209 +00:00,2025-09-01 01:00:13.794209 +00:00,18907.00,true,27
85,2020-02-24 22:29:54.236554 +00:00,2020-02-24 22:32:40.236554 +00:00,781.00,true,28
86,2025-09-10 19:34:18.649885 +00:00,2025-09-11 18:26:25.649885 +00:00,390.00,true,28
87,2025-01-26 16:40:44.383302 +00:00,2025-01-28 11:18:51.383302 +00:00,702.00,true,28
88,2022-06-17 16:35:45.581144 +00:00,2022-06-25 14:10:08.581144 +00:00,31.00,true,28
89,2022-02-18 10:42:36.534178 +00:00,2022-02-18 10:49:30.534178 +00:00,14431.00,true,29
90,2022-03-20 00:06:06.377982 +00:00,,2054.00,false,29
91,2025-06-15 04:25:41.355693 +00:00,2025-06-25 00:48:04.355693 +00:00,17040.00,true,29
92,2024-02-02 09:22:30.194837 +00:00,2024-02-08 15:00:52.194837 +00:00,11660.00,true,29
93,2025-08-08 06:09:28.965884 +00:00,2025-08-08 06:11:33.965884 +00:00,4146.00,true,30
94,2025-08-17 10:26:54.505633 +00:00,2025-08-28 00:25:25.505633 +00:00,894.00,true,30
95,2014-10-07 11:49:52.511103 +00:00,2014-10-07 12:04:04.511103 +00:00,7366.00,true,31
96,2024-09-01 01:44:45.108081 +00:00,2024-09-06 03:20:36.108081 +00:00,2694.00,true,31
97,2020-03-31 18:35:10.199499 +00:00,2020-04-07 13:02:32.199499 +00:00,7010.00,true,31
98,2025-08-29 02:07:39.006122 +00:00,2025-08-29 02:21:15.006122 +00:00,18603.00,true,32
99,2025-09-05 20:18:10.799358 +00:00,2025-09-15 08:32:05.799358 +00:00,13473.00,true,32
100,2025-09-26 14:47:58.787983 +00:00,2025-10-04 10:55:31.787983 +00:00,24627.00,true,32
101,2025-09-25 02:42:48.478038 +00:00,2025-09-25 02:55:00.478038 +00:00,11081.00,true,33
102,2025-10-04 04:24:22.497672 +00:00,2025-10-04 10:37:01.497672 +00:00,11053.00,true,33
103,2025-10-03 11:00:52.483835 +00:00,,6020.00,false,33
104,2025-10-03 15:26:45.509466 +00:00,,2732.00,false,33
105,2025-09-29 08:31:39.408377 +00:00,,2385.00,false,33
106,2025-09-30 09:33:33.458823 +00:00,,3027.00,false,33
107,2023-06-17 07:33:16.049260 +00:00,2023-06-17 07:48:57.049260 +00:00,812.00,true,34
108,2025-05-28 17:24:35.161991 +00:00,2025-05-31 10:06:25.161991 +00:00,2978.00,true,34
109,2025-06-14 03:35:06.292951 +00:00,2025-06-17 16:55:53.292951 +00:00,14221.00,true,34
110,2025-01-13 20:49:29.652298 +00:00,2025-01-13 22:00:55.652298 +00:00,1121.00,true,34
111,2019-12-24 18:20:03.327383 +00:00,2019-12-24 18:33:23.327383 +00:00,1179.00,true,35
112,2023-01-28 08:53:13.343127 +00:00,2023-02-06 21:45:19.343127 +00:00,2457.00,true,35
113,2025-08-22 02:35:00.215590 +00:00,2025-08-22 02:50:23.215590 +00:00,4635.00,true,36
114,2025-09-24 19:54:54.519057 +00:00,2025-09-29 13:27:05.519057 +00:00,8278.00,true,36
115,2025-08-31 21:22:50.908244 +00:00,2025-09-05 22:53:29.908244 +00:00,2267.00,true,36
116,2025-09-17 00:43:43.959853 +00:00,2025-09-20 23:24:40.959853 +00:00,6070.00,true,36
117,2022-04-06 10:59:44.809143 +00:00,2022-04-06 11:15:16.809143 +00:00,16499.00,true,37
118,2022-11-26 04:52:53.314963 +00:00,2022-11-27 19:27:28.314963 +00:00,21004.00,true,37
119,2023-09-15 10:30:14.507227 +00:00,2023-09-19 03:52:06.507227 +00:00,2618.00,true,37
120,2024-05-12 02:15:39.380275 +00:00,2024-05-23 09:58:35.380275 +00:00,6878.00,true,37
121,2018-07-26 22:58:49.060460 +00:00,2018-07-26 23:13:32.060460 +00:00,4502.00,true,38
122,2020-01-30 02:07:38.797807 +00:00,2020-02-08 17:09:39.797807 +00:00,8411.00,true,38
123,2020-09-18 19:55:30.131647 +00:00,2020-09-20 03:02:30.131647 +00:00,11657.00,true,38
124,2025-08-09 00:29:50.500717 +00:00,2025-08-09 00:34:57.500717 +00:00,11723.00,true,39
125,2025-09-22 21:37:17.746284 +00:00,,14177.00,false,39
126,2025-09-20 20:46:35.887271 +00:00,2025-09-20 20:59:09.887271 +00:00,900.00,true,40
127,2025-09-26 19:38:02.243888 +00:00,2025-09-29 16:12:02.243888 +00:00,12400.00,true,40
128,2025-09-23 05:57:42.261744 +00:00,2025-09-30 23:49:38.261744 +00:00,13011.00,true,40
129,2015-07-10 07:08:02.785722 +00:00,2015-07-10 07:16:35.785722 +00:00,1719.00,true,41
130,2025-05-22 13:47:49.089483 +00:00,2025-06-02 11:31:37.089483 +00:00,9658.00,true,41
131,2017-08-21 00:36:23.199957 +00:00,2017-08-25 21:15:35.199957 +00:00,12765.00,true,41
132,2022-06-30 12:59:57.691283 +00:00,2022-07-08 08:31:24.691283 +00:00,2812.00,true,41
133,2020-01-08 14:53:01.315521 +00:00,2020-01-16 15:26:29.315521 +00:00,8104.00,true,41
134,2022-11-28 06:59:06.674956 +00:00,2022-12-01 04:00:33.674956 +00:00,917.00,true,41
135,2025-07-11 18:45:14.462559 +00:00,2025-07-11 18:48:29.462559 +00:00,1855.00,true,42
136,2025-09-07 20:27:40.581011 +00:00,2025-09-16 16:47:57.581011 +00:00,3325.00,true,42
137,2025-07-27 16:22:20.742349 +00:00,2025-08-06 14:22:03.742349 +00:00,3400.00,true,42
138,2025-09-22 07:09:20.034513 +00:00,2025-09-27 05:31:34.034513 +00:00,115.00,true,42
139,2025-07-15 10:54:20.022350 +00:00,2025-07-24 07:51:13.022350 +00:00,635.00,true,42
140,2025-09-12 09:06:40.995884 +00:00,2025-09-22 07:38:36.995884 +00:00,3810.00,true,42
141,2016-03-31 23:28:24.694020 +00:00,2016-03-31 23:36:48.694020 +00:00,592.00,true,43
142,2017-05-03 13:44:50.338991 +00:00,2017-05-13 18:41:50.338991 +00:00,1433.00,true,43
143,2018-09-23 04:34:15.903666 +00:00,2018-09-29 02:50:45.903666 +00:00,3070.00,true,43
144,2016-05-11 12:48:45.451218 +00:00,2016-05-12 19:25:21.451218 +00:00,4282.00,true,43
145,2025-08-03 04:14:26.655516 +00:00,2025-08-03 04:19:25.655516 +00:00,84.00,true,44
146,2025-10-03 14:03:03.535813 +00:00,,9909.00,false,44
147,2025-09-17 06:27:38.035169 +00:00,2025-09-27 05:31:14.035169 +00:00,1626.00,true,44
148,2025-08-24 13:03:24.320966 +00:00,2025-08-27 18:35:12.320966 +00:00,4286.00,true,44
149,2025-09-10 13:28:47.696602 +00:00,2025-09-17 11:32:30.696602 +00:00,855.00,true,44
150,2011-09-24 14:07:19.210017 +00:00,2011-09-24 14:09:07.210017 +00:00,588.00,true,45
151,2018-10-28 21:09:48.385600 +00:00,2018-10-29 20:50:13.385600 +00:00,3260.00,true,45
152,2014-07-10 18:45:58.398374 +00:00,2014-07-11 00:56:09.398374 +00:00,17021.00,true,45
153,2020-03-17 02:32:51.300516 +00:00,2020-03-21 21:19:54.300516 +00:00,7763.00,true,45
154,2022-12-16 21:50:21.996203 +00:00,2022-12-23 18:04:23.996203 +00:00,26500.00,true,45
155,2012-11-02 17:40:35.456888 +00:00,2012-11-04 12:21:04.456888 +00:00,7463.00,true,45
156,2025-07-04 14:35:37.367821 +00:00,2025-07-04 14:51:16.367821 +00:00,574.00,true,46
157,2025-07-13 12:37:32.014672 +00:00,2025-07-16 14:19:51.014672 +00:00,7287.00,true,46
158,2025-08-17 19:53:35.040353 +00:00,2025-08-21 12:21:44.040353 +00:00,12911.00,true,46
159,2025-09-02 23:39:45.459341 +00:00,2025-09-09 01:03:44.459341 +00:00,4056.00,true,46
160,2025-09-21 10:55:08.610438 +00:00,2025-09-28 09:04:11.610438 +00:00,2211.00,true,46
161,2025-08-03 23:16:36.352685 +00:00,2025-08-12 07:47:36.352685 +00:00,219.00,true,46
162,2015-12-07 01:03:05.475794 +00:00,2015-12-07 01:07:27.475794 +00:00,1117.00,true,47
163,2020-04-27 09:38:46.449368 +00:00,2020-05-07 10:06:30.449368 +00:00,51.00,true,47
164,2020-03-03 19:04:22.637786 +00:00,2020-03-06 22:39:41.637786 +00:00,3479.00,true,47
165,2021-08-05 06:44:17.891103 +00:00,2021-08-13 16:26:59.891103 +00:00,578.00,true,47
166,2021-07-20 23:25:34.397706 +00:00,2021-07-21 11:51:52.397706 +00:00,133.00,true,47
167,2012-09-16 09:21:39.770251 +00:00,2012-09-16 09:27:12.770251 +00:00,4659.00,true,48
168,2024-12-05 01:34:59.689221 +00:00,2024-12-10 14:18:40.689221 +00:00,739.00,true,48
169,2024-10-26 07:06:14.148376 +00:00,2024-11-02 14:17:01.148376 +00:00,1994.00,true,48
170,2020-11-20 22:27:21.402499 +00:00,2020-11-24 09:40:48.402499 +00:00,14402.00,true,48
171,2015-06-06 07:04:32.514919 +00:00,2015-06-07 17:46:14.514919 +00:00,1849.00,true,48
172,2020-11-04 11:41:51.364094 +00:00,2020-11-06 19:07:21.364094 +00:00,1757.00,true,48
173,2025-07-05 11:12:19.714470 +00:00,2025-07-05 11:16:58.714470 +00:00,9978.00,true,49
174,2025-07-21 01:07:10.770371 +00:00,2025-07-27 15:39:38.770371 +00:00,743.00,true,49
175,2025-07-29 18:47:18.921215 +00:00,2025-07-31 23:41:52.921215 +00:00,672.00,true,49
176,2025-07-22 17:16:47.681156 +00:00,2025-07-23 01:09:15.681156 +00:00,1072.00,true,49
177,2013-04-28 01:23:21.586861 +00:00,2013-04-28 01:26:02.586861 +00:00,1743.00,true,50
178,2022-04-02 15:50:09.096776 +00:00,2022-04-04 07:44:47.096776 +00:00,8817.00,true,50
179,2013-07-27 03:46:29.490878 +00:00,2013-07-28 15:26:29.490878 +00:00,13754.00,true,50
180,2015-12-25 23:02:04.272666 +00:00,2016-01-05 02:07:17.272666 +00:00,1224.00,true,50
181,2025-08-15 09:19:50.584740 +00:00,2025-08-15 09:35:42.584740 +00:00,2695.00,true,51
182,2025-09-19 00:29:03.151498 +00:00,2025-09-24 10:43:04.151498 +00:00,10989.00,true,51
183,2019-06-16 12:37:34.977874 +00:00,2019-06-16 12:52:30.977874 +00:00,2960.00,true,52
184,2020-07-09 20:23:42.767737 +00:00,2020-07-11 06:28:07.767737 +00:00,730.00,true,52
185,2022-05-31 22:20:04.265834 +00:00,2022-06-05 13:01:33.265834 +00:00,127.00,true,52
186,2023-12-07 11:57:09.652083 +00:00,2023-12-18 10:52:35.652083 +00:00,383.00,true,52
187,2024-03-04 14:54:34.521615 +00:00,2024-03-15 20:02:14.521615 +00:00,4257.00,true,52
188,2021-12-16 12:32:35.827399 +00:00,2021-12-20 22:33:38.827399 +00:00,5411.00,true,52
189,2011-01-29 23:22:36.316824 +00:00,2011-01-29 23:33:08.316824 +00:00,4231.00,true,53
190,2017-09-16 06:08:01.621338 +00:00,2017-09-22 21:14:47.621338 +00:00,1622.00,true,53
191,2025-09-17 01:01:17.581964 +00:00,2025-09-24 02:41:33.581964 +00:00,542.00,true,53
192,2018-09-16 23:49:41.610761 +00:00,2018-09-17 00:00:30.610761 +00:00,106.00,true,54
193,2020-01-21 03:33:09.458004 +00:00,2020-01-25 14:02:10.458004 +00:00,106.00,true,54
194,2022-01-23 07:53:58.950184 +00:00,2022-01-25 02:31:06.950184 +00:00,19.00,true,54
195,2023-12-10 23:30:30.210028 +00:00,2023-12-19 10:26:00.210028 +00:00,74.00,true,54
196,2018-12-09 16:31:39.393258 +00:00,2018-12-19 20:25:37.393258 +00:00,88.00,true,54
197,2013-07-24 14:04:25.238228 +00:00,2013-07-24 14:17:26.238228 +00:00,15006.00,true,55
198,2022-12-22 09:30:10.907763 +00:00,2022-12-26 02:02:42.907763 +00:00,23605.00,true,55
199,2025-07-11 02:01:47.914514 +00:00,2025-07-11 02:14:14.914514 +00:00,17217.00,true,56
200,2025-08-13 01:26:35.262001 +00:00,2025-08-19 13:49:02.262001 +00:00,4273.00,true,56
201,2025-08-30 19:16:34.295876 +00:00,2025-09-06 11:01:36.295876 +00:00,4356.00,true,56
202,2025-08-27 11:47:02.360740 +00:00,2025-09-04 02:35:03.360740 +00:00,7360.00,true,56
203,2025-08-12 21:32:35.384344 +00:00,2025-08-23 10:14:18.384344 +00:00,2256.00,true,56
204,2025-07-17 15:49:09.781902 +00:00,2025-07-18 16:30:23.781902 +00:00,17129.00,true,56
205,2018-07-13 10:45:45.863378 +00:00,2018-07-13 10:59:42.863378 +00:00,918.00,true,57
206,2020-07-16 09:24:51.310066 +00:00,2020-07-17 03:16:37.310066 +00:00,1133.00,true,57
207,2023-02-24 19:06:31.889952 +00:00,2023-02-28 13:00:31.889952 +00:00,1770.00,true,57
208,2024-05-12 19:16:26.714266 +00:00,2024-05-18 20:29:45.714266 +00:00,1803.00,true,57
209,2024-06-01 18:08:55.836149 +00:00,2024-06-08 08:34:21.836149 +00:00,1697.00,true,57
210,2020-11-21 23:45:09.403050 +00:00,2020-11-23 02:12:17.403050 +00:00,1652.00,true,57
211,2014-02-21 20:41:49.381572 +00:00,2014-02-21 20:50:28.381572 +00:00,9971.00,true,58
212,2016-04-18 19:23:04.131659 +00:00,2016-04-28 12:40:53.131659 +00:00,2750.00,true,58
213,2024-03-24 08:11:43.663910 +00:00,2024-03-27 00:01:35.663910 +00:00,308.00,true,58
214,2025-07-20 21:19:42.232618 +00:00,2025-07-20 21:21:34.232618 +00:00,5395.00,true,59
215,2025-08-06 15:56:03.955289 +00:00,2025-08-14 07:49:13.955289 +00:00,6623.00,true,59
216,2025-08-12 18:58:05.608309 +00:00,2025-08-16 23:24:43.608309 +00:00,4083.00,true,59
217,2025-07-28 10:55:11.362931 +00:00,2025-07-31 17:42:56.362931 +00:00,5177.00,true,59
218,2025-09-23 02:41:57.871871 +00:00,2025-10-04 13:02:11.871871 +00:00,1719.00,true,59
219,2025-07-28 14:23:56.444778 +00:00,,16444.00,false,59
220,2022-04-28 13:45:31.185671 +00:00,2022-04-28 13:47:59.185671 +00:00,2095.00,true,60
221,2024-02-06 05:00:09.108652 +00:00,2024-02-08 21:10:43.108652 +00:00,3205.00,true,60
222,2023-05-10 08:26:13.949246 +00:00,2023-05-18 02:15:56.949246 +00:00,3325.00,true,60
223,2024-03-19 18:21:38.072801 +00:00,2024-03-24 03:25:24.072801 +00:00,2849.00,true,60
224,2023-02-23 16:52:30.892026 +00:00,2023-03-05 05:52:02.892026 +00:00,182.00,true,60
225,2024-12-23 10:40:17.273201 +00:00,2024-12-26 15:24:31.273201 +00:00,1502.00,true,60
226,2015-02-07 11:25:25.914748 +00:00,2015-02-07 11:36:44.914748 +00:00,1042.00,true,61
227,2017-10-07 19:38:37.815217 +00:00,2017-10-16 19:42:44.815217 +00:00,2362.00,true,61
228,2018-10-03 13:05:27.960716 +00:00,2018-10-05 18:34:53.960716 +00:00,6009.00,true,61
229,2020-06-25 03:12:21.727714 +00:00,2020-07-02 02:39:59.727714 +00:00,1949.00,true,61
230,2019-04-26 00:41:00.855361 +00:00,2019-04-26 00:50:52.855361 +00:00,40279.00,true,62
231,2021-03-22 09:16:54.914548 +00:00,2021-03-22 09:21:44.914548 +00:00,1594.00,true,63
232,2025-03-09 20:01:12.018579 +00:00,2025-03-19 11:33:15.018579 +00:00,9878.00,true,63
233,2022-03-19 08:05:11.667966 +00:00,2022-03-23 19:20:26.667966 +00:00,8094.00,true,63
234,2022-10-04 21:08:13.200805 +00:00,,2522.00,false,63
235,2023-11-07 02:59:50.098081 +00:00,2023-11-09 11:44:29.098081 +00:00,857.00,true,63
236,2023-04-16 23:44:13.853651 +00:00,2023-04-19 04:19:45.853651 +00:00,3050.00,true,63
237,2012-12-19 03:26:35.470878 +00:00,2012-12-19 03:39:58.470878 +00:00,15337.00,true,64
238,2022-02-15 17:45:24.097543 +00:00,2022-02-17 01:17:54.097543 +00:00,4638.00,true,64
239,2021-11-19 23:40:01.227143 +00:00,2021-11-30 13:21:47.227143 +00:00,3913.00,true,64
240,2022-05-05 20:52:34.156414 +00:00,2022-05-16 04:30:20.156414 +00:00,6940.00,true,64
241,2025-08-09 23:59:36.929286 +00:00,2025-08-10 00:02:06.929286 +00:00,113.00,true,65
242,2025-09-05 17:40:33.637827 +00:00,2025-09-11 04:31:57.637827 +00:00,6256.00,true,65
243,2025-08-27 10:09:47.985968 +00:00,2025-09-04 02:51:11.985968 +00:00,3790.00,true,65
244,2025-08-10 19:41:44.131176 +00:00,2025-08-13 07:03:22.131176 +00:00,2919.00,true,65
245,2025-08-24 12:00:04.896782 +00:00,2025-08-28 00:21:09.896782 +00:00,7431.00,true,65
246,2025-08-10 08:47:48.975805 +00:00,2025-08-15 18:49:46.975805 +00:00,1400.00,true,65
247,2018-04-08 05:23:01.700617 +00:00,2018-04-08 05:25:49.700617 +00:00,2438.00,true,66
248,2021-05-13 18:14:45.535970 +00:00,2021-05-24 18:04:36.535970 +00:00,5408.00,true,66
249,2021-07-30 05:27:00.016327 +00:00,2021-08-07 03:03:32.016327 +00:00,14650.00,true,66
250,2020-11-07 22:11:41.784198 +00:00,2020-11-19 09:07:59.784198 +00:00,14973.00,true,66
251,2022-06-26 11:23:07.712640 +00:00,2022-07-06 18:33:37.712640 +00:00,21344.00,true,66
252,2025-09-02 20:40:14.821370 +00:00,2025-09-02 20:40:51.821370 +00:00,3840.00,true,67
253,2025-09-05 07:17:19.112093 +00:00,2025-09-13 19:33:09.112093 +00:00,5192.00,true,67
254,2025-09-18 10:51:32.289593 +00:00,2025-09-22 12:30:58.289593 +00:00,88.00,true,67
255,2025-09-08 00:56:14.652001 +00:00,2025-09-16 23:15:27.652001 +00:00,1424.00,true,67
256,2025-09-25 12:53:20.590420 +00:00,2025-09-29 01:15:44.590420 +00:00,16680.00,true,67
257,2025-09-06 04:11:03.545121 +00:00,,2384.00,false,67
258,2010-02-06 10:17:08.958155 +00:00,2010-02-06 10:25:41.958155 +00:00,21202.00,true,68
259,2015-02-01 00:40:42.294522 +00:00,2015-02-11 21:56:51.294522 +00:00,4658.00,true,68
260,2021-07-22 02:36:07.854645 +00:00,2021-07-23 03:37:19.854645 +00:00,1152.00,true,68
261,2021-06-21 07:00:29.826216 +00:00,2021-06-26 13:35:11.826216 +00:00,14226.00,true,68
262,2022-10-08 15:50:24.441404 +00:00,2022-10-14 17:58:34.441404 +00:00,11788.00,true,68
263,2025-09-15 13:45:44.366861 +00:00,2025-09-15 13:46:06.366861 +00:00,10398.00,true,69
264,2025-09-25 03:40:27.262365 +00:00,2025-09-30 09:56:35.262365 +00:00,12496.00,true,69
265,2025-09-29 18:52:39.825613 +00:00,,6728.00,false,69
266,2025-10-01 16:41:03.701398 +00:00,2025-10-05 14:53:59.701398 +00:00,17991.00,true,69
267,2019-12-13 06:16:39.019054 +00:00,2019-12-13 06:18:19.019054 +00:00,6318.00,true,70
268,2019-12-30 23:19:08.482263 +00:00,2020-01-01 08:29:30.482263 +00:00,7615.00,true,70
269,2022-11-20 21:11:10.617495 +00:00,2022-11-28 03:28:54.617495 +00:00,4356.00,true,70
270,2025-09-23 23:05:55.819410 +00:00,2025-09-23 23:08:52.819410 +00:00,13727.00,true,71
271,2025-09-28 08:03:44.215198 +00:00,2025-10-03 07:57:37.215198 +00:00,33012.00,true,71
272,2025-09-26 05:25:34.005295 +00:00,2025-09-26 21:38:43.005295 +00:00,8444.00,true,71
273,2023-07-27 09:47:53.351927 +00:00,2023-07-27 10:03:36.351927 +00:00,53170.00,true,72
274,2025-07-12 22:01:23.836859 +00:00,2025-07-12 22:15:22.836859 +00:00,51121.00,true,73
275,2020-12-24 21:30:22.702737 +00:00,2020-12-24 21:34:44.702737 +00:00,10679.00,true,74
276,2024-10-20 16:51:30.263075 +00:00,2024-10-28 00:19:50.263075 +00:00,8348.00,true,74
277,2024-10-02 09:04:02.083135 +00:00,2024-10-10 23:37:38.083135 +00:00,37883.00,true,74
278,2021-05-08 19:31:32.666288 +00:00,2021-05-17 23:44:47.666288 +00:00,6730.00,true,74
279,2025-08-25 05:41:29.504384 +00:00,2025-08-25 05:50:27.504384 +00:00,8839.00,true,75
280,2025-09-25 21:44:39.555261 +00:00,2025-09-28 14:41:41.555261 +00:00,31114.00,true,75
281,2025-09-13 16:46:17.920999 +00:00,2025-09-17 02:55:49.920999 +00:00,13748.00,true,75
282,2025-09-19 09:48:31.528470 +00:00,2025-09-19 21:21:27.528470 +00:00,7931.00,true,75
283,2025-09-20 10:18:38.074763 +00:00,2025-09-30 00:43:13.074763 +00:00,4259.00,true,75
284,2022-07-21 12:26:50.950989 +00:00,2022-07-21 12:37:04.950989 +00:00,1897.00,true,76
285,2024-03-06 12:59:12.535160 +00:00,2024-03-10 06:20:00.535160 +00:00,623.00,true,76
286,2023-02-15 07:59:22.087103 +00:00,2023-02-22 17:49:31.087103 +00:00,1380.00,true,76
287,2025-08-03 18:12:49.017202 +00:00,2025-08-07 06:19:20.017202 +00:00,37.00,true,76
288,2023-03-12 03:33:51.525205 +00:00,2023-03-20 19:55:13.525205 +00:00,263.00,true,76
289,2016-09-10 20:32:12.195741 +00:00,2016-09-10 20:32:38.195741 +00:00,1018.00,true,77
290,2025-03-19 11:54:25.391171 +00:00,2025-03-26 21:08:07.391171 +00:00,4809.00,true,77
291,2021-06-19 10:54:30.002612 +00:00,2021-06-22 10:55:12.002612 +00:00,2322.00,true,77
292,2022-02-02 21:36:33.205886 +00:00,2022-02-09 01:10:18.205886 +00:00,2239.00,true,77
293,2023-04-24 12:30:41.623215 +00:00,2023-05-01 23:46:50.623215 +00:00,709.00,true,77
294,2021-10-22 15:32:22.092951 +00:00,2021-10-22 15:34:10.092951 +00:00,15623.00,true,78
295,2024-04-20 14:56:00.948342 +00:00,2024-05-02 00:53:28.948342 +00:00,4536.00,true,78
296,2022-03-17 23:39:33.427308 +00:00,2022-03-18 19:50:49.427308 +00:00,21330.00,true,78
297,2022-10-07 07:23:47.767408 +00:00,2022-10-08 02:48:45.767408 +00:00,11286.00,true,78
298,2025-07-17 13:11:43.129499 +00:00,2025-07-19 04:52:03.129499 +00:00,5060.00,true,78
299,2025-05-03 14:38:53.865580 +00:00,2025-05-03 14:41:19.865580 +00:00,5737.00,true,79
300,2025-07-26 05:22:12.427895 +00:00,2025-07-30 04:55:59.427895 +00:00,4534.00,true,79
301,2015-05-30 18:23:30.240602 +00:00,2015-05-30 18:39:52.240602 +00:00,7543.00,true,80
302,2018-02-15 07:29:11.364278 +00:00,2018-02-26 13:36:06.364278 +00:00,20123.00,true,80
303,2013-10-26 04:23:48.936800 +00:00,2013-10-26 04:26:50.936800 +00:00,19038.00,true,81
304,2015-07-24 02:53:42.296466 +00:00,2015-07-27 14:44:03.296466 +00:00,5076.00,true,81
305,2014-02-17 17:39:18.546579 +00:00,2014-02-23 01:15:35.546579 +00:00,16252.00,true,81
306,2018-12-20 04:45:15.061044 +00:00,2018-12-20 07:51:16.061044 +00:00,12364.00,true,81
307,2019-02-21 22:26:17.704965 +00:00,2019-02-21 22:38:41.704965 +00:00,17931.00,true,82
308,2025-07-15 02:49:58.801521 +00:00,2025-07-15 03:04:17.801521 +00:00,15526.00,true,83
309,2025-09-16 22:44:58.478194 +00:00,,6776.00,false,83
310,2010-01-15 15:20:34.348014 +00:00,2010-01-15 15:25:28.348014 +00:00,23549.00,true,84
311,2013-11-18 17:24:01.031897 +00:00,2013-11-21 10:25:44.031897 +00:00,21941.00,true,84
312,2024-05-06 07:18:54.162208 +00:00,2024-05-12 15:11:04.162208 +00:00,2190.00,true,84
313,2023-02-27 03:06:19.265934 +00:00,2023-03-10 06:43:44.265934 +00:00,10701.00,true,84
314,2013-10-25 15:23:40.215511 +00:00,2013-10-29 19:42:59.215511 +00:00,3527.00,true,84
315,2025-07-25 00:12:02.312175 +00:00,2025-07-25 00:15:59.312175 +00:00,484.00,true,85
316,2025-09-21 02:25:40.940041 +00:00,2025-09-29 15:22:15.940041 +00:00,2162.00,true,85
317,2025-10-04 03:16:22.029139 +00:00,,2111.00,false,85
318,2025-08-25 15:04:14.940478 +00:00,2025-09-03 07:28:57.940478 +00:00,3237.00,true,85
319,2025-09-04 03:14:06.319860 +00:00,2025-09-08 14:32:49.319860 +00:00,7948.00,true,85
320,2025-09-29 16:38:07.204022 +00:00,,8006.00,false,85
321,2025-09-26 16:14:17.508222 +00:00,2025-09-26 16:27:50.508222 +00:00,4224.00,true,86
322,2025-09-28 00:49:04.985652 +00:00,2025-10-06 00:32:10.985652 +00:00,12852.00,true,86
323,2025-10-03 22:19:25.166015 +00:00,2025-10-05 07:10:13.166015 +00:00,24671.00,true,86
324,2025-10-01 11:20:21.541697 +00:00,,1783.00,false,86
325,2025-10-04 18:50:00.736564 +00:00,,29306.00,false,86
326,2022-04-18 17:01:15.563260 +00:00,2022-04-18 17:07:03.563260 +00:00,1962.00,true,87
327,2025-03-24 09:01:04.452100 +00:00,2025-03-28 04:37:43.452100 +00:00,19197.00,true,87
328,2022-10-20 16:55:00.882285 +00:00,2022-10-26 22:14:32.882285 +00:00,9090.00,true,87
329,2025-07-28 23:28:49.024205 +00:00,2025-07-28 23:36:31.024205 +00:00,6703.00,true,88
330,2025-09-05 14:59:04.414600 +00:00,2025-09-05 21:45:46.414600 +00:00,31.00,true,88
331,2025-08-01 03:19:00.878702 +00:00,2025-08-11 11:08:14.878702 +00:00,10769.00,true,88
332,2025-09-05 01:07:08.318786 +00:00,2025-09-14 17:31:19.318786 +00:00,17840.00,true,88
333,2013-06-30 11:44:28.700993 +00:00,2013-06-30 11:53:36.700993 +00:00,23381.00,true,89
334,2014-04-14 06:18:38.498973 +00:00,2014-04-24 01:39:14.498973 +00:00,2726.00,true,89
335,2025-09-26 14:21:46.179286 +00:00,,3355.00,false,89
336,2023-03-06 00:06:30.534743 +00:00,2023-03-09 08:50:12.534743 +00:00,21029.00,true,89
337,2023-06-30 22:00:46.252000 +00:00,2023-07-07 16:43:58.252000 +00:00,589.00,true,89
338,2025-07-30 21:22:34.403136 +00:00,2025-07-30 21:36:45.403136 +00:00,2419.00,true,90
339,2025-09-05 09:25:43.715401 +00:00,2025-09-07 06:11:08.715401 +00:00,1542.00,true,90
340,2025-08-31 22:04:14.590851 +00:00,2025-09-12 01:56:34.590851 +00:00,5197.00,true,90
341,2025-08-21 00:51:55.813958 +00:00,2025-08-29 03:25:36.813958 +00:00,449.00,true,90
342,2025-09-27 06:43:39.587006 +00:00,2025-10-05 07:22:11.587006 +00:00,5547.00,true,90
343,2025-09-11 20:22:26.322517 +00:00,2025-09-12 06:33:50.322517 +00:00,20506.00,true,90
344,2025-07-02 06:23:03.179452 +00:00,2025-07-02 06:28:51.179452 +00:00,2570.00,true,91
345,2025-09-12 10:56:40.552482 +00:00,2025-09-13 17:30:00.552482 +00:00,2433.00,true,91
346,2015-05-19 03:51:43.909842 +00:00,2015-05-19 03:56:03.909842 +00:00,12353.00,true,92
347,2020-01-28 18:09:46.240992 +00:00,2020-02-07 08:48:20.240992 +00:00,9821.00,true,92
348,2021-06-20 06:52:19.107736 +00:00,2021-06-26 07:21:49.107736 +00:00,40288.00,true,92
349,2025-08-22 00:32:50.960116 +00:00,2025-08-22 00:46:29.960116 +00:00,11312.00,true,93
350,2025-09-27 15:16:26.410451 +00:00,2025-09-27 15:26:22.410451 +00:00,22050.00,true,94
351,2025-09-28 07:07:37.566635 +00:00,,5505.00,false,94
352,2013-04-25 14:08:58.981423 +00:00,2013-04-25 14:12:44.981423 +00:00,14966.00,true,95
353,2017-11-04 18:36:51.195489 +00:00,2017-11-11 20:47:39.195489 +00:00,4099.00,true,95
354,2014-07-25 10:43:23.389159 +00:00,2014-07-29 05:58:26.389159 +00:00,3284.00,true,95
355,2021-08-20 09:31:20.527822 +00:00,2021-08-20 09:41:23.527822 +00:00,248.00,true,96
356,2022-06-12 10:59:05.355260 +00:00,2022-06-23 03:22:15.355260 +00:00,156.00,true,96
357,2024-08-01 23:01:52.248596 +00:00,2024-08-04 03:53:43.248596 +00:00,1605.00,true,96
358,2023-01-29 00:03:46.735771 +00:00,2023-01-31 04:43:49.735771 +00:00,76.00,true,96
359,2022-11-05 21:02:58.997298 +00:00,2022-11-16 15:57:35.997298 +00:00,278.00,true,96
360,2024-11-05 05:34:17.151448 +00:00,2024-11-07 12:04:54.151448 +00:00,499.00,true,96
361,2020-10-18 04:08:48.901877 +00:00,2020-10-18 04:19:16.901877 +00:00,3240.00,true,97
362,2022-08-03 21:24:42.267203 +00:00,,750.00,false,97
363,2024-10-25 10:13:20.303559 +00:00,2024-11-05 02:12:15.303559 +00:00,4449.00,true,97
364,2021-10-19 10:47:05.191273 +00:00,2021-10-25 20:04:58.191273 +00:00,3559.00,true,97
365,2024-03-21 19:11:51.141403 +00:00,2024-03-24 12:40:16.141403 +00:00,62.00,true,97
366,2025-08-12 12:48:40.951783 +00:00,2025-08-12 12:53:14.951783 +00:00,2750.00,true,98
367,2025-09-18 03:48:37.570028 +00:00,2025-09-20 10:24:06.570028 +00:00,531.00,true,98
368,2025-08-29 22:56:46.409873 +00:00,2025-09-07 20:33:36.409873 +00:00,2378.00,true,98
369,2025-08-21 13:59:45.354221 +00:00,2025-09-01 07:13:19.354221 +00:00,335.00,true,98
370,2025-09-03 20:16:58.854147 +00:00,2025-09-14 08:43:40.854147 +00:00,112.00,true,98
371,2025-09-10 13:54:36.316607 +00:00,2025-09-13 04:55:36.316607 +00:00,788.00,true,98
372,2017-12-19 04:15:38.770583 +00:00,2017-12-19 04:25:42.770583 +00:00,4381.00,true,99
373,2024-11-09 12:12:04.290287 +00:00,2024-11-16 06:20:53.290287 +00:00,46492.00,true,99
374,2010-11-23 08:53:08.355332 +00:00,2010-11-23 09:06:49.355332 +00:00,16622.00,true,100
375,2021-02-06 12:33:06.569450 +00:00,2021-02-11 09:57:39.569450 +00:00,24820.00,true,100
376,2018-06-10 06:07:09.136713 +00:00,2018-06-10 06:19:47.136713 +00:00,4189.00,true,101
377,2022-05-11 18:33:34.283969 +00:00,2022-05-16 14:37:37.283969 +00:00,6799.00,true,101
378,2012-10-20 04:15:56.296023 +00:00,2012-10-20 04:24:20.296023 +00:00,49709.00,true,102
379,2016-11-24 04:47:36.515013 +00:00,2016-11-24 04:56:59.515013 +00:00,1766.00,true,103
380,2017-01-02 21:53:55.912637 +00:00,2017-01-13 09:03:19.912637 +00:00,3053.00,true,103
381,2018-06-06 21:36:01.409512 +00:00,2018-06-09 20:09:49.409512 +00:00,10637.00,true,103
382,2022-08-23 00:55:43.787654 +00:00,2022-08-30 05:34:36.787654 +00:00,617.00,true,103
383,2018-05-27 12:02:22.232026 +00:00,2018-06-04 07:17:58.232026 +00:00,6947.00,true,103
384,2020-09-15 21:19:41.013015 +00:00,2020-09-15 21:25:08.013015 +00:00,15318.00,true,104
385,2024-11-14 19:03:00.666387 +00:00,2024-11-14 19:13:56.666387 +00:00,8575.00,true,105
386,2018-12-30 06:57:17.824601 +00:00,2018-12-30 07:13:24.824601 +00:00,28313.00,true,106
387,2016-02-24 07:58:27.427950 +00:00,2016-02-24 08:13:56.427950 +00:00,6620.00,true,107
388,2020-01-26 04:53:17.930742 +00:00,2020-02-02 06:31:52.930742 +00:00,36474.00,true,107
389,2012-01-16 16:30:41.344521 +00:00,2012-01-16 16:37:12.344521 +00:00,4677.00,true,108
390,2022-06-07 04:07:59.550523 +00:00,2022-06-17 07:05:25.550523 +00:00,3422.00,true,108
391,2016-12-22 12:47:47.381004 +00:00,2016-12-27 04:39:51.381004 +00:00,726.00,true,108
392,2012-11-27 21:55:25.669443 +00:00,2012-12-05 02:36:09.669443 +00:00,5411.00,true,108
393,2011-10-23 13:25:35.816166 +00:00,2011-10-23 13:34:11.816166 +00:00,4420.00,true,109
394,2017-06-09 04:45:50.340553 +00:00,2017-06-11 02:12:47.340553 +00:00,4335.00,true,109
395,2010-01-03 11:29:43.811241 +00:00,2010-01-03 11:30:27.811241 +00:00,339.00,true,110
396,2025-06-11 22:40:24.530574 +00:00,2025-06-17 04:17:09.530574 +00:00,4982.00,true,110
397,2021-12-04 15:58:28.881297 +00:00,2021-12-12 15:42:03.881297 +00:00,1911.00,true,110
398,2016-12-11 12:37:19.031883 +00:00,2016-12-22 05:21:44.031883 +00:00,2750.00,true,110
399,2020-06-26 22:53:50.758327 +00:00,2020-07-03 04:21:06.758327 +00:00,1655.00,true,110
400,2018-03-21 10:42:04.601815 +00:00,2018-03-21 10:55:19.601815 +00:00,6526.00,true,111
401,2019-11-05 17:24:10.811955 +00:00,2019-11-08 11:48:04.811955 +00:00,8522.00,true,111
402,2025-07-19 15:20:26.290169 +00:00,2025-07-19 15:31:08.290169 +00:00,4140.00,true,112
403,2025-07-29 17:21:14.783785 +00:00,2025-08-09 22:59:02.783785 +00:00,1519.00,true,112
404,2025-08-03 01:53:22.331207 +00:00,2025-08-03 08:28:13.331207 +00:00,1550.00,true,112
405,2025-09-17 04:13:48.217903 +00:00,2025-09-19 08:08:22.217903 +00:00,1594.00,true,112
406,2025-08-13 08:09:59.175050 +00:00,2025-08-17 11:47:52.175050 +00:00,2241.00,true,112
407,2019-07-31 10:53:16.168323 +00:00,2019-07-31 11:03:59.168323 +00:00,8715.00,true,113
408,2025-07-24 02:46:18.965759 +00:00,2025-07-28 02:08:30.965759 +00:00,2384.00,true,113
409,2023-08-01 01:03:51.818862 +00:00,2023-08-10 18:59:43.818862 +00:00,4177.00,true,113
410,2025-09-11 20:03:25.688355 +00:00,2025-09-11 20:16:53.688355 +00:00,988.00,true,114
411,2025-09-16 01:36:49.355488 +00:00,2025-09-21 16:38:33.355488 +00:00,6775.00,true,114
412,2025-09-22 12:12:21.840721 +00:00,2025-10-03 23:45:39.840721 +00:00,1496.00,true,114
413,2025-09-16 12:08:59.345128 +00:00,2025-09-18 19:52:58.345128 +00:00,49648.00,true,114
414,2025-09-30 13:13:29.327056 +00:00,,2025.00,false,114
415,2021-06-14 10:03:33.844590 +00:00,2021-06-14 10:16:08.844590 +00:00,12006.00,true,115
416,2022-06-25 11:29:14.114279 +00:00,2022-06-25 16:06:10.114279 +00:00,7494.00,true,115
417,2020-11-22 15:09:40.808411 +00:00,2020-11-22 15:18:52.808411 +00:00,7296.00,true,116
418,2021-07-14 11:46:44.245066 +00:00,2021-07-21 18:39:26.245066 +00:00,2506.00,true,116
419,2013-07-08 12:52:26.564971 +00:00,2013-07-08 13:02:18.564971 +00:00,22346.00,true,117
420,2020-01-22 05:20:00.819860 +00:00,2020-02-02 00:33:28.819860 +00:00,4495.00,true,117
421,2020-05-06 13:24:43.240556 +00:00,2020-05-06 13:34:21.240556 +00:00,21973.00,true,118
422,2022-02-20 20:13:42.491849 +00:00,2022-02-22 05:51:57.491849 +00:00,8420.00,true,118
423,2016-08-11 22:36:59.081752 +00:00,2016-08-11 22:52:08.081752 +00:00,781.00,true,119
424,2023-02-16 09:30:16.997005 +00:00,2023-02-22 05:43:31.997005 +00:00,830.00,true,119
425,2020-05-14 23:17:36.042376 +00:00,2020-05-18 04:15:15.042376 +00:00,905.00,true,119
426,2020-12-20 21:57:52.597693 +00:00,2020-12-21 23:21:08.597693 +00:00,807.00,true,119
427,2025-05-01 01:13:28.168671 +00:00,2025-05-05 01:33:54.168671 +00:00,1805.00,true,119
428,2011-12-23 07:58:54.439993 +00:00,2011-12-23 08:14:45.439993 +00:00,31130.00,true,120
429,2017-09-06 03:05:58.697015 +00:00,2017-09-14 22:46:20.697015 +00:00,11063.00,true,120
430,2019-09-12 05:13:52.252769 +00:00,2019-09-12 05:14:36.252769 +00:00,28259.00,true,121
431,2014-12-20 22:18:20.859351 +00:00,2014-12-20 22:33:36.859351 +00:00,4710.00,true,122
432,2015-07-06 20:19:16.701761 +00:00,,10370.00,false,122
433,2022-10-11 05:25:42.946205 +00:00,2022-10-11 06:17:28.946205 +00:00,8170.00,true,122
434,2018-12-17 14:03:18.009074 +00:00,2018-12-21 17:27:47.009074 +00:00,18457.00,true,122
435,2025-09-27 04:19:56.575703 +00:00,2025-09-27 04:27:38.575703 +00:00,9696.00,true,123
436,2025-09-30 12:33:17.687445 +00:00,2025-10-03 01:15:24.687445 +00:00,10518.00,true,123
437,2025-10-02 19:16:29.353297 +00:00,2025-10-04 12:14:50.353297 +00:00,2160.00,true,123
438,2025-10-01 14:52:06.894895 +00:00,,712.00,false,123
439,2013-08-02 10:45:39.337233 +00:00,2013-08-02 11:00:14.337233 +00:00,34811.00,true,124
440,2024-09-16 16:11:44.471902 +00:00,2024-09-24 12:17:29.471902 +00:00,21130.00,true,124
441,2025-09-16 19:24:31.316891 +00:00,2025-09-16 19:34:42.316891 +00:00,1208.00,true,125
442,2025-09-30 17:02:44.899013 +00:00,,13773.00,false,125
443,2025-09-29 22:43:50.132089 +00:00,2025-09-29 23:36:19.132089 +00:00,3108.00,true,125
444,2025-09-25 05:04:33.174104 +00:00,2025-09-27 18:41:13.174104 +00:00,9589.00,true,125
445,2025-09-19 05:33:06.850882 +00:00,2025-09-28 22:42:29.850882 +00:00,13253.00,true,125
446,2025-09-28 17:03:57.453709 +00:00,2025-10-02 18:59:54.453709 +00:00,4596.00,true,125
447,2018-05-30 06:58:04.882188 +00:00,2018-05-30 07:11:50.882188 +00:00,629.00,true,126
448,2019-01-23 20:13:18.592100 +00:00,2019-01-31 07:12:27.592100 +00:00,1061.00,true,126
449,2020-09-17 05:20:55.918018 +00:00,2020-09-19 18:04:26.918018 +00:00,631.00,true,126
450,2020-03-11 17:07:03.165398 +00:00,2020-03-22 16:47:35.165398 +00:00,45.00,true,126
451,2021-02-22 12:42:24.078410 +00:00,2021-02-25 11:19:59.078410 +00:00,104.00,true,126
452,2020-09-14 14:50:39.519742 +00:00,2020-09-24 02:57:43.519742 +00:00,1210.00,true,126
453,2025-09-25 22:49:12.486933 +00:00,2025-09-25 22:54:28.486933 +00:00,492.00,true,127
454,2025-09-27 12:21:34.085088 +00:00,,5962.00,false,127
455,2025-09-29 00:43:15.968808 +00:00,2025-09-30 04:17:02.968808 +00:00,2220.00,true,127
456,2025-10-03 12:26:17.883289 +00:00,,2212.00,false,127
457,2025-09-28 07:55:46.209464 +00:00,2025-10-05 19:00:14.209464 +00:00,11696.00,true,127
458,2015-07-30 13:03:57.738642 +00:00,2015-07-30 13:07:13.738642 +00:00,3354.00,true,128
459,2017-10-03 07:36:59.505254 +00:00,2017-10-11 11:10:30.505254 +00:00,5438.00,true,128
460,2024-12-13 07:09:30.257538 +00:00,2024-12-14 11:17:05.257538 +00:00,5186.00,true,128
461,2018-09-12 19:25:05.487694 +00:00,2018-09-21 12:19:19.487694 +00:00,917.00,true,128
462,2020-09-29 07:24:24.351851 +00:00,2020-10-08 19:59:42.351851 +00:00,3584.00,true,128
463,2012-12-05 10:52:10.412035 +00:00,2012-12-05 11:07:08.412035 +00:00,5323.00,true,129
464,2022-11-26 13:54:33.177265 +00:00,2022-12-04 21:18:08.177265 +00:00,12914.00,true,129
465,2014-09-14 11:53:04.277132 +00:00,2014-09-19 10:33:29.277132 +00:00,14319.00,true,129
466,2017-05-22 12:00:06.702334 +00:00,2017-05-30 12:30:50.702334 +00:00,3187.00,true,129
467,2017-04-15 20:50:18.429883 +00:00,2017-04-26 13:08:31.429883 +00:00,6430.00,true,129
468,2025-08-28 17:31:52.059117 +00:00,2025-08-28 17:32:28.059117 +00:00,25467.00,true,130
469,2025-09-28 14:08:12.634952 +00:00,2025-09-28 16:07:37.634952 +00:00,24217.00,true,130
470,2019-08-13 23:16:41.986010 +00:00,2019-08-13 23:30:42.986010 +00:00,6436.00,true,131
471,2023-12-26 12:16:51.276518 +00:00,2023-12-27 09:15:35.276518 +00:00,1284.00,true,131
472,2023-12-01 05:18:57.039773 +00:00,2023-12-01 05:22:57.039773 +00:00,984.00,true,132
473,2023-12-31 18:17:03.992218 +00:00,2024-01-04 19:02:41.992218 +00:00,13150.00,true,132
474,2018-07-17 05:57:18.344809 +00:00,2018-07-17 06:09:35.344809 +00:00,2813.00,true,133
475,2025-04-07 09:19:58.695385 +00:00,2025-04-14 17:46:54.695385 +00:00,8939.00,true,133
476,2023-02-09 07:59:01.385480 +00:00,2023-02-15 08:25:34.385480 +00:00,5485.00,true,133
477,2019-08-26 02:41:08.108810 +00:00,2019-08-26 13:56:15.108810 +00:00,16900.00,true,133
478,2022-03-14 07:42:40.546882 +00:00,2022-03-19 22:48:22.546882 +00:00,3554.00,true,133
479,2025-09-15 14:20:22.215634 +00:00,2025-09-25 08:08:16.215634 +00:00,407.00,true,133
480,2020-05-25 01:30:24.607268 +00:00,2020-05-25 01:37:39.607268 +00:00,614.00,true,134
481,2025-09-25 05:20:29.908080 +00:00,2025-09-26 22:10:29.908080 +00:00,309.00,true,134
482,2022-05-18 15:01:10.260145 +00:00,2022-05-21 15:44:46.260145 +00:00,9840.00,true,134
483,2022-10-06 00:35:16.058411 +00:00,2022-10-14 21:56:23.058411 +00:00,5113.00,true,134
484,2024-10-10 14:51:43.920342 +00:00,2024-10-11 11:54:19.920342 +00:00,1869.00,true,134
485,2011-01-30 18:48:13.489437 +00:00,2011-01-30 19:02:02.489437 +00:00,16827.00,true,135
486,2016-11-10 13:45:43.358000 +00:00,2016-11-12 05:49:44.358000 +00:00,19784.00,true,135
487,2024-04-19 15:41:10.956539 +00:00,2024-04-21 07:49:29.956539 +00:00,4488.00,true,135
488,2018-01-22 10:05:43.804802 +00:00,2018-01-26 22:52:55.804802 +00:00,1564.00,true,135
489,2014-12-02 23:51:25.059506 +00:00,2014-12-03 00:06:22.059506 +00:00,17273.00,true,136
490,2017-12-08 05:52:42.390490 +00:00,2017-12-16 15:53:53.390490 +00:00,5811.00,true,136
491,2025-07-12 02:59:21.103422 +00:00,2025-07-17 04:39:25.103422 +00:00,4509.00,true,136
492,2017-05-12 17:50:13.765083 +00:00,2017-05-15 03:52:26.765083 +00:00,17782.00,true,136
493,2016-07-19 00:35:45.772776 +00:00,2016-07-22 12:05:54.772776 +00:00,968.00,true,136
494,2017-01-03 13:52:25.429632 +00:00,2017-01-03 13:58:22.429632 +00:00,14495.00,true,137
495,2025-09-09 15:57:24.140559 +00:00,2025-09-17 00:02:23.140559 +00:00,274.00,true,137
496,2019-05-08 02:00:42.855976 +00:00,2019-05-15 00:50:17.855976 +00:00,4457.00,true,137
497,2019-03-24 05:05:31.619502 +00:00,2019-03-31 15:42:56.619502 +00:00,1259.00,true,137
498,2020-03-14 22:08:37.678547 +00:00,2020-03-24 13:17:29.678547 +00:00,3332.00,true,137
499,2014-07-10 06:13:46.376799 +00:00,2014-07-10 06:27:28.376799 +00:00,12586.00,true,138
500,2015-10-15 09:07:33.368119 +00:00,2015-10-24 06:31:16.368119 +00:00,13474.00,true,138
501,2018-12-24 04:37:59.464693 +00:00,2019-01-02 18:04:58.464693 +00:00,2757.00,true,138
502,2015-11-09 06:29:48.548544 +00:00,,3296.00,false,138
503,2023-09-03 09:36:06.921959 +00:00,2023-09-05 12:47:24.921959 +00:00,8175.00,true,138
504,2025-02-07 09:02:12.461663 +00:00,2025-02-15 07:40:25.461663 +00:00,939.00,true,138
505,2024-09-22 19:18:31.199824 +00:00,2024-09-22 19:27:58.199824 +00:00,34919.00,true,139
506,2025-10-03 19:32:37.100264 +00:00,2025-10-04 10:10:06.100264 +00:00,3135.00,true,139
507,2012-08-02 13:17:43.313757 +00:00,2012-08-02 13:31:24.313757 +00:00,927.00,true,140
508,2014-10-06 20:00:51.726103 +00:00,2014-10-10 05:22:04.726103 +00:00,25861.00,true,140
509,2019-09-07 10:19:32.332142 +00:00,2019-09-07 10:23:15.332142 +00:00,12367.00,true,141
510,2022-04-16 16:01:58.597292 +00:00,2022-04-25 09:43:26.597292 +00:00,588.00,true,141
511,2020-04-08 06:42:39.170784 +00:00,2020-04-09 13:44:28.170784 +00:00,7256.00,true,141
512,2025-07-13 08:01:28.629146 +00:00,2025-07-22 23:47:17.629146 +00:00,18451.00,true,141
513,2015-07-09 02:59:55.078885 +00:00,2015-07-09 03:05:58.078885 +00:00,3977.00,true,142
514,2015-10-05 18:54:57.815313 +00:00,2015-10-10 02:26:55.815313 +00:00,23.00,true,142
515,2018-08-24 00:52:19.435078 +00:00,2018-08-28 17:55:40.435078 +00:00,8328.00,true,142
516,2021-05-15 14:20:33.932700 +00:00,2021-05-16 05:58:31.932700 +00:00,2861.00,true,142
517,2017-11-11 08:03:06.035411 +00:00,2017-11-22 10:04:15.035411 +00:00,3851.00,true,142
518,2025-08-04 08:00:00.355513 +00:00,2025-08-04 08:07:49.355513 +00:00,29529.00,true,143
519,2020-10-28 01:13:00.999639 +00:00,2020-10-28 01:18:32.999639 +00:00,5696.00,true,144
520,2022-09-15 06:29:42.515191 +00:00,2022-09-21 19:35:41.515191 +00:00,2660.00,true,144
521,2020-08-23 20:59:11.359447 +00:00,2020-08-23 21:05:31.359447 +00:00,49598.00,true,145
522,2021-04-10 05:31:36.389163 +00:00,2021-04-16 14:40:50.389163 +00:00,9923.00,true,145
523,2025-04-03 01:57:58.796939 +00:00,2025-04-03 02:00:32.796939 +00:00,15170.00,true,146
524,2025-07-29 05:53:32.799003 +00:00,2025-08-04 11:20:10.799003 +00:00,5042.00,true,146
525,2025-10-01 10:44:35.897196 +00:00,2025-10-04 20:57:20.897196 +00:00,14222.00,true,146
526,2017-08-09 18:46:10.678174 +00:00,2017-08-09 19:00:55.678174 +00:00,25.00,true,147
527,2019-07-06 19:48:16.068507 +00:00,2019-07-12 21:37:03.068507 +00:00,121.00,true,147
528,2017-09-18 18:27:06.309718 +00:00,2017-09-26 03:56:09.309718 +00:00,231.00,true,147
529,2024-03-14 17:15:17.769911 +00:00,2024-03-19 14:07:13.769911 +00:00,543.00,true,147
530,2024-05-11 13:23:19.539647 +00:00,2024-05-17 11:11:19.539647 +00:00,444.00,true,147
531,2022-06-18 13:50:38.449821 +00:00,2022-06-18 22:20:48.449821 +00:00,684.00,true,147
532,2012-01-04 05:08:01.339551 +00:00,2012-01-04 05:18:22.339551 +00:00,18.00,true,148
533,2017-10-18 12:27:48.370200 +00:00,2017-10-20 14:26:19.370200 +00:00,464.00,true,148
534,2023-12-01 11:42:24.753383 +00:00,2023-12-02 17:57:52.753383 +00:00,263.00,true,148
535,2019-06-12 03:28:47.740141 +00:00,2019-06-21 23:40:53.740141 +00:00,513.00,true,148
536,2025-03-30 23:14:04.005200 +00:00,2025-04-03 17:53:02.005200 +00:00,47.00,true,148
537,2014-04-04 16:22:22.708127 +00:00,2014-04-04 16:35:39.708127 +00:00,15786.00,true,149
538,2022-07-17 19:17:49.503239 +00:00,2022-07-19 23:18:00.503239 +00:00,19863.00,true,149
539,2024-07-11 12:48:30.115851 +00:00,2024-07-13 16:47:54.115851 +00:00,19201.00,true,149
540,2011-11-30 16:32:07.980565 +00:00,2011-11-30 16:35:34.980565 +00:00,7939.00,true,150
541,2022-09-03 20:47:41.520066 +00:00,2022-09-04 11:49:16.520066 +00:00,4373.00,true,150
542,2017-11-05 22:18:27.209252 +00:00,2017-11-13 20:37:20.209252 +00:00,25742.00,true,150
543,2019-01-26 14:55:25.659044 +00:00,,14499.00,false,150
544,2020-12-02 17:02:51.135347 +00:00,2020-12-14 03:31:34.135347 +00:00,13739.00,true,150
545,2021-05-09 02:20:51.448546 +00:00,2021-05-13 11:59:28.448546 +00:00,1936.00,true,150
546,2024-05-11 12:04:59.397769 +00:00,2024-05-11 12:17:58.397769 +00:00,10931.00,true,151
547,2024-05-25 04:17:13.456175 +00:00,2024-06-04 04:17:31.456175 +00:00,10946.00,true,151
548,2025-04-24 08:05:47.836688 +00:00,2025-04-24 10:49:27.836688 +00:00,18316.00,true,151
549,2018-04-13 18:04:03.456149 +00:00,2018-04-13 18:08:00.456149 +00:00,165.00,true,152
550,2024-11-28 05:50:19.265909 +00:00,2024-12-03 17:40:56.265909 +00:00,10320.00,true,152
551,2018-08-23 07:48:27.632750 +00:00,2018-09-03 00:44:39.632750 +00:00,11900.00,true,152
552,2020-07-27 09:03:10.454802 +00:00,2020-07-27 09:15:24.454802 +00:00,16142.00,true,153
553,2023-05-24 23:21:34.721097 +00:00,2023-06-04 08:24:35.721097 +00:00,10866.00,true,153
554,2020-10-26 09:23:13.027864 +00:00,2020-10-27 19:22:29.027864 +00:00,6240.00,true,153
555,2024-08-08 17:27:14.775854 +00:00,2024-08-13 15:48:45.775854 +00:00,5243.00,true,153
556,2023-01-13 09:30:24.668461 +00:00,2023-01-18 02:06:40.668461 +00:00,8953.00,true,153
557,2024-11-01 14:00:14.812985 +00:00,2024-11-01 15:06:47.812985 +00:00,1274.00,true,153
558,2012-03-16 00:08:55.906843 +00:00,2012-03-16 00:22:15.906843 +00:00,25762.00,true,154
559,2019-12-12 16:18:14.077914 +00:00,2019-12-14 22:51:30.077914 +00:00,13509.00,true,154
560,2025-09-11 07:56:24.249846 +00:00,2025-09-11 08:12:54.249846 +00:00,3597.00,true,155
561,2025-09-19 06:04:16.398957 +00:00,2025-09-25 02:40:11.398957 +00:00,3301.00,true,155
562,2025-09-19 17:42:16.536276 +00:00,2025-09-22 23:48:07.536276 +00:00,4670.00,true,155
563,2014-08-05 00:25:14.451008 +00:00,2014-08-05 00:36:29.451008 +00:00,19503.00,true,156
564,2020-01-08 10:36:47.749705 +00:00,2020-01-08 12:34:14.749705 +00:00,10814.00,true,156
565,2024-04-14 08:15:26.697328 +00:00,2024-04-21 00:22:06.697328 +00:00,633.00,true,156
566,2018-08-23 22:14:25.315739 +00:00,2018-08-30 19:00:40.315739 +00:00,1530.00,true,156
567,2025-09-08 18:33:23.334278 +00:00,2025-09-08 18:41:19.334278 +00:00,1877.00,true,157
568,2025-10-04 13:25:39.092211 +00:00,,5474.00,false,157
569,2025-09-14 09:14:13.514863 +00:00,2025-09-21 01:59:39.514863 +00:00,7421.00,true,157
570,2025-09-22 17:22:06.111001 +00:00,2025-09-23 01:42:50.111001 +00:00,2439.00,true,157
571,2025-10-04 15:07:14.827492 +00:00,,570.00,false,157
572,2025-09-12 16:39:54.048887 +00:00,2025-09-21 18:10:35.048887 +00:00,10200.00,true,157
573,2025-08-09 03:24:19.870736 +00:00,2025-08-09 03:27:28.870736 +00:00,15812.00,true,158
574,2025-08-19 11:11:42.165751 +00:00,2025-08-30 11:20:07.165751 +00:00,32779.00,true,158
575,2017-01-16 16:38:35.963381 +00:00,2017-01-16 16:42:28.963381 +00:00,4696.00,true,159
576,2019-06-14 11:45:51.778597 +00:00,2019-06-16 18:14:12.778597 +00:00,3318.00,true,159
577,2020-11-06 20:11:28.771435 +00:00,2020-11-07 18:58:30.771435 +00:00,1991.00,true,159
578,2025-03-25 12:40:44.823174 +00:00,2025-03-27 16:27:05.823174 +00:00,53.00,true,159
579,2024-07-03 16:24:52.319003 +00:00,,1996.00,false,159
580,2023-12-14 06:00:48.400360 +00:00,2023-12-16 03:51:39.400360 +00:00,310.00,true,159
581,2013-10-20 10:16:40.931464 +00:00,2013-10-20 10:23:01.931464 +00:00,7625.00,true,160
582,2021-10-02 03:16:54.430145 +00:00,2021-10-03 02:48:40.430145 +00:00,3354.00,true,160
583,2024-12-10 16:14:49.350662 +00:00,,224.00,false,160
584,2016-10-17 09:31:53.568657 +00:00,2016-10-22 02:22:15.568657 +00:00,16482.00,true,160
585,2025-09-12 06:24:04.900141 +00:00,2025-09-12 06:40:10.900141 +00:00,11342.00,true,161
586,2025-10-03 13:23:48.105461 +00:00,,1564.00,false,161
587,2025-09-26 08:02:44.225430 +00:00,2025-10-02 23:33:14.225430 +00:00,5738.00,true,161
588,2025-08-07 21:26:26.349051 +00:00,2025-08-07 21:40:48.349051 +00:00,18596.00,true,162
589,2025-09-17 22:50:33.052435 +00:00,2025-09-22 22:34:27.052435 +00:00,20692.00,true,162
590,2025-09-20 00:48:16.146537 +00:00,2025-09-30 05:33:30.146537 +00:00,126.00,true,162
591,2025-09-28 06:21:57.713173 +00:00,,3120.00,false,162
592,2025-08-20 12:52:15.688699 +00:00,2025-08-29 11:33:00.688699 +00:00,9894.00,true,162
593,2024-11-01 22:35:56.767194 +00:00,2024-11-01 22:37:46.767194 +00:00,7959.00,true,163
594,2025-09-15 03:47:50.831655 +00:00,2025-09-18 11:48:04.831655 +00:00,697.00,true,163
595,2024-11-19 08:30:55.611877 +00:00,2024-11-28 21:36:06.611877 +00:00,74.00,true,163
596,2021-04-11 12:12:23.071917 +00:00,2021-04-11 12:20:55.071917 +00:00,32.00,true,164
597,2024-11-12 10:41:20.130715 +00:00,2024-11-23 11:14:12.130715 +00:00,881.00,true,164
598,2024-02-02 02:00:11.865243 +00:00,2024-02-07 15:34:01.865243 +00:00,125.00,true,164
599,2021-08-04 08:35:57.708719 +00:00,2021-08-05 08:59:32.708719 +00:00,2749.00,true,164
600,2022-08-30 01:16:13.079081 +00:00,2022-09-08 06:36:33.079081 +00:00,49.00,true,164
601,2025-07-15 04:04:37.536565 +00:00,,47.00,false,164
602,2015-06-20 06:05:52.580025 +00:00,2015-06-20 06:13:50.580025 +00:00,4563.00,true,165
603,2017-01-26 03:47:13.101146 +00:00,2017-02-03 15:58:33.101146 +00:00,924.00,true,165
604,2018-06-25 08:17:44.978202 +00:00,,334.00,false,165
605,2024-06-21 00:59:52.516524 +00:00,2024-06-28 17:55:24.516524 +00:00,229.00,true,165
606,2021-06-29 05:28:02.636843 +00:00,2021-07-01 05:54:49.636843 +00:00,2693.00,true,165
607,2025-06-04 05:15:00.137428 +00:00,2025-06-04 05:19:53.137428 +00:00,42902.00,true,166
608,2020-09-20 08:14:01.816367 +00:00,2020-09-20 08:30:15.816367 +00:00,70560.00,true,167
609,2013-07-27 02:45:48.693446 +00:00,2013-07-27 02:53:49.693446 +00:00,34301.00,true,168
610,2021-11-20 06:18:26.763441 +00:00,2021-11-29 15:40:16.763441 +00:00,1150.00,true,168
611,2019-04-23 14:03:21.638457 +00:00,2019-05-02 22:42:03.638457 +00:00,17600.00,true,168
612,2016-03-24 11:31:11.459991 +00:00,2016-04-02 09:20:28.459991 +00:00,2577.00,true,168
613,2025-08-07 10:03:34.769839 +00:00,2025-08-07 10:12:39.769839 +00:00,47435.00,true,169
614,2012-02-20 01:10:50.508632 +00:00,2012-02-20 01:21:55.508632 +00:00,14204.00,true,170
615,2017-10-04 00:42:23.129267 +00:00,2017-10-04 00:56:53.129267 +00:00,19326.00,true,171
616,2023-05-19 02:47:09.740899 +00:00,2023-05-27 09:53:22.740899 +00:00,10749.00,true,171
617,2015-02-19 04:38:16.889800 +00:00,2015-02-19 04:49:59.889800 +00:00,5576.00,true,172
618,2018-05-06 15:31:46.219528 +00:00,2018-05-16 03:12:08.219528 +00:00,954.00,true,172
619,2023-07-16 15:57:23.068729 +00:00,2023-07-22 04:51:32.068729 +00:00,249.00,true,172
620,2019-11-24 18:24:17.480840 +00:00,2019-12-03 23:16:02.480840 +00:00,1157.00,true,172
621,2025-09-02 15:32:16.958911 +00:00,2025-09-02 15:43:00.958911 +00:00,3091.00,true,173
622,2025-09-27 10:15:56.075429 +00:00,2025-10-02 17:02:58.075429 +00:00,3362.00,true,173
623,2025-10-02 20:11:37.117357 +00:00,2025-10-06 03:24:38.117357 +00:00,1409.00,true,173
624,2025-09-21 08:40:39.797562 +00:00,2025-09-30 02:35:00.797562 +00:00,5787.00,true,173
625,2025-09-06 02:02:29.257700 +00:00,2025-09-10 03:12:04.257700 +00:00,6024.00,true,173
626,2025-09-28 11:30:33.256157 +00:00,2025-09-29 21:53:11.256157 +00:00,25871.00,true,173
627,2016-05-15 02:53:22.945987 +00:00,2016-05-15 02:54:34.945987 +00:00,38371.00,true,174
628,2017-04-30 22:35:53.046703 +00:00,2017-04-30 22:44:42.046703 +00:00,2620.00,true,175
629,2018-01-21 13:59:52.386865 +00:00,2018-02-01 19:11:10.386865 +00:00,3604.00,true,175
630,2024-09-17 06:35:25.182276 +00:00,2024-09-24 14:43:24.182276 +00:00,1688.00,true,175
631,2019-06-08 18:47:10.754048 +00:00,2019-06-19 03:44:07.754048 +00:00,2328.00,true,175
632,2021-10-24 01:58:09.395849 +00:00,2021-10-30 15:39:08.395849 +00:00,3162.00,true,175
633,2021-07-05 02:04:33.625890 +00:00,2021-07-13 10:53:56.625890 +00:00,4099.00,true,175
634,2013-06-23 20:02:18.249099 +00:00,2013-06-23 20:06:26.249099 +00:00,3937.00,true,176
635,2013-06-25 10:33:04.691200 +00:00,2013-07-06 18:58:46.691200 +00:00,8087.00,true,176
636,2022-12-08 08:50:24.364588 +00:00,2022-12-10 05:21:46.364588 +00:00,7838.00,true,176
637,2023-12-19 02:49:04.170566 +00:00,2023-12-25 07:05:54.170566 +00:00,10173.00,true,176
638,2021-12-18 18:56:31.549139 +00:00,2021-12-26 11:37:10.549139 +00:00,1122.00,true,176
639,2019-07-12 19:37:53.998935 +00:00,2019-07-17 02:35:05.998935 +00:00,671.00,true,176
640,2014-11-03 16:24:49.803038 +00:00,2014-11-03 16:38:59.803038 +00:00,14744.00,true,177
641,2015-07-14 04:32:58.518937 +00:00,2015-07-21 01:52:05.518937 +00:00,2365.00,true,177
642,2016-11-30 00:00:54.786747 +00:00,2016-12-06 01:33:38.786747 +00:00,1377.00,true,177
643,2024-04-21 12:24:48.889726 +00:00,2024-04-27 16:49:04.889726 +00:00,4060.00,true,177
644,2016-04-16 00:19:14.956474 +00:00,2016-04-17 10:23:26.956474 +00:00,1848.00,true,177
645,2025-09-07 01:34:10.429149 +00:00,2025-09-07 01:48:10.429149 +00:00,31522.00,true,178
646,2025-09-24 14:02:06.263078 +00:00,2025-10-05 23:48:24.263078 +00:00,2993.00,true,178
647,2025-09-30 15:11:52.878379 +00:00,,4199.00,false,178
648,2025-09-27 00:20:05.396624 +00:00,2025-10-04 23:42:59.396624 +00:00,2632.00,true,178
649,2025-09-07 21:20:23.619629 +00:00,2025-09-10 05:39:18.619629 +00:00,7084.00,true,178
650,2025-10-04 19:49:28.534034 +00:00,,8777.00,false,178
651,2015-10-19 07:04:00.540830 +00:00,2015-10-19 07:08:12.540830 +00:00,12906.00,true,179
652,2020-02-26 22:39:24.143797 +00:00,2020-03-02 07:45:25.143797 +00:00,983.00,true,179
653,2020-10-30 04:58:12.056209 +00:00,2020-11-07 07:33:01.056209 +00:00,3945.00,true,179
654,2018-04-23 19:37:04.183106 +00:00,2018-04-29 09:54:13.183106 +00:00,1338.00,true,179
655,2016-04-29 10:40:08.150313 +00:00,2016-05-01 20:06:12.150313 +00:00,163.00,true,179
656,2017-09-03 11:51:40.353217 +00:00,2017-09-10 06:37:51.353217 +00:00,2933.00,true,179
657,2017-07-24 15:19:50.160906 +00:00,2017-07-24 15:20:18.160906 +00:00,1753.00,true,180
658,2024-01-23 12:25:12.751377 +00:00,2024-01-27 23:20:36.751377 +00:00,34503.00,true,180
659,2016-02-18 16:05:48.666127 +00:00,2016-02-18 16:15:11.666127 +00:00,7397.00,true,181
660,2020-11-07 05:32:16.714607 +00:00,2020-11-17 12:57:15.714607 +00:00,1471.00,true,181
661,2019-01-05 12:08:04.605974 +00:00,2019-01-16 17:09:59.605974 +00:00,6675.00,true,181
662,2025-07-25 04:54:26.250421 +00:00,2025-08-02 09:05:30.250421 +00:00,2825.00,true,181
663,2021-05-29 23:30:34.664489 +00:00,2021-06-10 08:59:05.664489 +00:00,5606.00,true,181
664,2019-07-11 15:27:54.774310 +00:00,2019-07-21 05:21:31.774310 +00:00,11213.00,true,181
665,2025-07-22 01:38:26.890764 +00:00,2025-07-22 01:41:47.890764 +00:00,4315.00,true,182
666,2025-08-08 01:07:22.007146 +00:00,2025-08-11 23:51:07.007146 +00:00,9465.00,true,182
667,2025-09-22 19:57:08.324751 +00:00,2025-09-26 23:44:36.324751 +00:00,3204.00,true,182
668,2025-08-30 17:27:24.320665 +00:00,2025-09-06 08:29:17.320665 +00:00,2524.00,true,182
669,2025-10-01 19:31:01.163373 +00:00,,2750.00,false,182
670,2020-11-25 07:44:40.368980 +00:00,2020-11-25 07:58:51.368980 +00:00,65338.00,true,183
671,2020-07-13 20:04:31.110679 +00:00,2020-07-13 20:19:59.110679 +00:00,5185.00,true,184
672,2022-04-27 18:03:29.300713 +00:00,2022-05-07 12:34:22.300713 +00:00,4681.00,true,184
673,2020-07-31 15:51:02.641644 +00:00,2020-08-07 14:50:04.641644 +00:00,506.00,true,184
674,2017-01-28 12:42:10.637002 +00:00,2017-01-28 12:53:10.637002 +00:00,29092.00,true,185
675,2023-05-28 11:35:58.810697 +00:00,2023-06-05 03:07:13.810697 +00:00,1283.00,true,185
676,2019-09-06 00:33:52.709637 +00:00,2019-09-12 19:44:22.709637 +00:00,16416.00,true,185
677,2024-11-28 14:55:06.883552 +00:00,2024-12-07 07:10:30.883552 +00:00,9873.00,true,185
678,2023-03-04 12:23:12.453699 +00:00,2023-03-04 12:30:48.453699 +00:00,11504.00,true,186
679,2023-03-21 09:00:14.048415 +00:00,2023-03-24 03:06:19.048415 +00:00,5167.00,true,186
680,2024-10-10 19:05:40.105319 +00:00,2024-10-21 19:05:16.105319 +00:00,3324.00,true,186
681,2025-08-19 00:48:33.144833 +00:00,2025-08-28 07:32:56.144833 +00:00,2693.00,true,186
682,2023-08-04 05:35:38.995641 +00:00,2023-08-04 05:44:07.995641 +00:00,1747.00,true,187
683,2025-05-27 05:21:15.895590 +00:00,2025-05-30 19:53:21.895590 +00:00,52617.00,true,187
684,2024-09-20 04:09:52.414513 +00:00,,1789.00,false,187
685,2023-09-24 12:44:00.661503 +00:00,2023-09-27 07:45:52.661503 +00:00,3450.00,true,187
686,2025-09-27 20:21:24.316082 +00:00,2025-09-27 20:31:25.316082 +00:00,2923.00,true,188
687,2025-10-02 05:21:37.932617 +00:00,,11.00,false,188
688,2025-10-01 17:59:25.774943 +00:00,,1070.00,false,188
689,2025-09-30 12:30:25.453979 +00:00,2025-10-04 10:38:23.453979 +00:00,2006.00,true,188
690,2018-08-10 10:37:55.098427 +00:00,2018-08-10 10:40:07.098427 +00:00,8514.00,true,189
691,2021-02-12 20:24:53.909539 +00:00,2021-02-23 16:02:04.909539 +00:00,5728.00,true,189
692,2025-08-04 09:36:43.327404 +00:00,2025-08-04 09:49:47.327404 +00:00,453.00,true,190
693,2025-09-24 02:05:13.915657 +00:00,2025-09-29 09:52:31.915657 +00:00,903.00,true,190
694,2025-08-19 11:46:54.045955 +00:00,2025-08-19 13:21:26.045955 +00:00,735.00,true,190
695,2025-09-30 22:51:47.596186 +00:00,,484.00,false,190
696,2025-08-10 10:04:15.522546 +00:00,2025-08-18 23:20:50.522546 +00:00,11336.00,true,190
697,2025-08-20 11:25:39.319785 +00:00,2025-08-26 03:45:50.319785 +00:00,6621.00,true,190
698,2020-03-19 15:19:08.216841 +00:00,2020-03-19 15:32:24.216841 +00:00,10920.00,true,191
699,2023-05-02 02:59:20.200149 +00:00,2023-05-08 16:06:05.200149 +00:00,3813.00,true,191
700,2021-10-26 19:40:15.608102 +00:00,2021-10-26 19:56:46.608102 +00:00,43122.00,true,192
701,2023-08-09 03:39:41.450099 +00:00,2023-08-14 10:37:21.450099 +00:00,4705.00,true,192
702,2018-12-19 12:04:58.944834 +00:00,2018-12-19 12:17:31.944834 +00:00,4310.00,true,193
703,2022-02-07 11:05:39.626982 +00:00,2022-02-12 16:07:28.626982 +00:00,1738.00,true,193
704,2024-10-28 14:50:40.595767 +00:00,2024-11-01 07:22:50.595767 +00:00,13593.00,true,193
705,2019-11-23 14:28:03.058081 +00:00,2019-12-04 15:57:16.058081 +00:00,3826.00,true,193
706,2014-09-19 19:48:06.718694 +00:00,2014-09-19 19:58:00.718694 +00:00,524.00,true,194
707,2023-11-22 20:25:26.648783 +00:00,2023-11-28 06:00:41.648783 +00:00,39.00,true,194
708,2019-01-10 13:44:30.364529 +00:00,2019-01-12 03:48:21.364529 +00:00,2114.00,true,194
709,2025-09-08 18:12:13.669466 +00:00,2025-09-16 12:51:14.669466 +00:00,6511.00,true,194
710,2018-10-22 05:16:57.592283 +00:00,2018-11-02 07:21:34.592283 +00:00,776.00,true,194
711,2013-11-05 23:11:30.755848 +00:00,2013-11-05 23:26:44.755848 +00:00,42809.00,true,195
712,2019-11-18 07:12:55.076424 +00:00,2019-11-27 01:04:08.076424 +00:00,24440.00,true,195
713,2020-09-19 13:49:38.471745 +00:00,2020-09-19 13:51:10.471745 +00:00,2170.00,true,196
714,2025-09-20 16:26:10.953022 +00:00,2025-09-28 21:35:20.953022 +00:00,1743.00,true,196
715,2023-03-12 09:40:47.702785 +00:00,2023-03-21 05:15:16.702785 +00:00,2929.00,true,196
716,2023-10-18 11:41:08.996285 +00:00,2023-10-26 01:02:56.996285 +00:00,1414.00,true,196
717,2025-03-01 19:32:19.234101 +00:00,2025-03-12 14:56:46.234101 +00:00,230.00,true,196
718,2022-09-01 14:30:11.075717 +00:00,2022-09-05 11:27:04.075717 +00:00,1608.00,true,196
719,2018-06-25 05:34:47.859510 +00:00,2018-06-25 05:44:01.859510 +00:00,18481.00,true,197
720,2021-07-18 12:28:58.938488 +00:00,2021-07-21 02:51:10.938488 +00:00,305.00,true,197
721,2022-09-15 16:03:57.927088 +00:00,2022-09-21 08:45:10.927088 +00:00,166.00,true,197
722,2021-03-10 12:51:01.435754 +00:00,2021-03-17 14:38:47.435754 +00:00,2463.00,true,197
723,2019-01-18 00:28:46.775239 +00:00,2019-01-29 07:03:43.775239 +00:00,5567.00,true,197
724,2020-12-09 14:02:26.922596 +00:00,2020-12-19 04:53:51.922596 +00:00,6257.00,true,197
725,2025-09-19 06:35:52.370318 +00:00,2025-09-19 06:47:30.370318 +00:00,8795.00,true,198
726,2025-09-30 10:32:01.599324 +00:00,,1420.00,false,198
727,2016-11-16 01:21:42.800530 +00:00,2016-11-16 01:30:06.800530 +00:00,49789.00,true,199
728,2025-07-03 10:30:09.664894 +00:00,2025-07-03 10:37:00.664894 +00:00,526.00,true,200
729,2025-08-29 06:16:43.883375 +00:00,2025-09-02 02:51:14.883375 +00:00,7811.00,true,200
730,2025-07-06 12:51:20.332444 +00:00,2025-07-16 22:17:48.332444 +00:00,5692.00,true,200
731,2025-08-16 10:16:35.418056 +00:00,2025-08-16 15:12:38.418056 +00:00,4106.00,true,200
732,2025-08-06 08:55:56.708228 +00:00,2025-08-14 03:34:39.708228 +00:00,1919.00,true,200
733,2025-08-31 15:03:28.791845 +00:00,2025-09-08 15:20:17.791845 +00:00,6126.00,true,200
734,2025-07-11 11:31:15.870845 +00:00,2025-07-11 11:31:20.870845 +00:00,17048.00,true,201
735,2025-07-20 06:53:35.177533 +00:00,2025-07-24 23:43:46.177533 +00:00,4135.00,true,201
736,2025-10-01 22:02:14.171971 +00:00,2025-10-05 15:49:48.171971 +00:00,23679.00,true,201
737,2025-08-11 11:20:05.564201 +00:00,2025-08-20 11:29:35.564201 +00:00,8999.00,true,201
738,2016-08-30 04:16:16.945926 +00:00,2016-08-30 04:27:12.945926 +00:00,5627.00,true,202
739,2017-11-20 02:48:00.555209 +00:00,2017-11-30 23:24:02.555209 +00:00,23152.00,true,202
740,2016-07-11 19:30:55.270797 +00:00,2016-07-11 19:32:13.270797 +00:00,10160.00,true,203
741,2020-04-26 15:56:28.668680 +00:00,2020-05-07 13:36:29.668680 +00:00,12748.00,true,203
742,2016-10-14 00:18:00.424039 +00:00,,1618.00,false,203
743,2024-03-25 19:40:58.420918 +00:00,2024-04-04 00:23:12.420918 +00:00,500.00,true,203
744,2025-08-19 22:30:37.525903 +00:00,2025-08-19 22:42:53.525903 +00:00,6939.00,true,204
745,2025-08-22 14:01:21.176728 +00:00,2025-08-27 02:02:59.176728 +00:00,16541.00,true,204
746,2025-09-03 04:46:27.214665 +00:00,2025-09-08 01:22:33.214665 +00:00,991.00,true,204
747,2025-09-18 15:09:26.161265 +00:00,2025-09-30 00:28:36.161265 +00:00,10289.00,true,204
748,2020-07-09 22:15:39.686388 +00:00,2020-07-09 22:29:16.686388 +00:00,16289.00,true,205
749,2019-11-17 13:27:17.414509 +00:00,2019-11-17 13:42:55.414509 +00:00,28475.00,true,206
750,2017-09-21 16:01:53.613542 +00:00,2017-09-21 16:07:40.613542 +00:00,483.00,true,207
751,2023-10-20 05:54:09.466526 +00:00,2023-10-24 10:46:58.466526 +00:00,1017.00,true,207
752,2018-04-29 04:37:43.962745 +00:00,2018-05-04 19:18:40.962745 +00:00,1095.00,true,207
753,2019-11-12 07:29:30.357699 +00:00,2019-11-20 17:44:55.357699 +00:00,359.00,true,207
754,2018-08-08 13:03:30.828083 +00:00,2018-08-17 23:11:11.828083 +00:00,1311.00,true,207
755,2022-12-14 15:38:05.616302 +00:00,2022-12-14 15:51:30.616302 +00:00,14585.00,true,208
756,2023-09-04 15:47:53.865591 +00:00,2023-09-12 19:55:39.865591 +00:00,5603.00,true,208
757,2025-04-21 19:37:29.956369 +00:00,2025-04-24 05:52:07.956369 +00:00,11728.00,true,208
758,2025-04-19 05:03:59.806975 +00:00,2025-04-20 14:07:55.806975 +00:00,1452.00,true,208
759,2017-10-12 10:53:06.834555 +00:00,2017-10-12 10:54:35.834555 +00:00,8813.00,true,209
760,2017-10-15 15:25:38.968431 +00:00,2017-10-16 01:11:29.968431 +00:00,32664.00,true,209
761,2025-08-24 05:42:50.627701 +00:00,2025-08-24 05:51:49.627701 +00:00,4767.00,true,210
762,2025-09-23 04:43:24.882644 +00:00,2025-09-23 12:59:10.882644 +00:00,2235.00,true,210
763,2025-09-06 20:56:28.726752 +00:00,2025-09-10 15:08:12.726752 +00:00,150.00,true,210
764,2025-09-26 14:17:16.434031 +00:00,2025-10-05 21:34:04.434031 +00:00,8757.00,true,210
765,2025-09-09 16:04:44.141135 +00:00,,8062.00,false,210
766,2022-11-02 20:23:44.299565 +00:00,2022-11-02 20:31:28.299565 +00:00,41087.00,true,211
767,2012-06-15 08:55:29.006902 +00:00,2012-06-15 09:05:57.006902 +00:00,26583.00,true,212
768,2016-05-01 07:36:16.116205 +00:00,2016-05-09 04:25:58.116205 +00:00,17215.00,true,212
769,2025-09-28 22:48:00.173572 +00:00,2025-09-28 22:56:36.173572 +00:00,12080.00,true,213
770,2025-10-02 06:13:23.722792 +00:00,,46289.00,false,213
771,2025-09-30 00:36:37.391883 +00:00,,2144.00,false,213
772,2014-09-04 05:06:08.868474 +00:00,2014-09-04 05:10:35.868474 +00:00,2883.00,true,214
773,2020-10-17 04:53:15.427063 +00:00,2020-10-22 14:48:44.427063 +00:00,1046.00,true,214
774,2023-06-17 06:02:42.475321 +00:00,2023-06-28 16:29:23.475321 +00:00,10807.00,true,214
775,2024-02-22 19:37:20.120659 +00:00,2024-02-27 20:19:10.120659 +00:00,4999.00,true,214
776,2025-07-20 03:27:50.202020 +00:00,2025-07-20 03:35:52.202020 +00:00,17.00,true,215
777,2025-09-20 02:55:43.467774 +00:00,2025-09-29 23:13:57.467774 +00:00,1333.00,true,215
778,2025-09-24 05:18:03.458034 +00:00,2025-09-28 06:57:05.458034 +00:00,2353.00,true,215
779,2012-05-14 09:44:50.451469 +00:00,2012-05-14 09:56:40.451469 +00:00,2116.00,true,216
780,2025-06-19 09:57:16.609761 +00:00,2025-06-26 22:37:59.609761 +00:00,7929.00,true,216
781,2017-06-02 15:32:02.236419 +00:00,2017-06-11 11:15:28.236419 +00:00,12.00,true,216
782,2015-11-26 17:39:22.596875 +00:00,2015-11-27 10:40:32.596875 +00:00,721.00,true,216
783,2013-02-14 22:30:14.281119 +00:00,2013-02-18 10:39:39.281119 +00:00,1938.00,true,216
784,2020-12-05 20:38:46.764476 +00:00,2020-12-05 20:41:15.764476 +00:00,1736.00,true,217
785,2024-05-18 16:40:48.684227 +00:00,2024-05-21 13:40:27.684227 +00:00,13631.00,true,217
786,2022-06-04 14:35:07.650114 +00:00,2022-06-15 23:15:08.650114 +00:00,12302.00,true,217
787,2025-06-10 13:55:37.808416 +00:00,2025-06-11 09:03:28.808416 +00:00,3279.00,true,217
788,2025-02-27 03:00:31.483523 +00:00,2025-03-08 12:55:45.483523 +00:00,14359.00,true,217
789,2018-01-10 01:03:23.653023 +00:00,2018-01-10 01:15:24.653023 +00:00,494.00,true,218
790,2021-03-18 05:44:18.375946 +00:00,2021-03-24 23:57:34.375946 +00:00,3141.00,true,218
791,2021-05-08 23:45:08.229192 +00:00,2021-05-18 22:23:56.229192 +00:00,6377.00,true,218
792,2019-04-06 17:36:52.659621 +00:00,2019-04-07 07:10:29.659621 +00:00,2167.00,true,218
793,2011-06-13 11:15:48.775216 +00:00,2011-06-13 11:25:22.775216 +00:00,21634.00,true,219
794,2023-03-27 13:33:41.924667 +00:00,2023-03-30 21:55:09.924667 +00:00,4973.00,true,219
795,2015-12-09 02:14:40.794628 +00:00,2015-12-14 15:50:37.794628 +00:00,10199.00,true,219
796,2013-03-21 16:58:40.813729 +00:00,2013-03-21 17:13:50.813729 +00:00,3809.00,true,220
797,2019-03-16 10:33:30.981972 +00:00,2019-03-19 01:23:28.981972 +00:00,6750.00,true,220
798,2025-08-04 16:41:08.747138 +00:00,2025-08-04 16:46:13.747138 +00:00,42781.00,true,221
799,2025-07-05 10:25:45.523492 +00:00,2025-07-05 10:29:52.523492 +00:00,7263.00,true,222
800,2025-07-24 10:48:20.154148 +00:00,2025-07-30 05:53:04.154148 +00:00,15667.00,true,222
801,2025-07-08 09:37:13.718218 +00:00,2025-07-18 11:56:22.718218 +00:00,26245.00,true,222
802,2025-10-02 00:44:26.422100 +00:00,,1652.00,false,222
803,2025-07-26 15:45:51.054365 +00:00,2025-07-26 15:52:58.054365 +00:00,5807.00,true,223
804,2025-09-09 12:17:34.619545 +00:00,2025-09-15 05:47:41.619545 +00:00,6321.00,true,223
805,2012-10-08 21:08:12.822034 +00:00,2012-10-08 21:21:08.822034 +00:00,5652.00,true,224
806,2025-07-03 02:41:31.837286 +00:00,2025-07-03 02:58:00.837286 +00:00,1478.00,true,225
807,2025-07-22 10:54:21.029108 +00:00,2025-07-29 11:06:13.029108 +00:00,1002.00,true,225
808,2025-08-16 01:46:38.351663 +00:00,2025-08-17 15:12:18.351663 +00:00,6112.00,true,225
809,2025-08-22 13:12:20.393743 +00:00,2025-08-24 05:40:33.393743 +00:00,2095.00,true,225
810,2025-08-11 05:17:16.367161 +00:00,2025-08-21 23:03:50.367161 +00:00,1542.00,true,225
811,2025-08-15 09:32:48.784889 +00:00,,1130.00,false,225
812,2025-07-14 09:57:33.710863 +00:00,2025-07-14 10:04:14.710863 +00:00,13484.00,true,226
813,2025-09-13 00:31:50.613824 +00:00,2025-09-24 08:14:37.613824 +00:00,4500.00,true,226
814,2025-08-04 01:10:43.796718 +00:00,2025-08-14 11:44:50.796718 +00:00,4170.00,true,226
815,2025-08-14 05:21:15.310154 +00:00,2025-08-14 11:22:15.310154 +00:00,39863.00,true,226
816,2025-09-17 13:22:22.601828 +00:00,2025-09-28 21:20:19.601828 +00:00,33.00,true,226
817,2025-10-04 17:40:11.883305 +00:00,,3346.00,false,226
818,2025-08-22 17:04:25.073216 +00:00,2025-08-22 17:19:53.073216 +00:00,7226.00,true,227
819,2025-10-04 15:05:53.267254 +00:00,,2863.00,false,227
820,2025-09-17 07:19:40.878036 +00:00,,8867.00,false,227
821,2025-09-15 23:42:22.684695 +00:00,2025-09-27 05:34:43.684695 +00:00,8484.00,true,227
822,2025-09-25 13:40:50.431258 +00:00,2025-09-27 08:44:11.431258 +00:00,6908.00,true,227
823,2015-04-22 21:58:44.572616 +00:00,2015-04-22 22:05:11.572616 +00:00,6618.00,true,228
824,2020-01-21 23:59:47.917609 +00:00,2020-02-01 10:03:45.917609 +00:00,17264.00,true,228
825,2024-10-19 09:52:35.751095 +00:00,2024-10-29 21:24:19.751095 +00:00,2501.00,true,228
826,2019-03-08 09:54:34.060447 +00:00,2019-03-13 02:14:24.060447 +00:00,12996.00,true,228
827,2016-11-28 03:24:39.700260 +00:00,2016-12-08 23:05:06.700260 +00:00,35467.00,true,228
828,2025-07-05 03:31:23.935185 +00:00,2025-07-05 03:43:47.935185 +00:00,171.00,true,229
829,2025-09-22 13:45:01.046039 +00:00,,12748.00,false,229
830,2025-09-29 06:01:22.589866 +00:00,2025-10-02 01:06:16.589866 +00:00,3718.00,true,229
831,2025-07-22 00:15:34.197938 +00:00,2025-08-01 12:24:37.197938 +00:00,25.00,true,229
832,2025-09-02 08:13:27.411366 +00:00,2025-09-05 20:36:11.411366 +00:00,107.00,true,229
833,2025-09-28 01:29:07.485089 +00:00,2025-10-03 08:43:28.485089 +00:00,2011.00,true,229
834,2025-08-31 05:43:33.700871 +00:00,2025-08-31 05:49:53.700871 +00:00,2143.00,true,230
835,2025-10-01 18:13:45.787395 +00:00,,5183.00,false,230
836,2025-09-05 20:55:17.015193 +00:00,2025-09-06 08:37:03.015193 +00:00,7706.00,true,230
837,2016-05-21 12:34:49.404472 +00:00,2016-05-21 12:38:43.404472 +00:00,46060.00,true,231
838,2016-05-24 08:35:02.669569 +00:00,2016-05-31 11:25:03.669569 +00:00,8422.00,true,231
839,2017-04-15 22:14:29.507495 +00:00,2017-04-15 22:19:43.507495 +00:00,18747.00,true,232
840,2022-05-11 09:27:35.806228 +00:00,2022-05-11 09:36:01.806228 +00:00,10018.00,true,233
841,2015-12-22 00:08:14.175160 +00:00,2015-12-22 00:16:12.175160 +00:00,7785.00,true,234
842,2017-09-06 05:17:55.263281 +00:00,2017-09-08 23:45:47.263281 +00:00,18617.00,true,234
843,2025-02-15 17:09:34.140945 +00:00,2025-02-19 18:39:34.140945 +00:00,9505.00,true,234
844,2025-07-03 10:15:47.053723 +00:00,2025-07-03 10:26:25.053723 +00:00,7406.00,true,235
845,2025-09-05 00:43:54.824433 +00:00,2025-09-11 16:06:24.824433 +00:00,4529.00,true,235
846,2025-07-14 14:43:59.205521 +00:00,2025-07-21 05:54:08.205521 +00:00,3149.00,true,235
847,2025-09-07 20:39:06.146376 +00:00,2025-09-13 06:48:48.146376 +00:00,4724.00,true,235
848,2025-08-30 14:56:43.243312 +00:00,2025-09-04 19:53:48.243312 +00:00,987.00,true,235
849,2023-01-19 04:10:03.869394 +00:00,2023-01-19 04:17:37.869394 +00:00,1042.00,true,236
850,2023-08-25 23:39:33.732170 +00:00,2023-09-05 04:48:43.732170 +00:00,1276.00,true,236
851,2023-10-28 20:17:55.823712 +00:00,2023-11-02 14:17:49.823712 +00:00,96.00,true,236
852,2025-06-16 03:12:21.199909 +00:00,2025-06-25 06:58:19.199909 +00:00,954.00,true,236
853,2025-09-24 08:40:14.551470 +00:00,2025-09-24 08:42:18.551470 +00:00,2988.00,true,237
854,2025-09-25 05:15:52.860819 +00:00,2025-10-06 01:29:35.860819 +00:00,8863.00,true,237
855,2025-09-27 10:58:11.394739 +00:00,2025-10-05 10:27:07.394739 +00:00,1667.00,true,237
856,2025-09-30 23:34:16.083271 +00:00,2025-10-03 13:12:19.083271 +00:00,15300.00,true,237
857,2025-10-01 07:01:32.348090 +00:00,2025-10-04 12:41:58.348090 +00:00,33197.00,true,237
858,2015-03-16 08:30:46.974699 +00:00,2015-03-16 08:40:34.974699 +00:00,9330.00,true,238
859,2016-04-08 11:42:39.412386 +00:00,2016-04-13 06:19:48.412386 +00:00,10510.00,true,238
860,2025-08-09 08:13:29.486727 +00:00,2025-08-09 08:24:02.486727 +00:00,6585.00,true,239
861,2025-09-28 20:45:30.405786 +00:00,2025-10-03 03:12:07.405786 +00:00,4625.00,true,239
862,2025-08-21 19:44:29.459153 +00:00,,10371.00,false,239
863,2025-10-04 06:46:26.173740 +00:00,,19850.00,false,239
864,2010-03-04 14:35:01.476185 +00:00,2010-03-04 14:41:21.476185 +00:00,53174.00,true,240
865,2021-06-15 14:15:46.504919 +00:00,2021-06-15 14:20:31.504919 +00:00,285.00,true,241
866,2025-01-07 12:58:06.116790 +00:00,2025-01-18 01:53:44.116790 +00:00,717.00,true,241
867,2024-04-27 16:42:07.727914 +00:00,2024-04-28 04:22:36.727914 +00:00,229.00,true,241
868,2021-12-26 17:48:31.096092 +00:00,2022-01-05 07:49:44.096092 +00:00,319.00,true,241
869,2018-01-29 07:46:43.322235 +00:00,2018-01-29 07:52:58.322235 +00:00,46045.00,true,242
870,2025-08-15 00:37:21.798768 +00:00,2025-08-15 00:40:57.798768 +00:00,55.00,true,243
871,2025-09-27 22:17:52.308828 +00:00,2025-10-04 22:40:34.308828 +00:00,211.00,true,243
872,2025-08-24 06:51:15.047135 +00:00,2025-08-31 09:21:29.047135 +00:00,17.00,true,243
873,2015-02-02 17:49:15.808008 +00:00,2015-02-02 17:57:26.808008 +00:00,13507.00,true,244
874,2022-12-06 14:44:46.477772 +00:00,2022-12-11 15:00:21.477772 +00:00,18042.00,true,244
875,2020-05-04 01:14:14.540306 +00:00,2020-05-15 02:12:57.540306 +00:00,6599.00,true,244
876,2019-10-23 14:45:48.316438 +00:00,2019-10-23 14:49:57.316438 +00:00,345.00,true,245
877,2025-06-07 21:10:19.404812 +00:00,2025-06-12 09:43:17.404812 +00:00,25.00,true,245
878,2022-04-20 18:22:56.429671 +00:00,2022-05-01 00:30:32.429671 +00:00,1841.00,true,245
879,2022-03-20 22:36:05.381713 +00:00,2022-03-28 07:18:44.381713 +00:00,3614.00,true,245
880,2022-08-03 00:27:33.116885 +00:00,2022-08-08 15:41:51.116885 +00:00,4996.00,true,245
881,2025-07-18 04:33:57.895763 +00:00,2025-07-18 04:46:01.895763 +00:00,18699.00,true,246
882,2025-07-19 11:40:36.457400 +00:00,2025-07-19 11:52:21.457400 +00:00,12745.00,true,247
883,2025-08-26 12:15:26.787118 +00:00,2025-08-30 03:57:13.787118 +00:00,19734.00,true,247
884,2021-07-03 09:04:00.129765 +00:00,2021-07-03 09:14:43.129765 +00:00,1336.00,true,248
885,2025-03-10 19:29:21.235840 +00:00,2025-03-20 07:06:40.235840 +00:00,247.00,true,248
886,2025-01-03 19:28:48.249242 +00:00,,6382.00,false,248
887,2012-07-29 07:18:30.332939 +00:00,2012-07-29 07:33:42.332939 +00:00,2533.00,true,249
888,2025-06-21 00:16:05.982149 +00:00,2025-06-24 05:10:44.982149 +00:00,12053.00,true,249
889,2019-12-14 17:43:35.527174 +00:00,2019-12-18 20:12:52.527174 +00:00,15379.00,true,249
890,2014-05-29 22:44:10.919878 +00:00,2014-06-04 05:40:48.919878 +00:00,10830.00,true,249
891,2015-02-02 05:08:56.110940 +00:00,2015-02-02 05:24:28.110940 +00:00,2640.00,true,250
892,2023-07-30 10:19:44.540160 +00:00,2023-08-05 10:54:43.540160 +00:00,1117.00,true,250
893,2021-08-09 00:56:20.309461 +00:00,2021-08-17 20:48:18.309461 +00:00,5148.00,true,250
894,2023-09-17 17:53:12.474957 +00:00,2023-09-21 05:47:29.474957 +00:00,6076.00,true,250
895,2020-05-22 10:01:00.535586 +00:00,2020-05-22 10:16:15.535586 +00:00,868.00,true,251
896,2024-11-25 21:38:52.106727 +00:00,2024-11-29 15:06:30.106727 +00:00,1131.00,true,251
897,2020-11-16 13:13:25.211135 +00:00,2020-11-25 19:35:13.211135 +00:00,1840.00,true,251
898,2020-11-03 04:11:57.439760 +00:00,2020-11-08 04:29:47.439760 +00:00,6917.00,true,251
899,2024-11-29 19:27:45.737008 +00:00,,1055.00,false,251
900,2024-03-06 10:55:00.700499 +00:00,2024-03-16 17:21:05.700499 +00:00,3196.00,true,251
901,2018-07-21 23:44:29.765434 +00:00,2018-07-21 23:47:46.765434 +00:00,31134.00,true,252
902,2024-03-23 22:00:46.280792 +00:00,2024-03-23 22:12:04.280792 +00:00,4727.00,true,253
903,2024-07-22 19:51:20.521735 +00:00,,3132.00,false,253
904,2024-09-10 01:00:47.454995 +00:00,2024-09-19 15:43:40.454995 +00:00,4355.00,true,253
905,2025-04-09 00:44:29.789958 +00:00,2025-04-18 01:43:01.789958 +00:00,826.00,true,253
906,2025-01-16 17:41:12.167792 +00:00,2025-01-19 21:10:34.167792 +00:00,5101.00,true,253
907,2024-06-01 23:16:50.646392 +00:00,2024-06-02 22:34:37.646392 +00:00,2202.00,true,253
908,2025-09-02 12:20:47.881618 +00:00,2025-09-02 12:33:47.881618 +00:00,24183.00,true,254
909,2025-09-26 10:32:21.099233 +00:00,2025-10-03 04:54:35.099233 +00:00,18895.00,true,254
910,2025-09-14 21:13:06.580461 +00:00,2025-09-14 21:25:37.580461 +00:00,5093.00,true,255
911,2025-09-22 23:39:29.438347 +00:00,2025-09-28 16:18:48.438347 +00:00,19641.00,true,255
912,2019-03-22 23:57:23.194901 +00:00,2019-03-23 00:07:19.194901 +00:00,8677.00,true,256
913,2021-01-04 13:28:19.038055 +00:00,2021-01-13 18:36:48.038055 +00:00,18701.00,true,256
914,2021-11-25 15:11:10.466607 +00:00,2021-12-04 18:14:17.466607 +00:00,1031.00,true,256
915,2022-12-08 11:27:02.942632 +00:00,2022-12-09 22:03:12.942632 +00:00,23713.00,true,256
916,2019-06-08 21:59:56.739081 +00:00,2019-06-19 00:28:14.739081 +00:00,6175.00,true,256
917,2022-05-24 00:05:08.723667 +00:00,2022-05-24 00:11:01.723667 +00:00,2652.00,true,257
918,2022-07-19 06:50:37.164261 +00:00,2022-07-29 12:23:02.164261 +00:00,8269.00,true,257
919,2022-06-01 09:08:57.400327 +00:00,2022-06-02 18:04:50.400327 +00:00,2851.00,true,257
920,2024-01-23 12:49:00.466874 +00:00,2024-01-25 02:16:06.466874 +00:00,6647.00,true,257
921,2024-09-14 06:32:30.567190 +00:00,2024-09-19 17:00:47.567190 +00:00,4223.00,true,257
922,2023-06-30 05:41:08.589352 +00:00,2023-07-06 16:05:23.589352 +00:00,13299.00,true,257
923,2025-08-10 11:08:13.674307 +00:00,2025-08-10 11:20:12.674307 +00:00,11440.00,true,258
924,2020-11-26 01:11:58.336670 +00:00,2020-11-26 01:16:02.336670 +00:00,15.00,true,259
925,2024-01-16 22:00:31.081565 +00:00,2024-01-21 17:26:05.081565 +00:00,6478.00,true,259
926,2024-06-09 01:43:10.343916 +00:00,2024-06-11 02:38:04.343916 +00:00,21232.00,true,259
927,2023-09-03 12:15:01.042623 +00:00,2023-09-13 11:48:38.042623 +00:00,32265.00,true,259
928,2025-10-02 09:33:23.676296 +00:00,2025-10-02 09:35:23.676296 +00:00,1532.00,true,260
929,2025-10-03 13:12:48.817920 +00:00,,889.00,false,260
930,2025-10-04 16:43:47.471354 +00:00,,2383.00,false,260
931,2025-10-03 08:36:25.275907 +00:00,,16225.00,false,260
932,2025-07-01 18:09:43.416443 +00:00,2025-07-01 18:19:50.416443 +00:00,15985.00,true,261
933,2025-07-11 00:43:21.672592 +00:00,2025-07-12 01:05:45.672592 +00:00,11856.00,true,261
934,2025-08-22 09:17:49.237608 +00:00,2025-08-25 01:36:42.237608 +00:00,2623.00,true,261
935,2025-08-08 12:58:37.928852 +00:00,2025-08-13 19:37:42.928852 +00:00,7096.00,true,261
936,2014-06-02 19:14:09.319555 +00:00,2014-06-02 19:16:52.319555 +00:00,19010.00,true,262
937,2013-07-03 19:21:44.046292 +00:00,2013-07-03 19:36:18.046292 +00:00,7245.00,true,263
938,2018-12-18 02:22:46.757642 +00:00,2018-12-18 12:13:10.757642 +00:00,22902.00,true,263
939,2023-12-07 22:00:03.669170 +00:00,2023-12-11 17:14:27.669170 +00:00,11555.00,true,263
940,2024-08-08 18:32:31.708469 +00:00,2024-08-12 09:32:17.708469 +00:00,89.00,true,263
941,2018-09-22 02:27:36.731337 +00:00,2018-09-22 02:39:00.731337 +00:00,5030.00,true,264
942,2021-05-08 02:20:03.902704 +00:00,2021-05-12 08:46:44.902704 +00:00,5819.00,true,264
943,2019-04-21 02:38:55.602548 +00:00,2019-04-24 22:38:43.602548 +00:00,4439.00,true,264
944,2022-10-29 22:45:17.688311 +00:00,2022-11-04 10:42:26.688311 +00:00,10898.00,true,264
945,2024-12-10 22:36:23.018395 +00:00,2024-12-16 11:46:45.018395 +00:00,9968.00,true,264
946,2017-10-27 15:48:31.408192 +00:00,2017-10-27 15:51:32.408192 +00:00,1355.00,true,265
947,2018-08-13 02:09:46.430209 +00:00,2018-08-23 00:30:27.430209 +00:00,6905.00,true,265
948,2020-01-04 04:51:48.819550 +00:00,2020-01-13 03:36:27.819550 +00:00,5557.00,true,265
949,2023-03-18 14:57:20.241313 +00:00,2023-03-18 20:59:46.241313 +00:00,15460.00,true,265
950,2024-04-08 02:37:28.633097 +00:00,2024-04-08 08:41:38.633097 +00:00,5820.00,true,265
951,2022-07-06 07:56:42.233722 +00:00,2022-07-12 15:00:15.233722 +00:00,3759.00,true,265
952,2022-02-06 15:40:37.991575 +00:00,2022-02-06 15:44:56.991575 +00:00,15024.00,true,266
953,2024-07-11 21:15:37.386592 +00:00,2024-07-15 08:39:30.386592 +00:00,5979.00,true,266
954,2024-02-02 06:16:55.574705 +00:00,2024-02-03 13:00:22.574705 +00:00,1147.00,true,266
955,2015-10-09 07:51:53.675030 +00:00,2015-10-09 07:56:22.675030 +00:00,1583.00,true,267
956,2019-06-09 23:30:42.191153 +00:00,2019-06-18 03:13:30.191153 +00:00,18127.00,true,267
957,2022-04-02 04:02:38.850161 +00:00,2022-04-02 22:26:24.850161 +00:00,2274.00,true,267
958,2023-09-26 17:50:01.684838 +00:00,2023-09-29 18:59:27.684838 +00:00,5683.00,true,267
959,2021-11-23 04:13:03.495176 +00:00,2021-12-04 07:22:56.495176 +00:00,583.00,true,267
960,2011-06-09 03:31:05.163038 +00:00,2011-06-09 03:43:06.163038 +00:00,29293.00,true,268
961,2023-05-16 18:54:32.106528 +00:00,2023-05-26 12:12:11.106528 +00:00,20987.00,true,268
962,2024-11-22 09:17:15.646510 +00:00,2024-12-02 23:39:53.646510 +00:00,5670.00,true,268
963,2023-08-07 05:58:51.789680 +00:00,2023-08-07 06:12:49.789680 +00:00,26707.00,true,269
964,2025-08-19 20:51:53.698532 +00:00,2025-08-19 21:06:08.698532 +00:00,3576.00,true,270
965,2025-09-25 05:08:24.463553 +00:00,2025-09-28 18:29:35.463553 +00:00,2425.00,true,270
966,2010-06-25 08:58:36.226740 +00:00,2010-06-25 09:01:45.226740 +00:00,33714.00,true,271
967,2021-07-08 04:31:41.622915 +00:00,2021-07-11 00:25:28.622915 +00:00,9585.00,true,271
968,2020-05-24 09:08:13.837698 +00:00,2020-05-24 09:21:47.837698 +00:00,1846.00,true,272
969,2020-07-08 12:38:35.567577 +00:00,2020-07-18 12:20:57.567577 +00:00,16735.00,true,272
970,2020-12-23 05:41:46.069040 +00:00,2020-12-24 10:53:28.069040 +00:00,28358.00,true,272
971,2019-03-17 23:16:49.336943 +00:00,2019-03-17 23:29:10.336943 +00:00,9371.00,true,273
972,2022-04-11 20:40:46.779736 +00:00,2022-04-14 16:31:02.779736 +00:00,1831.00,true,273
973,2020-02-23 06:18:39.338843 +00:00,2020-03-05 09:11:06.338843 +00:00,1877.00,true,273
974,2014-03-05 21:01:10.232314 +00:00,2014-03-05 21:03:14.232314 +00:00,7052.00,true,274
975,2014-10-11 03:56:09.361229 +00:00,2014-10-13 18:37:25.361229 +00:00,23204.00,true,274
976,2025-07-30 19:07:10.738086 +00:00,2025-07-30 19:22:14.738086 +00:00,26317.00,true,275
977,2025-09-22 08:26:11.107619 +00:00,2025-09-27 04:41:33.107619 +00:00,35114.00,true,275
978,2025-09-16 20:45:47.204295 +00:00,2025-09-20 20:10:14.204295 +00:00,3432.00,true,275
979,2025-08-28 17:27:12.890171 +00:00,2025-09-04 06:08:34.890171 +00:00,2228.00,true,275
980,2010-07-03 17:41:32.366687 +00:00,2010-07-03 17:51:30.366687 +00:00,762.00,true,276
981,2023-03-03 19:20:39.861367 +00:00,2023-03-03 22:44:14.861367 +00:00,343.00,true,276
982,2019-05-03 11:54:00.688387 +00:00,2019-05-09 09:46:02.688387 +00:00,3065.00,true,276
983,2015-06-20 11:41:52.776909 +00:00,2015-06-30 06:03:20.776909 +00:00,3843.00,true,276
984,2018-03-04 15:31:01.084514 +00:00,2018-03-12 00:32:15.084514 +00:00,2165.00,true,276
985,2018-02-07 20:27:21.235206 +00:00,2018-02-07 20:31:47.235206 +00:00,11667.00,true,277
986,2024-07-09 17:49:33.199158 +00:00,2024-07-15 22:47:49.199158 +00:00,16039.00,true,277
987,2020-07-23 20:56:26.005629 +00:00,2020-07-28 02:15:44.005629 +00:00,6921.00,true,277
988,2018-09-09 06:23:09.196153 +00:00,2018-09-09 06:31:25.196153 +00:00,6208.00,true,278
989,2025-06-09 09:48:51.137647 +00:00,2025-06-14 18:23:50.137647 +00:00,801.00,true,278
990,2022-10-11 01:30:30.077698 +00:00,2022-10-12 11:31:51.077698 +00:00,8749.00,true,278
991,2021-05-19 18:12:33.080913 +00:00,2021-05-19 18:13:59.080913 +00:00,29784.00,true,279
992,2013-03-14 07:35:10.134177 +00:00,2013-03-14 07:44:31.134177 +00:00,35760.00,true,280
993,2022-03-27 19:14:25.649292 +00:00,2022-04-01 17:08:39.649292 +00:00,1441.00,true,280
994,2019-03-18 23:14:33.940996 +00:00,2019-03-20 21:48:41.940996 +00:00,3383.00,true,280
995,2015-12-18 23:24:36.204254 +00:00,2015-12-18 23:33:55.204254 +00:00,5569.00,true,281
996,2025-06-09 11:57:58.556929 +00:00,2025-06-19 15:41:47.556929 +00:00,158.00,true,281
997,2019-11-13 19:57:49.439044 +00:00,2019-11-18 11:23:06.439044 +00:00,164.00,true,281
998,2016-01-26 05:38:00.939719 +00:00,2016-02-03 10:12:03.939719 +00:00,6039.00,true,281
999,2020-02-05 18:28:57.980977 +00:00,2020-02-05 18:32:53.980977 +00:00,33910.00,true,282
1000,2020-03-16 19:58:23.763323 +00:00,2020-03-18 00:18:06.763323 +00:00,35229.00,true,282
1001,2021-06-29 20:36:09.973827 +00:00,,215.00,false,282
1002,2010-10-04 13:56:21.789952 +00:00,2010-10-04 14:00:59.789952 +00:00,82630.00,true,283
1003,2022-03-16 17:14:37.790965 +00:00,2022-03-16 17:20:05.790965 +00:00,28150.00,true,284
1004,2013-05-10 07:52:25.903034 +00:00,2013-05-10 07:54:32.903034 +00:00,72.00,true,285
1005,2016-09-12 14:16:32.788309 +00:00,2016-09-13 05:10:02.788309 +00:00,4839.00,true,285
1006,2023-02-18 05:56:19.396823 +00:00,2023-02-18 10:58:56.396823 +00:00,1222.00,true,285
1007,2019-08-20 07:04:09.059519 +00:00,,7929.00,false,285
1008,2016-07-02 05:27:47.484931 +00:00,2016-07-03 02:24:34.484931 +00:00,809.00,true,285
1009,2016-02-24 04:43:02.120842 +00:00,2016-02-24 04:48:09.120842 +00:00,3148.00,true,286
1010,2018-06-28 16:53:50.609743 +00:00,2018-07-04 16:37:20.609743 +00:00,4490.00,true,286
1011,2020-09-30 08:28:34.919896 +00:00,2020-10-09 05:50:16.919896 +00:00,1241.00,true,286
1012,2022-07-27 16:30:32.369709 +00:00,2022-07-28 11:24:34.369709 +00:00,1853.00,true,286
1013,2022-12-28 07:55:13.137257 +00:00,2023-01-05 02:01:16.137257 +00:00,4356.00,true,286
1014,2019-05-26 23:16:01.232957 +00:00,2019-05-26 23:21:14.232957 +00:00,2876.00,true,287
1015,2019-11-14 08:46:55.416179 +00:00,2019-11-16 19:33:36.416179 +00:00,4976.00,true,287
1016,2014-04-24 13:28:37.682646 +00:00,2014-04-24 13:39:12.682646 +00:00,1090.00,true,288
1017,2017-06-07 17:11:36.229124 +00:00,2017-06-07 17:22:35.229124 +00:00,21811.00,true,289
1018,2025-05-27 02:34:33.810410 +00:00,2025-05-30 12:02:41.810410 +00:00,8364.00,true,289
1019,2017-10-11 15:29:16.104983 +00:00,2017-10-22 11:30:27.104983 +00:00,35886.00,true,289
1020,2021-07-29 21:01:24.838667 +00:00,2021-07-29 21:06:00.838667 +00:00,2084.00,true,290
1021,2022-08-29 23:18:30.177552 +00:00,2022-09-06 06:47:16.177552 +00:00,1130.00,true,290
1022,2022-05-24 15:52:34.698724 +00:00,2022-05-26 19:50:56.698724 +00:00,343.00,true,290
1023,2022-08-12 05:22:14.576448 +00:00,2022-08-13 02:08:51.576448 +00:00,526.00,true,290
1024,2024-02-12 16:07:38.248747 +00:00,2024-02-19 14:00:43.248747 +00:00,180.00,true,290
1025,2023-10-20 13:40:03.954845 +00:00,2023-10-24 16:37:29.954845 +00:00,174.00,true,290
1026,2022-03-04 06:07:45.554706 +00:00,2022-03-04 06:18:37.554706 +00:00,9098.00,true,291
1027,2012-09-17 18:49:12.411827 +00:00,2012-09-17 19:01:41.411827 +00:00,1333.00,true,292
1028,2016-10-31 16:29:36.440324 +00:00,2016-11-03 02:03:07.440324 +00:00,1185.00,true,292
1029,2018-03-14 10:46:50.120363 +00:00,2018-03-22 17:33:31.120363 +00:00,202.00,true,292
1030,2024-07-07 07:27:33.264265 +00:00,2024-07-11 03:14:54.264265 +00:00,1.00,true,292
1031,2022-01-31 01:56:41.789340 +00:00,2022-02-10 16:45:39.789340 +00:00,27.00,true,292
1032,2019-09-20 02:09:48.573060 +00:00,2019-09-28 18:45:08.573060 +00:00,404.00,true,292
1033,2019-11-21 23:16:12.460977 +00:00,2019-11-21 23:28:32.460977 +00:00,1870.00,true,293
1034,2022-09-06 00:16:24.840390 +00:00,2022-09-17 07:25:29.840390 +00:00,23790.00,true,293
1035,2012-11-22 18:37:19.137966 +00:00,2012-11-22 18:44:22.137966 +00:00,4880.00,true,294
1036,2023-02-22 07:25:23.420428 +00:00,2023-02-23 01:01:53.420428 +00:00,4622.00,true,294
1037,2022-05-18 16:55:41.974846 +00:00,2022-05-29 07:33:28.974846 +00:00,16676.00,true,294
1038,2022-10-02 01:05:31.462619 +00:00,2022-10-05 02:39:59.462619 +00:00,5854.00,true,294
1039,2019-01-23 04:17:36.237538 +00:00,2019-01-23 22:12:23.237538 +00:00,6495.00,true,294
1040,2019-02-16 03:16:39.692140 +00:00,2019-02-16 03:20:35.692140 +00:00,24764.00,true,295
1041,2022-11-05 08:10:52.635018 +00:00,2022-11-07 06:28:16.635018 +00:00,10483.00,true,295
1042,2023-02-16 11:20:00.024074 +00:00,2023-02-16 11:31:20.024074 +00:00,7957.00,true,296
1043,2024-06-28 13:43:21.257509 +00:00,2024-07-05 07:58:37.257509 +00:00,688.00,true,296
1044,2023-06-07 11:23:57.526629 +00:00,2023-06-13 15:39:41.526629 +00:00,1109.00,true,296
1045,2025-07-15 03:20:20.707633 +00:00,2025-07-15 03:28:20.707633 +00:00,33574.00,true,297
1046,2025-07-31 02:56:50.671313 +00:00,2025-08-05 00:57:08.671313 +00:00,30435.00,true,297
1047,2013-02-19 11:27:43.009063 +00:00,2013-02-19 11:41:36.009063 +00:00,8216.00,true,298
1048,2014-07-10 16:25:07.828443 +00:00,2014-07-16 23:15:44.828443 +00:00,9672.00,true,298
1049,2014-05-19 15:59:47.005726 +00:00,2014-05-29 06:23:37.005726 +00:00,1055.00,true,298
1050,2018-07-25 02:16:43.564093 +00:00,2018-08-03 04:45:05.564093 +00:00,4157.00,true,298
1051,2025-07-15 07:14:52.576054 +00:00,2025-07-15 07:24:31.576054 +00:00,6004.00,true,299
1052,2025-08-16 20:23:52.773651 +00:00,2025-08-17 16:35:48.773651 +00:00,4462.00,true,299
1053,2025-09-18 03:19:18.465471 +00:00,2025-09-26 06:18:01.465471 +00:00,3290.00,true,299
1054,2025-07-18 17:42:48.896994 +00:00,2025-07-20 10:37:05.896994 +00:00,360.00,true,299
1055,2025-07-30 18:46:23.590378 +00:00,2025-08-08 07:48:07.590378 +00:00,9001.00,true,299
1056,2025-08-21 01:24:08.572509 +00:00,2025-08-28 15:44:56.572509 +00:00,4536.00,true,299
1057,2025-08-05 05:13:34.577777 +00:00,2025-08-05 05:24:59.577777 +00:00,756.00,true,300
1058,2025-09-12 11:31:50.122622 +00:00,2025-09-16 20:53:22.122622 +00:00,2005.00,true,300
1059,2025-09-23 11:44:23.186643 +00:00,2025-09-28 17:06:22.186643 +00:00,8802.00,true,300
1060,2025-10-01 08:14:53.902180 +00:00,2025-10-02 20:05:56.902180 +00:00,2752.00,true,300
1061,2025-09-07 00:06:50.229915 +00:00,2025-09-09 16:26:01.229915 +00:00,15093.00,true,300
1062,2025-08-08 19:36:31.567149 +00:00,2025-08-20 00:11:11.567149 +00:00,5772.00,true,300
1063,2025-08-25 05:59:00.883466 +00:00,2025-08-25 06:04:58.883466 +00:00,63447.00,true,301
1064,2022-01-25 16:31:13.678210 +00:00,2022-01-25 16:32:46.678210 +00:00,69515.00,true,302
1065,2023-12-13 10:57:16.679201 +00:00,2023-12-16 00:56:42.679201 +00:00,7321.00,true,302
1066,2025-09-02 16:53:37.898621 +00:00,2025-09-02 17:02:18.898621 +00:00,3286.00,true,303
1067,2025-09-04 20:17:30.669968 +00:00,2025-09-05 08:05:51.669968 +00:00,14996.00,true,303
1068,2025-09-03 06:14:36.126331 +00:00,2025-09-12 01:24:16.126331 +00:00,4614.00,true,303
1069,2025-09-04 07:55:10.415358 +00:00,2025-09-07 19:00:10.415358 +00:00,19647.00,true,303
1070,2025-09-26 21:17:01.793493 +00:00,2025-10-05 05:02:25.793493 +00:00,16113.00,true,303
1071,2025-09-17 07:15:04.764416 +00:00,2025-09-21 03:28:05.764416 +00:00,609.00,true,303
1072,2025-10-01 12:53:52.876958 +00:00,2025-10-01 13:04:50.876958 +00:00,6007.00,true,304
1073,2025-10-01 21:53:00.532332 +00:00,,6279.00,false,304
1074,2025-10-02 22:22:15.519588 +00:00,,467.00,false,304
1075,2017-07-07 02:25:34.205189 +00:00,2017-07-07 02:41:58.205189 +00:00,3389.00,true,305
1076,2023-02-07 14:01:30.215051 +00:00,2023-02-11 20:52:06.215051 +00:00,725.00,true,305
1077,2021-04-23 04:54:21.678725 +00:00,2021-04-27 15:20:18.678725 +00:00,6417.00,true,305
1078,2023-07-08 01:39:25.525646 +00:00,2023-07-10 04:42:36.525646 +00:00,365.00,true,305
1079,2022-08-12 14:37:36.411916 +00:00,2022-08-12 17:41:47.411916 +00:00,9651.00,true,305
1080,2012-10-21 13:08:23.320808 +00:00,2012-10-21 13:20:30.320808 +00:00,15440.00,true,306
1081,2025-08-11 07:05:52.144755 +00:00,2025-08-11 07:17:26.144755 +00:00,21628.00,true,307
1082,2012-07-04 21:42:13.342004 +00:00,2012-07-04 21:45:35.342004 +00:00,301.00,true,308
1083,2022-02-27 10:20:31.984453 +00:00,2022-03-10 07:52:17.984453 +00:00,373.00,true,308
1084,2022-02-28 11:55:29.264992 +00:00,2022-03-02 01:42:52.264992 +00:00,283.00,true,308
1085,2014-11-07 18:33:23.044096 +00:00,2014-11-18 17:44:32.044096 +00:00,192.00,true,308
1086,2023-08-18 12:50:42.123795 +00:00,2023-08-21 13:31:53.123795 +00:00,1241.00,true,308
1087,2025-09-04 23:41:38.226182 +00:00,2025-09-04 23:53:43.226182 +00:00,4021.00,true,309
1088,2025-09-25 08:46:31.319248 +00:00,2025-09-26 01:42:58.319248 +00:00,7494.00,true,309
1089,2025-09-08 14:57:44.889222 +00:00,2025-09-14 13:21:00.889222 +00:00,12457.00,true,309
1090,2025-09-29 08:23:52.594267 +00:00,2025-10-03 04:24:13.594267 +00:00,1313.00,true,309
1091,2025-09-17 22:16:19.024715 +00:00,2025-09-26 21:01:42.024715 +00:00,16036.00,true,309
1092,2014-11-12 20:53:58.234112 +00:00,2014-11-12 21:05:46.234112 +00:00,22123.00,true,310
1093,2021-12-16 07:12:17.189336 +00:00,2021-12-21 02:15:46.189336 +00:00,3226.00,true,310
1094,2022-02-23 09:59:53.708280 +00:00,2022-02-23 16:51:41.708280 +00:00,11064.00,true,310
1095,2025-08-14 03:47:18.225059 +00:00,2025-08-14 03:59:18.225059 +00:00,11636.00,true,311
1096,2025-09-25 16:37:15.239530 +00:00,2025-10-01 14:21:06.239530 +00:00,2560.00,true,311
1097,2025-09-22 10:00:57.977427 +00:00,2025-09-23 00:53:04.977427 +00:00,15324.00,true,311
1098,2025-08-15 17:55:26.915716 +00:00,2025-08-15 17:59:42.915716 +00:00,19567.00,true,312
1099,2025-08-09 05:06:16.681721 +00:00,2025-08-09 05:13:47.681721 +00:00,13920.00,true,313
1100,2025-08-21 10:28:38.641215 +00:00,2025-08-25 00:20:04.641215 +00:00,5565.00,true,313
1101,2025-08-13 04:33:16.608428 +00:00,2025-08-16 18:51:36.608428 +00:00,37526.00,true,313
1102,2025-09-23 02:51:02.150582 +00:00,2025-09-24 11:05:55.150582 +00:00,4805.00,true,313
1103,2025-09-04 18:47:31.078230 +00:00,2025-09-08 09:51:30.078230 +00:00,9829.00,true,313
1104,2025-08-12 22:48:19.097583 +00:00,2025-08-12 22:59:12.097583 +00:00,11222.00,true,314
1105,2025-09-14 08:32:29.682748 +00:00,2025-09-22 14:13:05.682748 +00:00,8314.00,true,314
1106,2025-09-07 10:58:31.561455 +00:00,2025-09-07 11:12:35.561455 +00:00,39671.00,true,315
1107,2025-09-23 07:45:34.972208 +00:00,2025-10-02 05:10:06.972208 +00:00,11584.00,true,315
1108,2019-09-13 01:40:55.192936 +00:00,2019-09-13 01:42:47.192936 +00:00,28291.00,true,316
1109,2022-03-08 11:27:27.249900 +00:00,2022-03-13 05:14:36.249900 +00:00,15554.00,true,316
1110,2021-06-22 08:27:29.738349 +00:00,,521.00,false,316
1111,2023-12-03 11:28:01.323732 +00:00,2023-12-07 06:09:29.323732 +00:00,15910.00,true,316
1112,2025-08-09 10:02:58.651151 +00:00,2025-08-09 10:17:37.651151 +00:00,37633.00,true,317
1113,2025-09-30 19:21:51.453328 +00:00,,7850.00,false,317
1114,2025-08-25 15:18:45.298456 +00:00,2025-09-04 08:32:35.298456 +00:00,12855.00,true,317
1115,2021-06-24 16:51:30.113073 +00:00,2021-06-24 17:02:34.113073 +00:00,31239.00,true,318
1116,2025-01-31 00:07:08.377835 +00:00,2025-02-01 12:59:24.377835 +00:00,3040.00,true,318
1117,2024-12-29 17:24:57.092081 +00:00,2025-01-07 19:11:07.092081 +00:00,20276.00,true,318
1118,2022-11-19 05:43:06.307957 +00:00,2022-11-23 12:41:47.307957 +00:00,4732.00,true,318
1119,2018-10-14 09:13:09.220831 +00:00,2018-10-14 09:28:32.220831 +00:00,6389.00,true,319
1120,2021-07-31 02:15:04.153202 +00:00,2021-08-06 04:58:22.153202 +00:00,6981.00,true,319
1121,2020-01-18 01:18:06.903286 +00:00,2020-01-20 22:40:03.903286 +00:00,21224.00,true,319
1122,2025-07-09 17:25:18.072262 +00:00,2025-07-09 17:33:30.072262 +00:00,2517.00,true,320
1123,2025-08-02 17:04:54.128947 +00:00,2025-08-13 06:07:21.128947 +00:00,18341.00,true,320
1124,2025-08-13 06:01:49.887988 +00:00,2025-08-16 13:20:49.887988 +00:00,15373.00,true,320
1125,2014-08-16 18:24:07.618480 +00:00,2014-08-16 18:29:10.618480 +00:00,31267.00,true,321
1126,2011-04-24 17:11:19.511160 +00:00,2011-04-24 17:24:24.511160 +00:00,5906.00,true,322
1127,2022-09-23 15:03:20.873733 +00:00,2022-10-01 20:44:25.873733 +00:00,1726.00,true,322
1128,2021-04-17 13:45:28.320436 +00:00,2021-04-18 23:30:05.320436 +00:00,605.00,true,322
1129,2013-10-14 00:12:54.621713 +00:00,2013-10-14 00:25:18.621713 +00:00,4363.00,true,323
1130,2021-03-20 16:36:33.702149 +00:00,2021-03-26 10:05:36.702149 +00:00,1695.00,true,323
1131,2020-04-03 08:46:15.455034 +00:00,2020-04-08 22:17:24.455034 +00:00,1177.00,true,323
1132,2017-07-13 00:11:09.579895 +00:00,2017-07-23 16:57:57.579895 +00:00,2053.00,true,323
1133,2019-09-04 23:03:28.475135 +00:00,2019-09-08 23:40:46.475135 +00:00,3462.00,true,323
1134,2015-01-31 17:38:10.553044 +00:00,2015-01-31 17:44:43.553044 +00:00,32892.00,true,324
1135,2016-01-24 10:17:12.954484 +00:00,2016-02-03 04:50:21.954484 +00:00,1546.00,true,324
1136,2019-03-17 11:26:46.221124 +00:00,2019-03-17 11:31:44.221124 +00:00,14555.00,true,325
1137,2020-03-05 07:15:04.036433 +00:00,2020-03-11 01:20:50.036433 +00:00,46527.00,true,325
1138,2025-08-06 09:55:01.864898 +00:00,2025-08-06 09:59:07.864898 +00:00,16933.00,true,326
1139,2025-08-08 10:24:16.619694 +00:00,2025-08-12 02:14:10.619694 +00:00,2125.00,true,326
1140,2024-12-21 04:04:27.544334 +00:00,2024-12-21 04:13:28.544334 +00:00,5380.00,true,327
1141,2025-03-19 06:43:44.245855 +00:00,2025-03-28 03:19:20.245855 +00:00,15097.00,true,327
1142,2025-06-21 11:46:40.461687 +00:00,2025-06-21 21:35:42.461687 +00:00,646.00,true,327
1143,2021-04-21 21:51:38.577921 +00:00,2021-04-21 22:04:41.577921 +00:00,467.00,true,328
1144,2025-09-09 18:41:17.637537 +00:00,2025-09-12 08:06:44.637537 +00:00,1423.00,true,328
1145,2023-09-30 05:51:37.386620 +00:00,2023-10-09 22:54:26.386620 +00:00,5688.00,true,328
1146,2025-05-07 12:22:00.339192 +00:00,,2040.00,false,328
1147,2010-10-30 14:17:56.986686 +00:00,2010-10-30 14:27:03.986686 +00:00,702.00,true,329
1148,2024-01-26 02:14:55.609268 +00:00,2024-02-05 15:03:42.609268 +00:00,500.00,true,329
1149,2025-08-13 06:13:03.908552 +00:00,2025-08-13 06:27:59.908552 +00:00,65.00,true,330
1150,2025-08-19 22:19:08.388453 +00:00,2025-08-27 02:59:31.388453 +00:00,555.00,true,330
1151,2025-09-06 08:54:29.785431 +00:00,2025-09-15 16:04:10.785431 +00:00,1056.00,true,330
1152,2025-09-23 11:45:50.164754 +00:00,2025-09-24 22:23:33.164754 +00:00,68.00,true,330
1153,2025-09-05 06:34:19.455996 +00:00,2025-09-11 23:32:14.455996 +00:00,676.00,true,330
1154,2018-09-14 06:50:19.584114 +00:00,2018-09-14 07:00:44.584114 +00:00,18741.00,true,331
1155,2025-08-18 20:55:27.619193 +00:00,2025-08-18 21:05:11.619193 +00:00,340.00,true,332
1156,2025-09-27 05:26:33.052989 +00:00,2025-10-01 11:09:47.052989 +00:00,3406.00,true,332
1157,2025-09-18 01:45:09.075021 +00:00,2025-09-29 08:37:46.075021 +00:00,7291.00,true,332
1158,2025-09-15 00:49:53.985151 +00:00,2025-09-16 16:31:07.985151 +00:00,952.00,true,332
1159,2025-08-29 02:08:43.538630 +00:00,2025-08-31 00:33:00.538630 +00:00,4920.00,true,332
1160,2011-07-30 21:25:21.428549 +00:00,2011-07-30 21:26:34.428549 +00:00,42620.00,true,333
1161,2016-11-07 00:21:01.077983 +00:00,2016-11-12 06:58:23.077983 +00:00,18337.00,true,333
1162,2015-02-18 21:12:01.153808 +00:00,2015-02-18 21:26:49.153808 +00:00,10487.00,true,334
1163,2022-12-22 18:18:17.110711 +00:00,2022-12-31 01:52:58.110711 +00:00,2499.00,true,334
1164,2019-07-06 03:15:24.865257 +00:00,2019-07-06 16:14:10.865257 +00:00,8631.00,true,334
1165,2015-11-08 12:55:36.335789 +00:00,2015-11-13 13:07:36.335789 +00:00,2910.00,true,334
1166,2021-05-09 17:49:48.805368 +00:00,2021-05-12 11:29:32.805368 +00:00,5548.00,true,334
1167,2018-06-11 16:34:13.082528 +00:00,2018-06-15 03:49:13.082528 +00:00,3418.00,true,334
1168,2012-10-09 15:30:21.689117 +00:00,2012-10-09 15:37:58.689117 +00:00,85.00,true,335
1169,2024-10-16 04:23:59.111828 +00:00,2024-10-22 21:29:17.111828 +00:00,133.00,true,335
1170,2015-02-04 01:57:49.736352 +00:00,,56.00,false,335
1171,2017-08-01 12:00:11.803190 +00:00,2017-08-04 23:22:07.803190 +00:00,147.00,true,335
1172,2024-01-15 11:57:57.442430 +00:00,2024-01-23 04:25:33.442430 +00:00,166.00,true,335
1173,2016-02-22 04:38:54.016718 +00:00,2016-02-23 10:19:22.016718 +00:00,19.00,true,335
1174,2013-01-10 01:31:15.383376 +00:00,2013-01-10 01:47:11.383376 +00:00,38658.00,true,336
1175,2019-01-25 07:46:32.183342 +00:00,2019-02-02 04:31:51.183342 +00:00,20563.00,true,336
1176,2023-10-07 16:43:27.828305 +00:00,2023-10-13 23:14:54.828305 +00:00,1855.00,true,336
1177,2012-09-11 21:38:18.914143 +00:00,2012-09-11 21:53:22.914143 +00:00,51266.00,true,337
1178,2022-07-04 17:07:29.347909 +00:00,2022-07-04 17:15:02.347909 +00:00,2718.00,true,338
1179,2020-10-09 04:06:04.388374 +00:00,2020-10-09 04:19:32.388374 +00:00,753.00,true,339
1180,2025-04-04 23:18:00.300681 +00:00,2025-04-13 16:35:03.300681 +00:00,8903.00,true,339
1181,2023-10-12 18:30:14.600827 +00:00,2023-10-22 03:19:20.600827 +00:00,1150.00,true,339
1182,2011-05-07 02:23:28.273679 +00:00,2011-05-07 02:38:48.273679 +00:00,6614.00,true,340
1183,2024-05-11 09:42:45.338412 +00:00,2024-05-19 12:58:05.338412 +00:00,7264.00,true,340
1184,2016-09-18 17:55:53.857863 +00:00,2016-09-29 16:21:04.857863 +00:00,2180.00,true,340
1185,2023-10-09 16:22:09.237328 +00:00,2023-10-17 23:12:05.237328 +00:00,23199.00,true,340
1186,2015-02-21 14:55:06.814480 +00:00,2015-03-03 10:40:51.814480 +00:00,4972.00,true,340
1187,2024-03-13 04:45:35.680647 +00:00,2024-03-24 09:56:21.680647 +00:00,1344.00,true,340
1188,2015-04-22 14:29:19.039346 +00:00,2015-04-22 14:40:43.039346 +00:00,2454.00,true,341
1189,2018-01-19 01:56:29.256469 +00:00,2018-01-22 21:49:56.256469 +00:00,1772.00,true,341
1190,2019-02-23 20:08:36.909434 +00:00,2019-03-04 18:21:11.909434 +00:00,1037.00,true,341
1191,2024-05-02 07:16:45.401015 +00:00,2024-05-09 01:54:09.401015 +00:00,2686.00,true,341
1192,2024-05-05 10:15:03.735542 +00:00,2024-05-05 10:16:48.735542 +00:00,1330.00,true,342
1193,2024-08-31 15:35:05.029074 +00:00,2024-09-11 01:47:37.029074 +00:00,697.00,true,342
1194,2025-01-21 00:29:13.300535 +00:00,2025-01-31 22:46:25.300535 +00:00,312.00,true,342
1195,2024-07-06 02:21:11.498677 +00:00,2024-07-14 09:51:26.498677 +00:00,246.00,true,342
1196,2025-08-03 01:52:16.033772 +00:00,2025-08-10 10:43:08.033772 +00:00,1811.00,true,342
1197,2024-12-15 14:13:24.402277 +00:00,2024-12-15 14:19:42.402277 +00:00,189.00,true,343
1198,2025-05-10 17:06:03.444537 +00:00,2025-05-16 03:38:52.444537 +00:00,1029.00,true,343
1199,2025-05-23 16:42:26.211138 +00:00,2025-05-26 19:31:39.211138 +00:00,1652.00,true,343
1200,2014-05-14 11:40:44.075407 +00:00,2014-05-14 11:41:10.075407 +00:00,51453.00,true,344
1201,2024-03-16 19:33:58.267677 +00:00,2024-03-20 11:04:15.267677 +00:00,6820.00,true,344
1202,2019-10-28 21:57:42.831834 +00:00,2019-10-28 22:06:43.831834 +00:00,723.00,true,345
1203,2021-08-03 01:05:34.039110 +00:00,2021-08-06 21:12:07.039110 +00:00,944.00,true,345
1204,2020-08-27 10:12:40.379956 +00:00,2020-09-03 00:03:29.379956 +00:00,2449.00,true,345
1205,2025-09-19 17:18:34.809007 +00:00,2025-09-22 22:02:21.809007 +00:00,3510.00,true,345
1206,2020-02-09 23:28:15.020567 +00:00,2020-02-09 23:34:14.020567 +00:00,1824.00,true,346
1207,2022-09-15 23:00:43.691963 +00:00,2022-09-23 03:54:17.691963 +00:00,254.00,true,346
1208,2023-04-19 12:44:38.222939 +00:00,2023-04-27 01:30:55.222939 +00:00,1332.00,true,346
1209,2025-07-03 16:56:48.715581 +00:00,2025-07-06 12:31:58.715581 +00:00,1342.00,true,346
1210,2010-08-24 05:18:28.636046 +00:00,2010-08-24 05:33:02.636046 +00:00,3252.00,true,347
1211,2025-02-07 14:13:47.430612 +00:00,2025-02-11 04:53:17.430612 +00:00,13457.00,true,347
1212,2020-11-08 07:15:01.275671 +00:00,2020-11-08 07:17:32.275671 +00:00,1339.00,true,348
1213,2025-01-07 18:34:29.010271 +00:00,,21590.00,false,348
1214,2023-05-11 09:52:43.129355 +00:00,2023-05-19 00:39:30.129355 +00:00,2045.00,true,348
1215,2022-08-17 04:36:10.345965 +00:00,2022-08-28 06:35:05.345965 +00:00,13191.00,true,348
1216,2023-02-28 07:05:11.464828 +00:00,2023-03-08 08:32:54.464828 +00:00,972.00,true,348
1217,2024-06-26 19:37:03.291742 +00:00,2024-07-02 13:55:56.291742 +00:00,3590.00,true,348
1218,2020-09-08 15:25:08.131068 +00:00,2020-09-08 15:32:20.131068 +00:00,2659.00,true,349
1219,2025-09-12 23:07:08.574880 +00:00,2025-09-12 23:19:26.574880 +00:00,31116.00,true,350
1220,2025-09-24 02:45:07.418701 +00:00,2025-09-27 00:32:43.418701 +00:00,4702.00,true,350
1221,2025-10-01 01:38:44.556880 +00:00,,21118.00,false,350
1222,2025-09-29 21:46:55.778256 +00:00,,8545.00,false,350
1223,2016-04-04 07:03:35.789914 +00:00,2016-04-04 07:19:37.789914 +00:00,17700.00,true,351
1224,2016-08-18 19:59:01.986510 +00:00,2016-08-19 05:37:17.986510 +00:00,11710.00,true,351
1225,2024-03-19 05:55:58.506598 +00:00,2024-03-22 15:54:55.506598 +00:00,3131.00,true,351
1226,2019-01-18 02:59:57.545901 +00:00,2019-01-24 18:27:36.545901 +00:00,19063.00,true,351
1227,2016-04-15 11:44:57.811072 +00:00,2016-04-27 00:26:49.811072 +00:00,13899.00,true,351
1228,2025-08-04 03:42:58.237802 +00:00,2025-08-04 03:43:19.237802 +00:00,8319.00,true,352
1229,2025-08-13 00:27:33.796081 +00:00,2025-08-13 05:18:00.796081 +00:00,28413.00,true,352
1230,2025-08-05 11:48:17.741593 +00:00,2025-08-09 05:49:47.741593 +00:00,5480.00,true,352
1231,2025-09-25 05:17:55.705893 +00:00,2025-10-06 01:28:24.705893 +00:00,4041.00,true,352
1232,2025-10-01 15:10:52.572378 +00:00,,463.00,false,352
1233,2011-01-30 03:41:16.353259 +00:00,2011-01-30 03:48:59.353259 +00:00,1473.00,true,353
1234,2020-05-01 17:04:00.925642 +00:00,2020-05-06 16:15:17.925642 +00:00,3120.00,true,353
1235,2023-12-14 09:58:55.445498 +00:00,2023-12-20 06:09:00.445498 +00:00,130.00,true,353
1236,2020-03-28 05:44:53.854483 +00:00,2020-04-08 08:18:25.854483 +00:00,1456.00,true,353
1237,2013-12-04 03:58:43.281615 +00:00,2013-12-05 21:59:23.281615 +00:00,175.00,true,353
1238,2019-09-05 13:47:54.635099 +00:00,2019-09-10 11:55:29.635099 +00:00,2422.00,true,353
1239,2025-08-08 06:20:43.719603 +00:00,2025-08-08 06:26:13.719603 +00:00,155.00,true,354
1240,2025-09-27 19:59:49.030722 +00:00,,7063.00,false,354
1241,2025-08-18 22:17:39.374324 +00:00,2025-08-29 09:10:47.374324 +00:00,6485.00,true,354
1242,2025-08-12 15:28:31.122389 +00:00,2025-08-20 14:08:33.122389 +00:00,5385.00,true,354
1243,2025-09-26 14:45:16.655115 +00:00,2025-09-28 11:33:30.655115 +00:00,4895.00,true,354
1244,2025-09-29 02:37:39.620497 +00:00,,8549.00,false,354
1245,2025-04-29 20:15:12.976211 +00:00,2025-04-29 20:26:06.976211 +00:00,7679.00,true,355
1246,2025-08-21 11:13:03.049878 +00:00,2025-08-25 23:31:34.049878 +00:00,9965.00,true,355
1247,2025-09-07 02:00:35.918219 +00:00,2025-09-10 02:23:34.918219 +00:00,2659.00,true,355
1248,2025-07-22 05:29:06.617996 +00:00,2025-07-29 20:57:14.617996 +00:00,4159.00,true,355
1249,2022-07-01 19:17:07.825574 +00:00,2022-07-01 19:32:33.825574 +00:00,10380.00,true,356
1250,2025-10-02 12:48:48.410188 +00:00,2025-10-03 02:19:47.410188 +00:00,5980.00,true,356
1251,2025-02-08 11:19:41.444995 +00:00,2025-02-13 16:14:48.444995 +00:00,542.00,true,356
1252,2025-08-16 18:47:56.829800 +00:00,2025-08-25 01:39:13.829800 +00:00,8740.00,true,356
1253,2023-10-23 19:28:43.044811 +00:00,2023-10-24 23:35:57.044811 +00:00,4275.00,true,356
1254,2024-01-03 20:23:21.507696 +00:00,2024-01-09 09:50:50.507696 +00:00,418.00,true,356
1255,2020-08-01 17:17:28.794254 +00:00,2020-08-01 17:25:24.794254 +00:00,23487.00,true,357
1256,2023-11-24 12:01:49.905251 +00:00,2023-11-25 07:36:56.905251 +00:00,10882.00,true,357
1257,2025-06-08 20:13:48.161549 +00:00,2025-06-10 05:01:29.161549 +00:00,3252.00,true,357
1258,2025-09-20 02:28:59.187618 +00:00,2025-09-21 17:02:00.187618 +00:00,969.00,true,357
1259,2021-02-02 18:52:33.669710 +00:00,2021-02-05 17:38:19.669710 +00:00,7497.00,true,357
1260,2024-01-01 14:16:18.453056 +00:00,2024-01-01 14:16:35.453056 +00:00,11264.00,true,358
1261,2024-08-10 20:15:23.723455 +00:00,2024-08-16 15:08:37.723455 +00:00,2321.00,true,358
1262,2024-02-27 21:58:23.086809 +00:00,2024-03-04 13:11:03.086809 +00:00,2069.00,true,358
1263,2025-05-07 23:31:11.564612 +00:00,2025-05-17 16:45:30.564612 +00:00,2296.00,true,358
1264,2024-10-09 13:36:07.287049 +00:00,2024-10-20 04:56:36.287049 +00:00,2888.00,true,358
1265,2020-08-11 09:49:37.657013 +00:00,2020-08-11 09:56:27.657013 +00:00,6154.00,true,359
1266,2021-07-05 13:17:18.786267 +00:00,2021-07-06 03:09:22.786267 +00:00,10466.00,true,359
1267,2022-09-06 22:14:57.882821 +00:00,2022-09-06 22:28:38.882821 +00:00,8791.00,true,360
1268,2025-07-05 15:56:47.888954 +00:00,2025-07-05 16:08:47.888954 +00:00,21256.00,true,361
1269,2025-08-03 19:37:26.748309 +00:00,2025-08-03 19:44:07.748309 +00:00,19466.00,true,362
1270,2025-08-21 14:52:57.845878 +00:00,2025-08-28 00:32:53.845878 +00:00,17231.00,true,362
1271,2025-08-31 06:37:52.493018 +00:00,2025-08-31 06:38:46.493018 +00:00,5770.00,true,363
1272,2025-09-14 13:52:00.980812 +00:00,2025-09-25 16:55:54.980812 +00:00,40803.00,true,363
1273,2025-02-20 02:48:17.716603 +00:00,2025-02-20 03:00:28.716603 +00:00,19742.00,true,364
1274,2025-06-01 21:32:29.246525 +00:00,2025-06-11 12:30:23.246525 +00:00,553.00,true,364
1275,2025-06-16 20:42:09.106727 +00:00,2025-06-24 05:53:19.106727 +00:00,7136.00,true,364
1276,2025-06-20 03:13:29.153330 +00:00,2025-06-24 01:09:22.153330 +00:00,25445.00,true,364
1277,2025-07-24 19:52:16.906667 +00:00,2025-07-26 12:08:47.906667 +00:00,8161.00,true,364
1278,2025-07-17 05:13:14.845203 +00:00,2025-07-23 12:13:17.845203 +00:00,6835.00,true,364
1279,2018-10-05 21:03:08.451788 +00:00,2018-10-05 21:07:20.451788 +00:00,3438.00,true,365
1280,2022-09-15 18:30:18.181225 +00:00,2022-09-20 04:51:00.181225 +00:00,9305.00,true,365
1281,2020-06-09 05:16:01.965158 +00:00,2020-06-18 20:59:43.965158 +00:00,6148.00,true,365
1282,2020-04-15 11:57:29.296852 +00:00,2020-04-17 21:14:09.296852 +00:00,1559.00,true,365
1283,2025-07-10 16:41:34.794385 +00:00,2025-07-10 16:46:01.794385 +00:00,19527.00,true,366
1284,2025-09-21 21:20:35.620131 +00:00,2025-10-03 06:15:09.620131 +00:00,4069.00,true,366
1285,2025-09-09 21:56:16.369108 +00:00,2025-09-20 13:07:30.369108 +00:00,783.00,true,366
1286,2025-07-22 01:46:59.950164 +00:00,2025-08-01 10:15:58.950164 +00:00,15007.00,true,366
1287,2016-10-06 09:12:39.344049 +00:00,2016-10-06 09:20:11.344049 +00:00,2511.00,true,367
1288,2022-04-15 12:15:40.157927 +00:00,2022-04-26 17:28:12.157927 +00:00,736.00,true,367
1289,2018-03-28 05:08:31.430339 +00:00,2018-04-06 08:25:46.430339 +00:00,656.00,true,367
1290,2024-04-05 13:45:13.906299 +00:00,2024-04-06 19:27:29.906299 +00:00,815.00,true,367
1291,2025-08-27 11:36:25.680523 +00:00,2025-08-27 11:48:49.680523 +00:00,47.00,true,368
1292,2025-09-10 20:06:59.025661 +00:00,2025-09-21 07:14:51.025661 +00:00,1318.00,true,368
1293,2025-09-22 13:37:10.720629 +00:00,2025-09-29 00:59:29.720629 +00:00,183.00,true,368
1294,2010-05-23 19:52:06.885750 +00:00,2010-05-23 20:03:57.885750 +00:00,1459.00,true,369
1295,2013-02-11 16:53:10.451107 +00:00,2013-02-19 16:03:45.451107 +00:00,1326.00,true,369
1296,2023-01-23 08:26:38.964168 +00:00,2023-01-25 05:14:37.964168 +00:00,2352.00,true,369
1297,2014-04-12 01:52:45.713543 +00:00,2014-04-12 15:39:21.713543 +00:00,16284.00,true,369
1298,2023-01-31 17:04:24.466692 +00:00,2023-02-07 15:49:32.466692 +00:00,17439.00,true,369
1299,2023-09-07 15:22:44.114124 +00:00,2023-09-15 06:41:24.114124 +00:00,2962.00,true,369
1300,2025-07-07 08:08:03.793354 +00:00,2025-07-07 08:16:17.793354 +00:00,15084.00,true,370
1301,2018-05-08 13:44:39.431280 +00:00,2018-05-08 13:46:15.431280 +00:00,1511.00,true,371
1302,2024-02-02 19:57:35.119122 +00:00,2024-02-11 04:18:17.119122 +00:00,3268.00,true,371
1303,2020-03-24 13:44:56.651753 +00:00,2020-03-31 00:28:35.651753 +00:00,8070.00,true,371
1304,2025-09-04 22:25:55.597886 +00:00,2025-09-04 22:26:44.597886 +00:00,5187.00,true,372
1305,2025-09-09 23:45:21.586869 +00:00,2025-09-14 14:39:42.586869 +00:00,3238.00,true,372
1306,2025-09-24 03:33:45.187019 +00:00,2025-09-28 03:36:59.187019 +00:00,4880.00,true,372
1307,2025-09-21 06:10:11.304993 +00:00,2025-09-27 20:59:10.304993 +00:00,4838.00,true,372
1308,2024-05-07 15:11:17.831043 +00:00,2024-05-07 15:13:05.831043 +00:00,1458.00,true,373
1309,2024-11-29 06:56:03.689509 +00:00,2024-12-06 00:42:43.689509 +00:00,5466.00,true,373
1310,2025-08-08 02:14:14.307190 +00:00,2025-08-09 21:23:51.307190 +00:00,1106.00,true,373
1311,2025-03-11 18:40:21.947795 +00:00,2025-03-22 05:12:34.947795 +00:00,2823.00,true,373
1312,2024-12-08 20:42:16.973367 +00:00,2024-12-19 13:01:11.973367 +00:00,4378.00,true,373
1313,2025-06-15 20:22:40.488229 +00:00,2025-06-18 19:23:28.488229 +00:00,16931.00,true,373
1314,2010-02-14 20:42:16.855265 +00:00,2010-02-14 20:50:53.855265 +00:00,32711.00,true,374
1315,2025-06-08 12:10:58.891320 +00:00,2025-06-08 12:22:04.891320 +00:00,1407.00,true,375
1316,2025-08-12 15:11:50.550556 +00:00,2025-08-17 07:16:22.550556 +00:00,17652.00,true,375
1317,2025-08-01 20:08:11.173926 +00:00,2025-08-03 22:50:53.173926 +00:00,5532.00,true,375
1318,2025-08-22 19:32:02.347952 +00:00,2025-08-26 07:29:17.347952 +00:00,2548.00,true,375
1319,2025-07-31 09:02:17.198982 +00:00,2025-08-08 06:50:32.198982 +00:00,2307.00,true,375
1320,2025-09-03 22:42:36.932540 +00:00,2025-09-13 10:56:59.932540 +00:00,7442.00,true,375
1321,2018-09-17 10:44:03.478828 +00:00,2018-09-17 10:46:31.478828 +00:00,12287.00,true,376
1322,2019-10-02 19:42:02.739610 +00:00,2019-10-10 07:30:49.739610 +00:00,2145.00,true,376
1323,2019-03-10 16:13:29.018785 +00:00,2019-03-17 10:01:00.018785 +00:00,22085.00,true,376
1324,2023-12-26 10:09:16.728499 +00:00,,2706.00,false,376
1325,2025-06-29 15:00:36.954199 +00:00,2025-07-06 13:44:05.954199 +00:00,6383.00,true,376
1326,2025-08-25 15:23:23.119140 +00:00,2025-08-25 15:32:09.119140 +00:00,152.00,true,377
1327,2025-09-15 08:50:05.214037 +00:00,2025-09-16 05:03:45.214037 +00:00,2186.00,true,377
1328,2025-09-13 20:51:10.178768 +00:00,2025-09-16 00:09:28.178768 +00:00,2306.00,true,377
1329,2025-09-13 20:18:57.437640 +00:00,2025-09-17 02:07:09.437640 +00:00,515.00,true,377
1330,2019-08-06 16:39:43.300984 +00:00,2019-08-06 16:49:09.300984 +00:00,4953.00,true,378
1331,2024-05-31 01:00:44.488060 +00:00,2024-06-02 11:02:56.488060 +00:00,3105.00,true,378
1332,2024-03-20 01:48:17.236938 +00:00,2024-03-20 09:10:53.236938 +00:00,3018.00,true,378
1333,2021-12-20 05:11:43.028205 +00:00,2021-12-24 18:55:09.028205 +00:00,529.00,true,378
1334,2024-05-12 15:10:59.173746 +00:00,2024-05-18 00:30:12.173746 +00:00,5092.00,true,378
1335,2010-06-01 21:36:16.506132 +00:00,2010-06-01 21:51:06.506132 +00:00,42008.00,true,379
1336,2014-04-26 22:50:24.267993 +00:00,2014-05-06 12:18:37.267993 +00:00,6835.00,true,379
1337,2017-12-31 13:41:19.190930 +00:00,2018-01-07 07:49:47.190930 +00:00,6297.00,true,379
1338,2025-09-18 15:29:25.651199 +00:00,2025-09-18 15:38:51.651199 +00:00,3031.00,true,380
1339,2025-10-04 19:34:31.232831 +00:00,,1827.00,false,380
1340,2025-09-18 20:38:42.678622 +00:00,2025-09-22 11:53:10.678622 +00:00,20.00,true,380
1341,2025-09-22 23:40:03.741489 +00:00,2025-09-26 15:50:58.741489 +00:00,899.00,true,380
1342,2025-09-30 06:53:09.475384 +00:00,,7653.00,false,380
1343,2020-05-15 03:38:50.859854 +00:00,2020-05-15 03:51:18.859854 +00:00,12093.00,true,381
1344,2025-03-05 21:26:03.692457 +00:00,2025-03-08 16:17:07.692457 +00:00,5523.00,true,381
1345,2020-07-17 10:25:45.043157 +00:00,2020-07-28 09:35:20.043157 +00:00,1221.00,true,381
1346,2021-02-26 03:41:34.011080 +00:00,2021-03-09 11:58:36.011080 +00:00,12309.00,true,381
1347,2022-12-04 08:34:13.440983 +00:00,2022-12-04 08:46:18.440983 +00:00,41088.00,true,382
1348,2023-04-09 18:28:53.477210 +00:00,2023-04-12 20:40:35.477210 +00:00,25941.00,true,382
1349,2020-05-14 02:47:05.323812 +00:00,2020-05-14 02:49:53.323812 +00:00,866.00,true,383
1350,2020-09-24 18:58:33.197729 +00:00,2020-10-01 05:56:58.197729 +00:00,1291.00,true,383
1351,2022-09-12 23:06:18.530133 +00:00,2022-09-14 03:57:43.530133 +00:00,518.00,true,383
1352,2020-12-19 00:59:48.513734 +00:00,2020-12-23 20:33:02.513734 +00:00,1770.00,true,383
1353,2021-12-02 20:46:18.691974 +00:00,2021-12-09 12:31:58.691974 +00:00,1309.00,true,383
1354,2015-08-28 22:16:51.979067 +00:00,2015-08-28 22:18:09.979067 +00:00,38865.00,true,384
1355,2013-07-08 16:42:22.409990 +00:00,2013-07-08 16:45:23.409990 +00:00,4972.00,true,385
1356,2025-08-06 09:12:26.381524 +00:00,2025-08-10 11:02:29.381524 +00:00,12272.00,true,385
1357,2014-12-07 19:52:42.094148 +00:00,2014-12-17 01:53:50.094148 +00:00,11539.00,true,385
1358,2020-03-25 08:41:13.504994 +00:00,2020-03-27 10:39:35.504994 +00:00,815.00,true,385
1359,2013-10-27 18:35:25.781480 +00:00,2013-11-07 19:36:19.781480 +00:00,14661.00,true,385
1360,2024-06-17 19:09:17.019963 +00:00,2024-06-17 19:14:32.019963 +00:00,6637.00,true,386
1361,2025-05-28 14:46:12.903353 +00:00,2025-05-30 06:45:16.903353 +00:00,5227.00,true,386
1362,2024-07-28 07:23:08.090683 +00:00,2024-07-28 20:56:01.090683 +00:00,2431.00,true,386
1363,2025-08-31 05:54:53.612405 +00:00,2025-08-31 20:14:10.612405 +00:00,4533.00,true,386
1364,2025-02-20 08:18:27.764331 +00:00,2025-02-26 22:51:36.764331 +00:00,8509.00,true,386
1365,2025-06-27 07:59:28.017930 +00:00,2025-07-05 22:51:24.017930 +00:00,4673.00,true,386
1366,2025-08-02 01:39:55.266152 +00:00,2025-08-02 01:40:28.266152 +00:00,274.00,true,387
1367,2025-10-04 10:15:11.955575 +00:00,,573.00,false,387
1368,2025-08-13 07:37:24.797524 +00:00,2025-08-14 09:52:28.797524 +00:00,950.00,true,387
1369,2025-09-01 15:50:07.028320 +00:00,2025-09-10 03:59:45.028320 +00:00,172.00,true,387
1370,2025-08-24 21:48:41.018970 +00:00,2025-09-01 17:03:17.018970 +00:00,472.00,true,387
1371,2025-08-15 21:16:55.641810 +00:00,2025-08-21 14:36:41.641810 +00:00,103.00,true,387
1372,2025-10-02 10:00:09.864428 +00:00,2025-10-02 10:06:39.864428 +00:00,370.00,true,388
1373,2025-10-02 11:53:25.206121 +00:00,,467.00,false,388
1374,2025-10-03 20:19:29.237598 +00:00,2025-10-05 23:43:28.237598 +00:00,392.00,true,388
1375,2025-10-03 13:54:55.816274 +00:00,,317.00,false,388
1376,2025-10-04 00:09:09.391274 +00:00,,937.00,false,388
1377,2025-10-04 10:48:44.196521 +00:00,,369.00,false,388
1378,2023-11-22 00:20:24.271623 +00:00,2023-11-22 00:32:33.271623 +00:00,7359.00,true,389
1379,2025-07-22 05:40:20.142159 +00:00,2025-07-22 05:44:20.142159 +00:00,2987.00,true,390
1380,2025-07-30 12:55:36.247066 +00:00,2025-08-09 11:49:20.247066 +00:00,35747.00,true,390
1381,2023-11-27 10:04:10.756974 +00:00,2023-11-27 10:16:33.756974 +00:00,3802.00,true,391
1382,2025-01-03 13:19:22.690825 +00:00,2025-01-08 04:59:06.690825 +00:00,9516.00,true,391
1383,2025-08-02 12:02:57.719034 +00:00,2025-08-02 12:07:41.719034 +00:00,30874.00,true,392
1384,2017-05-24 17:14:34.684928 +00:00,2017-05-24 17:30:43.684928 +00:00,770.00,true,393
1385,2022-07-21 18:43:54.218483 +00:00,2022-08-01 04:00:34.218483 +00:00,21579.00,true,393
1386,2023-07-16 20:45:57.356315 +00:00,2023-07-22 00:57:44.356315 +00:00,4445.00,true,393
1387,2013-12-16 13:05:05.401968 +00:00,2013-12-16 13:17:29.401968 +00:00,16208.00,true,394
1388,2025-09-06 14:15:31.967487 +00:00,2025-09-06 14:21:38.967487 +00:00,3446.00,true,395
1389,2025-09-21 10:20:34.120287 +00:00,,18969.00,false,395
1390,2025-09-29 15:54:48.381860 +00:00,2025-10-03 12:42:33.381860 +00:00,6101.00,true,395
1391,2025-09-27 03:28:32.677385 +00:00,2025-09-28 19:19:20.677385 +00:00,3566.00,true,395
1392,2025-09-16 06:36:50.441553 +00:00,2025-09-18 15:44:58.441553 +00:00,51189.00,true,395
1393,2025-09-25 22:55:10.801938 +00:00,2025-10-05 23:25:56.801938 +00:00,3453.00,true,395
1394,2021-12-30 01:42:26.159535 +00:00,2021-12-30 01:58:47.159535 +00:00,21716.00,true,396
1395,2022-02-24 05:17:36.233272 +00:00,2022-02-27 20:41:07.233272 +00:00,10988.00,true,396
1396,2025-05-13 13:13:59.663463 +00:00,2025-05-17 02:20:13.663463 +00:00,10604.00,true,396
1397,2024-10-13 12:12:06.360639 +00:00,2024-10-17 17:10:15.360639 +00:00,864.00,true,396
1398,2021-12-15 23:42:43.471679 +00:00,2021-12-15 23:45:10.471679 +00:00,31395.00,true,397
1399,2011-11-08 04:07:25.346796 +00:00,2011-11-08 04:18:38.346796 +00:00,30281.00,true,398
1400,2022-01-09 16:57:48.866173 +00:00,2022-01-09 16:58:27.866173 +00:00,36460.00,true,399
1401,2023-11-30 21:49:34.532402 +00:00,2023-11-30 21:57:48.532402 +00:00,18798.00,true,400
1402,2024-01-10 14:01:51.873254 +00:00,2024-01-16 18:31:20.873254 +00:00,142.00,true,400
1403,2025-08-06 21:14:01.847978 +00:00,2025-08-15 05:51:45.847978 +00:00,3629.00,true,400
1404,2025-06-07 21:30:27.681018 +00:00,2025-06-09 19:50:11.681018 +00:00,5777.00,true,400
1405,2025-01-10 23:44:42.800841 +00:00,2025-01-20 07:50:39.800841 +00:00,1291.00,true,400
1406,2025-07-08 15:59:22.827697 +00:00,2025-07-08 16:11:37.827697 +00:00,4740.00,true,401
1407,2025-07-10 12:35:17.351033 +00:00,2025-07-15 20:04:06.351033 +00:00,7715.00,true,401
1408,2025-07-22 05:01:16.017808 +00:00,2025-07-22 05:12:44.017808 +00:00,7970.00,true,402
1409,2025-08-27 14:29:43.041677 +00:00,2025-09-03 16:07:09.041677 +00:00,128.00,true,402
1410,2025-09-02 07:29:24.101589 +00:00,,9435.00,false,402
1411,2025-08-29 02:21:35.888462 +00:00,2025-09-08 12:08:25.888462 +00:00,10572.00,true,402
1412,2023-06-19 01:47:00.372799 +00:00,2023-06-19 01:59:39.372799 +00:00,35997.00,true,403
1413,2025-09-11 10:02:18.817822 +00:00,2025-09-20 12:19:33.817822 +00:00,36711.00,true,403
1414,2022-02-20 20:59:02.254160 +00:00,2022-02-20 21:07:13.254160 +00:00,2230.00,true,404
1415,2023-11-27 13:28:00.971313 +00:00,2023-12-04 05:35:14.971313 +00:00,21382.00,true,404
1416,2025-09-01 02:53:39.909708 +00:00,2025-09-11 05:57:26.909708 +00:00,5994.00,true,404
1417,2013-01-07 08:37:17.711987 +00:00,2013-01-07 08:43:29.711987 +00:00,27034.00,true,405
1418,2021-08-29 23:30:05.809284 +00:00,2021-08-30 17:47:57.809284 +00:00,26198.00,true,405
1419,2025-09-01 19:22:10.121879 +00:00,2025-09-01 19:34:53.121879 +00:00,2286.00,true,406
1420,2025-10-02 02:11:52.440146 +00:00,,958.00,false,406
1421,2025-10-04 06:26:41.057180 +00:00,,201.00,false,406
1422,2025-09-02 08:57:31.992098 +00:00,2025-09-11 15:40:49.992098 +00:00,436.00,true,406
1423,2025-09-28 19:39:33.724910 +00:00,2025-10-05 06:04:58.724910 +00:00,1600.00,true,406
1424,2024-08-13 10:05:19.224399 +00:00,2024-08-13 10:18:44.224399 +00:00,1481.00,true,407
1425,2024-12-07 13:08:09.385199 +00:00,,5139.00,false,407
1426,2025-02-18 13:46:25.051668 +00:00,2025-02-27 12:49:43.051668 +00:00,1088.00,true,407
1427,2024-10-24 10:18:27.441134 +00:00,2024-10-25 23:48:15.441134 +00:00,28993.00,true,407
1428,2025-09-09 23:26:56.393417 +00:00,2025-09-16 00:37:25.393417 +00:00,8759.00,true,407
1429,2025-07-02 03:11:29.953891 +00:00,2025-07-02 03:23:21.953891 +00:00,1633.00,true,408
1430,2025-07-30 08:10:43.213390 +00:00,2025-08-03 08:58:18.213390 +00:00,54076.00,true,408
1431,2018-03-25 07:40:07.991882 +00:00,2018-03-25 07:48:20.991882 +00:00,12980.00,true,409
1432,2020-10-07 18:20:15.819804 +00:00,2020-10-10 04:03:35.819804 +00:00,27432.00,true,409
1433,2025-07-01 18:23:37.711943 +00:00,2025-07-01 18:33:38.711943 +00:00,57247.00,true,410
1434,2019-02-15 22:13:09.042495 +00:00,2019-02-15 22:18:26.042495 +00:00,7274.00,true,411
1435,2022-06-01 02:25:12.307949 +00:00,2022-06-04 19:03:49.307949 +00:00,7101.00,true,411
1436,2021-10-27 08:44:26.445247 +00:00,2021-11-06 18:05:57.445247 +00:00,2954.00,true,411
1437,2022-01-22 19:49:46.646990 +00:00,2022-01-24 19:54:43.646990 +00:00,39959.00,true,411
1438,2013-11-28 20:52:29.708341 +00:00,2013-11-28 21:08:02.708341 +00:00,12730.00,true,412
1439,2020-04-19 22:02:46.498402 +00:00,2020-04-22 04:09:05.498402 +00:00,35703.00,true,412
1440,2020-06-07 03:22:05.376541 +00:00,2020-06-17 21:10:56.376541 +00:00,1076.00,true,412
1441,2018-08-10 01:24:07.974347 +00:00,2018-08-19 20:41:43.974347 +00:00,256.00,true,412
1442,2016-08-20 02:50:45.813659 +00:00,2016-08-20 02:51:28.813659 +00:00,11905.00,true,413
1443,2025-06-28 22:33:41.335249 +00:00,2025-07-03 14:24:19.335249 +00:00,7574.00,true,413
1444,2025-03-08 15:15:44.475404 +00:00,2025-03-15 02:24:20.475404 +00:00,4274.00,true,413
1445,2017-03-30 21:07:32.134067 +00:00,2017-04-04 12:22:01.134067 +00:00,862.00,true,413
1446,2018-07-07 15:50:48.411199 +00:00,2018-07-17 22:34:39.411199 +00:00,647.00,true,413
1447,2018-04-30 19:20:04.917014 +00:00,2018-05-06 06:46:29.917014 +00:00,1076.00,true,413
1448,2019-06-01 15:00:24.186926 +00:00,2019-06-01 15:02:01.186926 +00:00,14254.00,true,414
1449,2021-05-23 15:48:47.444094 +00:00,2021-05-29 07:20:30.444094 +00:00,8157.00,true,414
1450,2021-03-04 12:45:58.583082 +00:00,2021-03-08 07:52:11.583082 +00:00,12094.00,true,414
1451,2025-05-30 13:16:01.884590 +00:00,2025-06-03 20:48:37.884590 +00:00,2660.00,true,414
1452,2024-09-02 07:02:43.586673 +00:00,2024-09-09 14:19:11.586673 +00:00,21512.00,true,414
1453,2017-10-01 18:58:59.578664 +00:00,2017-10-01 19:12:19.578664 +00:00,8503.00,true,415
1454,2025-06-27 15:03:54.375967 +00:00,2025-06-29 13:18:44.375967 +00:00,2856.00,true,415
1455,2022-04-15 15:22:08.056299 +00:00,2022-04-21 06:39:55.056299 +00:00,6500.00,true,415
1456,2025-09-08 08:55:55.218465 +00:00,2025-09-08 09:10:41.218465 +00:00,8185.00,true,416
1457,2025-09-28 13:44:09.224031 +00:00,2025-10-03 21:05:28.224031 +00:00,35718.00,true,416
1458,2025-09-18 08:19:08.215844 +00:00,2025-09-18 08:26:49.215844 +00:00,27191.00,true,417
1459,2025-10-03 19:12:10.220344 +00:00,,5580.00,false,417
1460,2025-09-30 21:53:21.045132 +00:00,2025-10-03 02:50:39.045132 +00:00,9869.00,true,417
1461,2011-11-03 16:50:27.624734 +00:00,2011-11-03 17:03:21.624734 +00:00,4536.00,true,418
1462,2015-10-16 08:06:58.686757 +00:00,2015-10-24 17:57:35.686757 +00:00,4101.00,true,418
1463,2014-02-01 18:48:44.099336 +00:00,2014-02-06 03:38:10.099336 +00:00,401.00,true,418
1464,2019-01-08 08:13:04.280186 +00:00,2019-01-19 10:41:36.280186 +00:00,4704.00,true,418
1465,2025-06-01 08:10:12.195678 +00:00,2025-06-11 04:14:32.195678 +00:00,3613.00,true,418
1466,2017-08-29 17:53:43.419261 +00:00,2017-08-31 15:37:00.419261 +00:00,1783.00,true,418
1467,2013-10-09 03:50:31.686711 +00:00,2013-10-09 03:53:14.686711 +00:00,15604.00,true,419
1468,2017-03-30 22:12:03.908686 +00:00,2017-04-01 00:53:16.908686 +00:00,23310.00,true,419
1469,2010-11-30 09:36:23.761160 +00:00,2010-11-30 09:45:54.761160 +00:00,8721.00,true,420
1470,2019-06-25 16:25:45.338564 +00:00,,3606.00,false,420
1471,2012-06-21 06:28:22.352354 +00:00,2012-06-21 10:36:30.352354 +00:00,12481.00,true,420
1472,2013-04-14 21:01:06.174419 +00:00,2013-04-14 21:12:14.174419 +00:00,66931.00,true,421
1473,2018-04-03 08:22:30.758038 +00:00,2018-04-03 08:38:07.758038 +00:00,14211.00,true,422
1474,2025-07-20 12:17:19.719995 +00:00,2025-07-26 11:45:57.719995 +00:00,7555.00,true,422
1475,2021-03-25 03:57:37.429161 +00:00,2021-04-05 16:33:47.429161 +00:00,23835.00,true,422
1476,2021-09-10 21:58:23.224164 +00:00,2021-09-21 00:04:28.224164 +00:00,3707.00,true,422
1477,2010-05-26 00:50:12.672629 +00:00,2010-05-26 00:52:58.672629 +00:00,283.00,true,423
1478,2018-09-30 13:47:41.483234 +00:00,2018-10-01 04:01:51.483234 +00:00,11551.00,true,423
1479,2019-04-04 12:45:17.720615 +00:00,2019-04-10 11:56:57.720615 +00:00,34737.00,true,423
1480,2010-09-15 21:10:08.232809 +00:00,2010-09-15 21:10:41.232809 +00:00,743.00,true,424
1481,2024-09-18 19:22:45.761090 +00:00,2024-09-25 10:55:59.761090 +00:00,1997.00,true,424
1482,2022-11-06 08:19:34.298959 +00:00,2022-11-11 08:33:39.298959 +00:00,1879.00,true,424
1483,2017-01-22 01:29:35.154916 +00:00,2017-01-22 01:31:50.154916 +00:00,1119.00,true,425
1484,2024-03-01 03:17:13.417530 +00:00,2024-03-10 10:36:14.417530 +00:00,729.00,true,425
1485,2021-03-24 21:52:04.031177 +00:00,2021-03-30 04:07:37.031177 +00:00,5146.00,true,425
1486,2025-03-05 11:08:48.356888 +00:00,2025-03-06 11:48:36.356888 +00:00,7629.00,true,425
1487,2023-03-06 00:52:02.044239 +00:00,2023-03-07 11:37:26.044239 +00:00,1573.00,true,425
1488,2023-01-26 22:02:44.190071 +00:00,2023-01-28 08:19:02.190071 +00:00,2875.00,true,425
1489,2025-07-13 22:27:34.829293 +00:00,2025-07-13 22:35:32.829293 +00:00,27660.00,true,426
1490,2025-07-20 14:10:28.584294 +00:00,2025-07-31 00:13:00.584294 +00:00,27904.00,true,426
1491,2022-01-16 19:02:27.303823 +00:00,2022-01-16 19:05:58.303823 +00:00,1238.00,true,427
1492,2024-12-16 14:27:45.463463 +00:00,2024-12-24 13:00:18.463463 +00:00,7457.00,true,427
1493,2023-06-21 08:49:42.869124 +00:00,2023-07-01 04:24:04.869124 +00:00,22271.00,true,427
1494,2014-06-15 10:43:20.824686 +00:00,2014-06-15 10:54:16.824686 +00:00,1918.00,true,428
1495,2021-02-19 01:51:59.862121 +00:00,2021-02-23 19:24:08.862121 +00:00,8009.00,true,428
1496,2020-10-26 18:06:37.996752 +00:00,2020-11-06 07:09:10.996752 +00:00,1147.00,true,428
1497,2025-09-20 15:23:21.037474 +00:00,2025-09-20 15:38:33.037474 +00:00,18.00,true,429
1498,2025-09-29 21:16:48.704447 +00:00,,7536.00,false,429
1499,2025-09-21 08:50:30.310930 +00:00,2025-09-30 01:27:39.310930 +00:00,8259.00,true,429
1500,2025-09-25 12:00:11.663214 +00:00,2025-09-26 03:50:25.663214 +00:00,805.00,true,429
1501,2025-09-30 23:59:00.987301 +00:00,,2045.00,false,429
1502,2025-10-01 04:16:12.875843 +00:00,,1675.00,false,429
1503,2014-08-13 01:14:40.752910 +00:00,2014-08-13 01:30:49.752910 +00:00,839.00,true,430
1504,2024-03-01 13:31:39.406903 +00:00,2024-03-02 12:30:19.406903 +00:00,19566.00,true,430
1505,2014-11-13 02:04:54.934981 +00:00,,16566.00,false,430
1506,2018-02-21 13:00:29.149343 +00:00,2018-03-01 08:14:28.149343 +00:00,7353.00,true,430
1507,2015-11-13 11:16:12.985557 +00:00,2015-11-16 11:16:36.985557 +00:00,313.00,true,430
1508,2025-05-07 19:37:26.885765 +00:00,2025-05-08 11:27:24.885765 +00:00,6406.00,true,430
1509,2010-10-18 02:41:30.920664 +00:00,2010-10-18 02:43:48.920664 +00:00,34914.00,true,431
1510,2025-09-22 22:02:45.862357 +00:00,2025-09-22 22:13:11.862357 +00:00,6220.00,true,432
1511,2025-10-03 21:55:06.901332 +00:00,,9785.00,false,432
1512,2025-09-30 16:48:39.914716 +00:00,2025-09-30 17:03:58.914716 +00:00,5776.00,true,432
1513,2025-09-25 10:16:48.496787 +00:00,2025-10-04 04:14:41.496787 +00:00,7568.00,true,432
1514,2025-10-01 10:24:10.401316 +00:00,,67.00,false,432
1515,2017-01-29 19:27:48.787115 +00:00,2017-01-29 19:36:06.787115 +00:00,29079.00,true,433
1516,2023-03-08 16:56:04.373785 +00:00,2023-03-08 19:41:29.373785 +00:00,2918.00,true,433
1517,2023-12-16 00:11:15.251570 +00:00,2023-12-17 13:09:39.251570 +00:00,6095.00,true,433
1518,2025-07-28 10:09:41.751715 +00:00,2025-07-28 10:22:06.751715 +00:00,1380.00,true,434
1519,2024-05-28 15:25:32.691535 +00:00,2024-05-28 15:37:24.691535 +00:00,196.00,true,435
1520,2025-09-27 16:58:34.368894 +00:00,2025-09-30 14:28:46.368894 +00:00,13076.00,true,435
1521,2017-05-07 09:18:23.573912 +00:00,2017-05-07 09:23:51.573912 +00:00,10250.00,true,436
1522,2017-08-26 01:10:03.531035 +00:00,2017-08-26 01:22:21.531035 +00:00,238.00,true,437
1523,2022-09-13 13:36:36.304667 +00:00,,13713.00,false,437
1524,2021-09-24 07:25:19.398794 +00:00,2021-10-04 20:36:48.398794 +00:00,38144.00,true,437
1525,2025-07-07 14:03:37.533681 +00:00,2025-07-07 14:13:39.533681 +00:00,170.00,true,438
1526,2025-07-27 13:14:08.073524 +00:00,2025-08-03 21:23:43.073524 +00:00,258.00,true,438
1527,2025-10-01 10:04:08.137736 +00:00,2025-10-04 17:34:09.137736 +00:00,191.00,true,438
1528,2025-08-15 15:48:59.517134 +00:00,2025-08-26 15:52:48.517134 +00:00,137.00,true,438
1529,2025-08-30 15:29:30.615518 +00:00,2025-09-09 04:28:24.615518 +00:00,67.00,true,438
1530,2025-09-20 12:40:19.545519 +00:00,2025-10-01 03:53:11.545519 +00:00,28.00,true,438
1531,2011-07-12 19:17:38.138099 +00:00,2011-07-12 19:20:46.138099 +00:00,13159.00,true,439
1532,2011-09-27 20:00:33.340950 +00:00,2011-10-07 09:14:11.340950 +00:00,1879.00,true,439
1533,2022-03-30 16:13:54.258564 +00:00,2022-04-04 00:00:44.258564 +00:00,14121.00,true,439
1534,2025-09-28 13:55:13.833879 +00:00,2025-09-28 13:55:52.833879 +00:00,1705.00,true,440
1535,2025-10-03 02:22:37.297993 +00:00,2025-10-04 14:10:03.297993 +00:00,7637.00,true,440
1536,2018-09-08 02:42:45.641931 +00:00,2018-09-08 02:43:26.641931 +00:00,6118.00,true,441
1537,2023-07-21 15:50:58.846612 +00:00,2023-07-28 00:28:18.846612 +00:00,1028.00,true,441
1538,2022-12-21 15:05:55.134560 +00:00,2022-12-30 19:01:25.134560 +00:00,30141.00,true,441
1539,2025-09-08 06:38:42.008558 +00:00,2025-09-11 00:20:53.008558 +00:00,12201.00,true,441
1540,2020-10-08 12:11:45.207509 +00:00,2020-10-08 12:12:51.207509 +00:00,40809.00,true,442
1541,2025-09-14 04:33:54.443248 +00:00,2025-09-14 04:43:34.443248 +00:00,811.00,true,443
1542,2025-09-27 04:11:17.375178 +00:00,2025-09-28 05:07:27.375178 +00:00,70.00,true,443
1543,2025-09-29 17:43:58.205275 +00:00,,4796.00,false,443
1544,2025-09-28 03:52:43.803347 +00:00,2025-09-29 09:58:09.803347 +00:00,231.00,true,443
1545,2025-07-09 08:59:04.169312 +00:00,2025-07-09 09:10:10.169312 +00:00,21126.00,true,444
1546,2017-01-28 13:19:39.146691 +00:00,2017-01-28 13:27:56.146691 +00:00,4551.00,true,445
1547,2024-03-04 01:11:41.747854 +00:00,2024-03-05 07:46:50.747854 +00:00,4075.00,true,445
1548,2019-07-24 06:26:10.638478 +00:00,2019-07-28 14:06:58.638478 +00:00,899.00,true,445
1549,2019-10-24 20:08:13.511076 +00:00,2019-10-24 20:19:21.511076 +00:00,18247.00,true,446
1550,2025-07-30 10:42:32.839373 +00:00,,2079.00,false,446
1551,2020-03-17 02:40:52.422876 +00:00,2020-03-28 13:00:30.422876 +00:00,262.00,true,446
1552,2021-05-13 16:16:09.758574 +00:00,2021-05-20 07:59:24.758574 +00:00,9632.00,true,446
1553,2021-06-06 07:19:03.174280 +00:00,2021-06-06 07:34:39.174280 +00:00,2145.00,true,447
1554,2022-04-22 23:05:47.232759 +00:00,2022-05-01 19:21:31.232759 +00:00,2154.00,true,447
1555,2024-08-03 12:23:55.801191 +00:00,2024-08-11 23:33:23.801191 +00:00,803.00,true,447
1556,2025-06-13 09:15:14.806676 +00:00,2025-06-20 14:22:44.806676 +00:00,2.00,true,447
1557,2020-01-11 03:33:25.674907 +00:00,2020-01-11 03:34:38.674907 +00:00,19910.00,true,448
1558,2020-09-22 12:54:26.414981 +00:00,2020-09-24 20:05:47.414981 +00:00,8250.00,true,448
1559,2024-01-28 23:16:14.780933 +00:00,2024-01-28 23:17:14.780933 +00:00,36325.00,true,449
1560,2022-05-15 04:43:57.750587 +00:00,2022-05-15 04:45:24.750587 +00:00,6718.00,true,450
1561,2025-02-10 01:11:40.824438 +00:00,2025-02-15 18:32:54.824438 +00:00,29263.00,true,450
1562,2024-07-25 15:59:11.269883 +00:00,2024-08-03 05:04:33.269883 +00:00,7142.00,true,450
1563,2025-06-09 19:03:00.989901 +00:00,2025-06-19 13:32:22.989901 +00:00,10314.00,true,450
1564,2024-10-19 07:40:05.804939 +00:00,2024-10-22 13:37:41.804939 +00:00,553.00,true,450
1565,2017-01-23 07:06:43.912739 +00:00,2017-01-23 07:12:06.912739 +00:00,137.00,true,451
1566,2021-10-27 07:11:50.067248 +00:00,,309.00,false,451
1567,2018-07-12 18:52:00.551404 +00:00,2018-07-18 13:41:35.551404 +00:00,1678.00,true,451
1568,2017-11-26 19:42:59.633737 +00:00,2017-12-02 06:50:19.633737 +00:00,1483.00,true,451
1569,2022-09-29 21:26:38.894020 +00:00,2022-10-04 03:05:40.894020 +00:00,1629.00,true,451
1570,2021-04-22 13:53:47.809627 +00:00,2021-05-02 21:09:30.809627 +00:00,2034.00,true,451
1571,2025-07-01 12:25:41.010302 +00:00,2025-07-01 12:40:31.010302 +00:00,825.00,true,452
1572,2025-09-22 20:58:57.662197 +00:00,2025-09-26 18:59:20.662197 +00:00,944.00,true,452
1573,2025-07-09 09:13:56.961117 +00:00,,20.00,false,452
1574,2025-07-06 08:13:37.108406 +00:00,2025-07-11 23:18:11.108406 +00:00,287.00,true,452
1575,2025-07-13 06:14:08.672971 +00:00,2025-07-22 00:07:49.672971 +00:00,737.00,true,452
1576,2025-09-11 23:36:07.135530 +00:00,2025-09-18 04:37:36.135530 +00:00,1291.00,true,452
1577,2025-07-16 23:11:34.458248 +00:00,2025-07-16 23:25:27.458248 +00:00,105.00,true,453
1578,2025-07-24 06:59:01.999559 +00:00,2025-08-02 23:48:44.999559 +00:00,150.00,true,453
1579,2025-08-05 13:57:09.174600 +00:00,2025-08-09 10:43:56.174600 +00:00,2750.00,true,453
1580,2025-07-26 01:15:21.238123 +00:00,2025-07-29 21:25:56.238123 +00:00,2991.00,true,453
1581,2025-09-06 05:44:01.743419 +00:00,2025-09-14 12:28:17.743419 +00:00,3283.00,true,453
1582,2025-09-29 06:54:47.939111 +00:00,,6944.00,false,453
1583,2015-06-09 05:17:53.654049 +00:00,2015-06-09 05:26:36.654049 +00:00,26570.00,true,454
1584,2022-12-14 20:52:52.630027 +00:00,2022-12-24 04:29:13.630027 +00:00,4287.00,true,454
1585,2023-05-29 19:49:30.153856 +00:00,2023-06-07 23:33:09.153856 +00:00,1748.00,true,454
1586,2022-07-27 12:00:52.494848 +00:00,2022-07-27 19:11:43.494848 +00:00,3119.00,true,454
1587,2025-08-05 11:43:31.286351 +00:00,2025-08-05 11:57:30.286351 +00:00,8188.00,true,455
1588,2025-10-03 04:04:38.131057 +00:00,,36735.00,false,455
1589,2025-09-20 18:33:20.070569 +00:00,2025-09-23 09:09:13.070569 +00:00,17221.00,true,455
1590,2025-09-26 08:33:43.593768 +00:00,2025-09-30 07:33:34.593768 +00:00,3729.00,true,455
1591,2025-07-21 22:12:56.083956 +00:00,2025-07-21 22:20:10.083956 +00:00,11645.00,true,456
1592,2025-09-12 16:59:11.503796 +00:00,2025-09-12 17:04:27.503796 +00:00,13264.00,true,457
1593,2025-09-26 18:59:33.737037 +00:00,2025-10-05 08:03:15.737037 +00:00,1972.00,true,457
1594,2010-07-24 06:13:55.855694 +00:00,2010-07-24 06:27:25.855694 +00:00,7286.00,true,458
1595,2017-08-30 00:06:23.954989 +00:00,2017-09-08 05:51:14.954989 +00:00,8031.00,true,458
1596,2023-09-08 03:47:34.253250 +00:00,2023-09-18 21:55:37.253250 +00:00,14949.00,true,458
1597,2013-12-29 08:34:00.433032 +00:00,2013-12-29 22:28:07.433032 +00:00,7569.00,true,458
1598,2024-08-20 05:22:57.890709 +00:00,2024-08-30 01:57:41.890709 +00:00,12248.00,true,458
1599,2016-09-01 11:08:55.000018 +00:00,2016-09-06 07:50:10.000018 +00:00,7116.00,true,458
1600,2025-09-16 22:18:28.171679 +00:00,2025-09-16 22:28:08.171679 +00:00,11089.00,true,459
1601,2013-11-26 19:44:55.716294 +00:00,2013-11-26 19:57:27.716294 +00:00,20499.00,true,460
1602,2025-07-10 12:40:43.308585 +00:00,2025-07-10 12:50:23.308585 +00:00,16201.00,true,461
1603,2025-09-04 16:18:50.031496 +00:00,2025-09-13 09:43:48.031496 +00:00,26521.00,true,461
1604,2025-09-21 18:27:43.318779 +00:00,2025-09-26 21:49:49.318779 +00:00,542.00,true,461
1605,2025-09-19 00:01:55.351053 +00:00,2025-09-28 03:33:04.351053 +00:00,35670.00,true,461
1606,2025-07-12 17:35:37.935094 +00:00,2025-07-12 17:45:52.935094 +00:00,3397.00,true,462
1607,2025-09-29 00:32:58.478284 +00:00,2025-10-06 01:03:09.478284 +00:00,1163.00,true,462
1608,2025-10-03 12:30:38.163273 +00:00,,5104.00,false,462
1609,2025-07-14 03:56:33.747599 +00:00,,2939.00,false,462
1610,2010-04-27 02:48:59.773346 +00:00,2010-04-27 02:50:15.773346 +00:00,8970.00,true,463
1611,2025-08-10 01:54:03.678569 +00:00,2025-08-10 01:54:46.678569 +00:00,18412.00,true,464
1612,2025-09-10 14:26:55.696609 +00:00,2025-09-16 13:49:28.696609 +00:00,7114.00,true,464
1613,2010-01-20 16:31:57.143285 +00:00,2010-01-20 16:35:53.143285 +00:00,2275.00,true,465
1614,2020-08-06 06:45:04.122742 +00:00,2020-08-08 08:14:00.122742 +00:00,550.00,true,465
1615,2016-10-04 10:36:58.504391 +00:00,2016-10-06 09:51:11.504391 +00:00,817.00,true,465
1616,2010-06-14 03:40:34.133685 +00:00,2010-06-18 15:01:23.133685 +00:00,1033.00,true,465
1617,2018-07-21 14:43:09.936350 +00:00,2018-07-31 10:49:45.936350 +00:00,144.00,true,465
1618,2018-10-27 06:13:41.253490 +00:00,2018-10-30 09:27:11.253490 +00:00,541.00,true,465
1619,2018-04-07 06:01:45.712755 +00:00,2018-04-07 06:03:45.712755 +00:00,955.00,true,466
1620,2018-05-29 15:46:13.375505 +00:00,2018-06-01 09:38:23.375505 +00:00,24555.00,true,466
1621,2024-06-26 20:32:34.251262 +00:00,2024-07-07 23:51:50.251262 +00:00,19822.00,true,466
1622,2018-12-21 18:05:02.007402 +00:00,2018-12-22 07:34:37.007402 +00:00,941.00,true,466
1623,2021-08-18 21:25:20.110606 +00:00,2021-08-27 08:20:41.110606 +00:00,8542.00,true,466
1624,2016-11-22 17:40:22.441097 +00:00,2016-11-22 17:56:28.441097 +00:00,26109.00,true,467
1625,2013-01-17 02:20:19.382315 +00:00,2013-01-17 02:22:15.382315 +00:00,1388.00,true,468
1626,2024-05-06 04:28:40.776392 +00:00,2024-05-15 05:30:54.776392 +00:00,128.00,true,468
1627,2015-02-11 20:01:17.955401 +00:00,2015-02-12 22:02:45.955401 +00:00,27.00,true,468
1628,2024-02-13 12:59:53.374442 +00:00,,5.00,false,468
1629,2025-04-12 19:51:00.538879 +00:00,2025-04-24 01:18:01.538879 +00:00,971.00,true,468
1630,2023-11-21 07:06:14.428706 +00:00,2023-11-21 07:11:04.428706 +00:00,17228.00,true,469
1631,2025-07-23 08:19:58.403320 +00:00,2025-08-01 18:57:53.403320 +00:00,1472.00,true,469
1632,2025-03-24 16:47:44.650301 +00:00,2025-04-01 16:22:22.650301 +00:00,5543.00,true,469
1633,2019-06-28 08:42:23.521166 +00:00,2019-06-28 08:58:31.521166 +00:00,1496.00,true,470
1634,2019-07-16 02:21:26.758111 +00:00,2019-07-22 11:27:51.758111 +00:00,559.00,true,470
1635,2025-09-07 17:55:04.620161 +00:00,,177.00,false,470
1636,2025-07-15 04:55:05.581578 +00:00,2025-07-15 05:09:34.581578 +00:00,3751.00,true,471
1637,2025-08-13 05:05:04.417388 +00:00,2025-08-14 15:22:59.417388 +00:00,1884.00,true,471
1638,2025-09-09 22:21:46.918096 +00:00,2025-09-18 16:09:46.918096 +00:00,3722.00,true,471
1639,2025-07-31 11:28:49.625566 +00:00,2025-08-05 23:38:54.625566 +00:00,462.00,true,471
1640,2025-09-08 15:54:26.798095 +00:00,2025-09-19 09:07:34.798095 +00:00,1971.00,true,471
1641,2011-02-22 12:08:04.574126 +00:00,2011-02-22 12:16:25.574126 +00:00,7605.00,true,472
1642,2024-06-29 11:38:18.845214 +00:00,2024-07-10 21:17:50.845214 +00:00,4985.00,true,472
1643,2023-10-15 23:33:17.509498 +00:00,2023-10-16 14:45:49.509498 +00:00,13897.00,true,472
1644,2022-01-05 17:51:19.384756 +00:00,2022-01-15 17:20:47.384756 +00:00,7906.00,true,472
1645,2014-10-29 06:13:27.001615 +00:00,2014-11-06 02:14:52.001615 +00:00,5618.00,true,472
1646,2023-11-14 03:37:38.107997 +00:00,2023-11-14 03:50:12.107997 +00:00,15890.00,true,473
1647,2024-05-25 02:23:17.726798 +00:00,2024-06-04 16:29:45.726798 +00:00,20681.00,true,473
1648,2024-11-11 08:02:11.278090 +00:00,2024-11-18 19:56:14.278090 +00:00,15568.00,true,473
1649,2012-10-01 19:29:59.272965 +00:00,2012-10-01 19:44:57.272965 +00:00,29220.00,true,474
1650,2017-08-06 14:53:53.790080 +00:00,2017-08-06 15:00:13.790080 +00:00,3720.00,true,475
1651,2023-01-21 22:42:06.206147 +00:00,2023-01-28 07:56:44.206147 +00:00,1177.00,true,475
1652,2022-03-15 21:09:30.526922 +00:00,2022-03-26 12:26:18.526922 +00:00,9326.00,true,475
1653,2021-05-08 07:40:26.115687 +00:00,2021-05-18 05:33:58.115687 +00:00,11666.00,true,475
1654,2023-07-30 21:20:46.164539 +00:00,2023-08-08 03:14:58.164539 +00:00,5140.00,true,475
1655,2018-11-27 19:11:41.347753 +00:00,2018-12-08 17:36:10.347753 +00:00,1634.00,true,475
1656,2025-08-29 14:26:40.906576 +00:00,2025-08-29 14:34:16.906576 +00:00,8324.00,true,476
1657,2025-09-12 18:19:49.210991 +00:00,2025-09-21 09:57:04.210991 +00:00,1691.00,true,476
1658,2025-09-06 05:21:17.945798 +00:00,2025-09-16 16:57:24.945798 +00:00,3860.00,true,476
1659,2025-09-09 12:30:48.568729 +00:00,2025-09-12 19:09:26.568729 +00:00,9287.00,true,476
1660,2025-09-15 05:22:46.627594 +00:00,2025-09-17 15:12:58.627594 +00:00,10751.00,true,476
1661,2019-12-11 20:09:56.259823 +00:00,2019-12-11 20:16:59.259823 +00:00,164.00,true,477
1662,2023-06-01 02:44:52.887423 +00:00,2023-06-12 10:42:24.887423 +00:00,530.00,true,477
1663,2022-10-18 10:01:07.775871 +00:00,2022-10-22 07:36:12.775871 +00:00,86.00,true,477
1664,2019-12-13 19:34:56.532259 +00:00,2019-12-19 22:17:17.532259 +00:00,4062.00,true,477
1665,2025-07-30 20:32:03.672258 +00:00,2025-07-30 20:33:48.672258 +00:00,53995.00,true,478
1666,2025-08-10 19:33:22.631758 +00:00,2025-08-10 19:40:42.631758 +00:00,729.00,true,479
1667,2025-09-29 04:51:48.252947 +00:00,2025-10-03 23:59:46.252947 +00:00,1573.00,true,479
1668,2025-09-09 01:58:24.335290 +00:00,2025-09-13 15:48:46.335290 +00:00,513.00,true,479
1669,2025-08-20 05:20:12.673988 +00:00,2025-08-23 08:54:46.673988 +00:00,354.00,true,479
1670,2025-09-02 10:17:21.431406 +00:00,,1700.00,false,479
1671,2025-09-30 23:57:25.752770 +00:00,,908.00,false,479
1672,2019-05-25 05:39:27.437106 +00:00,2019-05-25 05:42:18.437106 +00:00,13282.00,true,480
1673,2024-03-30 18:33:54.410133 +00:00,2024-04-01 21:52:20.410133 +00:00,12864.00,true,480
1674,2025-09-08 03:01:44.990818 +00:00,2025-09-08 03:01:53.990818 +00:00,19505.00,true,481
1675,2025-09-13 19:10:46.341614 +00:00,2025-09-16 21:44:58.341614 +00:00,39830.00,true,481
1676,2025-07-08 15:37:11.493045 +00:00,2025-07-08 15:49:37.493045 +00:00,7562.00,true,482
1677,2025-07-30 21:12:50.219226 +00:00,2025-08-03 13:57:56.219226 +00:00,8377.00,true,482
1678,2025-07-14 18:40:57.463229 +00:00,2025-07-21 01:43:12.463229 +00:00,377.00,true,482
1679,2025-08-21 03:48:50.996327 +00:00,2025-08-29 00:26:49.996327 +00:00,3282.00,true,482
1680,2025-07-26 16:28:11.846721 +00:00,2025-07-28 17:31:24.846721 +00:00,6047.00,true,482
1681,2025-08-09 19:59:06.591759 +00:00,2025-08-20 21:18:04.591759 +00:00,5700.00,true,482
1682,2025-09-21 23:01:18.458018 +00:00,2025-09-21 23:02:38.458018 +00:00,4372.00,true,483
1683,2025-09-30 00:00:09.462010 +00:00,,3206.00,false,483
1684,2025-09-23 13:47:09.503530 +00:00,2025-09-24 11:13:36.503530 +00:00,6928.00,true,483
1685,2025-09-24 15:11:19.487736 +00:00,2025-10-05 05:04:27.487736 +00:00,1878.00,true,483
1686,2025-10-04 04:13:54.846092 +00:00,2025-10-04 11:03:40.846092 +00:00,4226.00,true,483
1687,2025-10-01 04:52:18.156268 +00:00,,6047.00,false,483
1688,2012-01-21 22:59:53.615448 +00:00,2012-01-21 23:15:09.615448 +00:00,887.00,true,484
1689,2018-04-20 21:38:42.512073 +00:00,,2293.00,false,484
1690,2020-07-31 22:31:59.539548 +00:00,2020-08-03 03:43:17.539548 +00:00,5684.00,true,484
1691,2015-09-12 20:28:23.050409 +00:00,2015-09-20 18:08:31.050409 +00:00,1844.00,true,484
1692,2013-05-21 17:04:47.592824 +00:00,2013-05-24 07:20:16.592824 +00:00,796.00,true,484
1693,2025-08-22 07:26:08.463207 +00:00,2025-08-22 07:39:22.463207 +00:00,37187.00,true,485
1694,2025-09-10 04:26:34.528707 +00:00,2025-09-13 04:10:39.528707 +00:00,296.00,true,485
1695,2025-08-09 03:21:08.933709 +00:00,2025-08-09 03:35:30.933709 +00:00,23899.00,true,486
1696,2016-03-25 12:03:00.969572 +00:00,2016-03-25 12:10:37.969572 +00:00,1197.00,true,487
1697,2018-09-22 04:40:55.483027 +00:00,,10620.00,false,487
1698,2017-07-16 16:13:03.275375 +00:00,2017-07-24 13:19:27.275375 +00:00,23081.00,true,487
1699,2023-01-15 11:31:47.650138 +00:00,2023-01-16 00:23:18.650138 +00:00,11692.00,true,487
1700,2018-08-19 17:24:06.720038 +00:00,2018-08-19 17:24:29.720038 +00:00,27210.00,true,488
1701,2011-10-03 22:58:59.751711 +00:00,2011-10-03 23:11:45.751711 +00:00,6813.00,true,489
1702,2017-06-19 15:08:02.638062 +00:00,2017-06-28 05:43:07.638062 +00:00,5161.00,true,489
1703,2022-10-30 16:05:16.795407 +00:00,2022-11-05 21:03:56.795407 +00:00,35575.00,true,489
1704,2013-08-19 00:07:36.267710 +00:00,2013-08-19 00:09:22.267710 +00:00,1751.00,true,490
1705,2017-10-07 16:45:52.041335 +00:00,2017-10-11 19:35:33.041335 +00:00,14557.00,true,490
1706,2018-10-31 05:36:11.730036 +00:00,2018-11-06 21:51:41.730036 +00:00,2314.00,true,490
1707,2025-03-17 09:52:24.276030 +00:00,2025-03-18 11:59:14.276030 +00:00,766.00,true,490
1708,2015-11-28 01:25:33.893311 +00:00,2015-12-04 16:57:06.893311 +00:00,4180.00,true,490
1709,2019-01-27 22:53:33.826737 +00:00,2019-01-27 23:04:13.826737 +00:00,179.00,true,491
1710,2019-10-01 00:31:32.915271 +00:00,2019-10-07 13:15:37.915271 +00:00,1872.00,true,491
1711,2025-03-05 06:16:43.902575 +00:00,2025-03-15 13:06:25.902575 +00:00,1787.00,true,491
1712,2021-05-26 02:11:12.290046 +00:00,2021-06-02 12:25:54.290046 +00:00,150.00,true,491
1713,2024-03-16 07:01:34.574773 +00:00,2024-03-22 21:22:10.574773 +00:00,11.00,true,491
1714,2024-11-12 08:06:08.158863 +00:00,2024-11-12 13:45:13.158863 +00:00,3289.00,true,491
1715,2025-08-20 13:43:14.565559 +00:00,2025-08-20 13:59:00.565559 +00:00,20203.00,true,492
1716,2025-08-21 03:51:30.235671 +00:00,2025-08-30 14:13:19.235671 +00:00,9347.00,true,492
1717,2010-04-04 11:09:45.742124 +00:00,2010-04-04 11:25:15.742124 +00:00,17293.00,true,493
1718,2014-04-04 22:04:35.506240 +00:00,2014-04-10 13:01:36.506240 +00:00,29000.00,true,493
1719,2015-11-21 16:35:44.592558 +00:00,2015-11-21 16:46:06.592558 +00:00,20178.00,true,494
1720,2016-09-19 07:45:58.075324 +00:00,2016-09-26 06:15:37.075324 +00:00,859.00,true,494
1721,2015-09-29 00:24:23.717710 +00:00,2015-09-29 00:31:30.717710 +00:00,790.00,true,495
1722,2022-01-07 00:25:20.417029 +00:00,2022-01-09 11:05:34.417029 +00:00,12570.00,true,495
1723,2019-10-31 10:49:14.679451 +00:00,2019-11-01 19:10:38.679451 +00:00,11934.00,true,495
1724,2018-12-06 04:48:35.314952 +00:00,2018-12-09 21:26:34.314952 +00:00,13533.00,true,495
1725,2020-05-30 20:49:47.927821 +00:00,2020-05-30 21:01:37.927821 +00:00,618.00,true,496
1726,2024-07-20 22:37:10.056475 +00:00,2024-07-27 03:30:36.056475 +00:00,947.00,true,496
1727,2023-02-23 03:04:11.572446 +00:00,2023-03-05 03:10:42.572446 +00:00,807.00,true,496
1728,2013-10-26 04:01:36.506932 +00:00,2013-10-26 04:04:11.506932 +00:00,3000.00,true,497
1729,2015-07-08 00:40:02.798365 +00:00,2015-07-10 00:59:52.798365 +00:00,19000.00,true,497
1730,2021-09-19 13:43:02.289546 +00:00,,21654.00,false,497
1731,2025-08-28 01:27:37.092620 +00:00,2025-08-28 01:28:03.092620 +00:00,23413.00,true,498
1732,2025-07-26 11:58:43.661996 +00:00,2025-07-26 12:09:13.661996 +00:00,4674.00,true,499
1733,2025-08-06 00:04:13.845731 +00:00,2025-08-13 12:40:38.845731 +00:00,17012.00,true,499
1734,2025-09-02 02:54:12.346433 +00:00,2025-09-08 03:27:28.346433 +00:00,608.00,true,499
1735,2025-10-03 19:35:26.732307 +00:00,,2221.00,false,499
1736,2017-07-15 02:37:52.850087 +00:00,2017-07-15 02:40:40.850087 +00:00,15001.00,true,500
1737,2018-08-11 04:40:50.942065 +00:00,2018-08-12 21:10:16.942065 +00:00,31901.00,true,500
1738,2025-09-17 03:36:18.781087 +00:00,2025-09-17 03:39:47.781087 +00:00,1455.00,true,501
1739,2025-09-19 07:03:18.753161 +00:00,2025-09-25 01:55:41.753161 +00:00,427.00,true,501
1740,2025-09-24 09:25:28.760437 +00:00,2025-09-27 14:54:00.760437 +00:00,2044.00,true,501
1741,2025-09-20 17:27:59.706913 +00:00,2025-09-29 03:34:07.706913 +00:00,295.00,true,501
1742,2025-09-28 09:37:20.009428 +00:00,2025-09-29 02:01:59.009428 +00:00,1107.00,true,501
1743,2015-11-03 19:07:33.766556 +00:00,2015-11-03 19:20:59.766556 +00:00,8693.00,true,502
1744,2020-03-02 14:47:48.543616 +00:00,2020-03-07 21:23:58.543616 +00:00,54.00,true,502
1745,2018-02-24 09:58:34.238057 +00:00,2018-02-27 01:03:03.238057 +00:00,8147.00,true,502
1746,2016-05-04 14:21:50.903366 +00:00,2016-05-04 14:27:24.903366 +00:00,921.00,true,503
1747,2024-08-15 08:55:56.735768 +00:00,2024-08-25 10:03:37.735768 +00:00,562.00,true,503
1748,2024-02-02 19:18:08.234843 +00:00,2024-02-03 03:26:13.234843 +00:00,1217.00,true,503
1749,2011-01-09 22:34:23.595780 +00:00,2011-01-09 22:35:06.595780 +00:00,4991.00,true,504
1750,2021-11-28 03:13:21.258484 +00:00,2021-12-05 22:29:17.258484 +00:00,6037.00,true,504
1751,2012-04-21 06:08:40.295153 +00:00,,4546.00,false,504
1752,2015-05-02 06:18:49.004001 +00:00,2015-05-02 13:04:22.004001 +00:00,511.00,true,504
1753,2011-05-17 03:23:32.930429 +00:00,2011-05-27 04:15:16.930429 +00:00,6097.00,true,504
1754,2011-06-23 03:12:28.142243 +00:00,2011-07-03 05:59:44.142243 +00:00,10467.00,true,504
1755,2012-07-20 05:41:30.016205 +00:00,2012-07-20 05:48:24.016205 +00:00,422.00,true,505
1756,2019-08-08 08:06:29.356206 +00:00,2019-08-08 08:07:41.356206 +00:00,906.00,true,506
1757,2019-10-06 07:57:43.340359 +00:00,2019-10-13 09:33:24.340359 +00:00,3721.00,true,506
1758,2025-07-02 07:25:27.501953 +00:00,2025-07-02 07:37:40.501953 +00:00,448.00,true,507
1759,2025-09-13 23:19:27.337133 +00:00,,15440.00,false,507
1760,2025-09-05 15:40:26.881284 +00:00,2025-09-14 06:49:38.881284 +00:00,1064.00,true,507
1761,2025-09-27 15:40:46.199076 +00:00,2025-10-01 03:50:44.199076 +00:00,55.00,true,507
1762,2025-07-30 13:46:42.969474 +00:00,2025-08-05 18:49:42.969474 +00:00,10019.00,true,507
1763,2025-07-30 14:03:45.374608 +00:00,2025-08-06 08:19:56.374608 +00:00,2942.00,true,507
1764,2025-09-11 20:20:24.818503 +00:00,2025-09-11 20:22:26.818503 +00:00,8006.00,true,508
1765,2025-09-19 03:24:16.417531 +00:00,2025-09-20 12:16:15.417531 +00:00,752.00,true,508
1766,2025-09-27 22:11:51.218443 +00:00,2025-10-04 19:48:16.218443 +00:00,1595.00,true,508
1767,2022-09-23 17:37:01.734445 +00:00,2022-09-23 17:48:30.734445 +00:00,11726.00,true,509
1768,2025-06-18 04:11:53.528029 +00:00,2025-06-23 14:37:26.528029 +00:00,34015.00,true,509
1769,2025-07-16 13:16:03.969781 +00:00,2025-07-16 13:23:58.969781 +00:00,8134.00,true,510
1770,2025-08-08 18:53:47.608007 +00:00,2025-08-12 04:43:38.608007 +00:00,25199.00,true,510
1771,2025-08-23 20:59:15.455369 +00:00,2025-09-02 06:57:09.455369 +00:00,490.00,true,510
1772,2025-09-12 12:13:54.584875 +00:00,2025-09-16 00:54:22.584875 +00:00,6549.00,true,510
1773,2025-09-15 20:14:35.021541 +00:00,2025-09-20 12:06:21.021541 +00:00,9630.00,true,510
1774,2025-09-01 06:36:36.261961 +00:00,2025-09-01 06:47:21.261961 +00:00,39.00,true,511
1775,2025-09-06 13:11:57.699980 +00:00,2025-09-16 09:42:55.699980 +00:00,5453.00,true,511
1776,2025-09-30 06:06:05.613307 +00:00,,6962.00,false,511
1777,2025-09-09 22:34:01.244586 +00:00,2025-09-12 19:31:07.244586 +00:00,20294.00,true,511
1778,2018-08-28 17:39:59.285760 +00:00,2018-08-28 17:55:32.285760 +00:00,43949.00,true,512
1779,2016-11-03 23:49:22.666737 +00:00,2016-11-03 23:56:21.666737 +00:00,3.00,true,513
1780,2021-04-20 22:26:51.237127 +00:00,2021-04-25 04:54:00.237127 +00:00,4423.00,true,513
1781,2024-11-13 03:36:29.040193 +00:00,2024-11-14 17:31:47.040193 +00:00,5819.00,true,513
1782,2020-05-29 17:27:28.315856 +00:00,2020-06-09 19:35:38.315856 +00:00,33721.00,true,513
1783,2015-07-18 10:57:18.457397 +00:00,2015-07-18 11:13:15.457397 +00:00,123.00,true,514
1784,2023-07-21 17:15:36.720999 +00:00,2023-07-23 11:22:01.720999 +00:00,10365.00,true,514
1785,2015-08-15 03:27:13.973915 +00:00,2015-08-16 01:28:40.973915 +00:00,1871.00,true,514
1786,2025-09-19 11:11:14.880605 +00:00,2025-09-19 11:18:44.880605 +00:00,835.00,true,515
1787,2025-09-19 12:36:31.023997 +00:00,2025-09-27 04:49:39.023997 +00:00,1122.00,true,515
1788,2025-10-04 06:39:17.423015 +00:00,,1670.00,false,515
1789,2025-09-01 18:35:10.405347 +00:00,2025-09-01 18:35:42.405347 +00:00,36.00,true,516
1790,2025-10-01 12:11:36.586142 +00:00,,9334.00,false,516
1791,2025-09-13 18:30:12.608384 +00:00,,41577.00,false,516
1792,2025-09-09 20:14:43.217647 +00:00,2025-09-09 20:14:55.217647 +00:00,59354.00,true,517
1793,2011-10-25 01:02:56.769226 +00:00,2011-10-25 01:14:11.769226 +00:00,26275.00,true,518
1794,2015-04-10 04:43:07.288271 +00:00,2015-04-12 15:36:29.288271 +00:00,28155.00,true,518
1795,2016-05-01 13:57:37.466106 +00:00,2016-05-01 13:58:53.466106 +00:00,1712.00,true,519
1796,2017-04-03 08:41:13.360533 +00:00,2017-04-11 04:20:30.360533 +00:00,23472.00,true,519
1797,2019-07-10 12:14:20.134548 +00:00,2019-07-18 07:14:49.134548 +00:00,34530.00,true,519
1798,2022-12-29 10:56:22.350352 +00:00,2022-12-31 17:24:05.350352 +00:00,2598.00,true,519
1799,2022-10-28 07:49:56.790433 +00:00,2022-10-28 07:55:49.790433 +00:00,20801.00,true,520
1800,2024-10-14 01:12:13.776988 +00:00,2024-10-20 03:06:35.776988 +00:00,5274.00,true,520
1801,2024-12-16 12:17:20.642134 +00:00,2024-12-23 23:49:05.642134 +00:00,28960.00,true,520
1802,2021-03-18 06:05:10.993063 +00:00,2021-03-18 06:19:59.993063 +00:00,34698.00,true,521
1803,2017-11-24 21:41:15.457145 +00:00,2017-11-24 21:50:53.457145 +00:00,3495.00,true,522
1804,2024-05-16 03:31:39.930088 +00:00,2024-05-20 15:59:13.930088 +00:00,6076.00,true,522
1805,2020-11-13 07:45:59.407087 +00:00,2020-11-22 02:12:19.407087 +00:00,19445.00,true,522
1806,2020-04-23 14:22:31.752187 +00:00,2020-04-26 05:54:25.752187 +00:00,3751.00,true,522
1807,2018-04-21 06:05:19.488706 +00:00,2018-04-21 06:10:20.488706 +00:00,13.00,true,523
1808,2023-05-02 14:13:02.520930 +00:00,2023-05-10 23:20:35.520930 +00:00,49.00,true,523
1809,2021-05-12 14:45:15.345497 +00:00,2021-05-22 17:53:43.345497 +00:00,641.00,true,523
1810,2023-11-29 08:23:54.590333 +00:00,2023-12-07 08:14:03.590333 +00:00,784.00,true,523
1811,2020-05-18 11:50:47.374366 +00:00,2020-05-22 18:44:35.374366 +00:00,4080.00,true,523
1812,2014-08-09 04:59:14.063522 +00:00,2014-08-09 05:06:08.063522 +00:00,5508.00,true,524
1813,2019-10-07 08:59:25.627944 +00:00,2019-10-16 19:51:17.627944 +00:00,1934.00,true,524
1814,2021-12-23 23:52:06.758397 +00:00,2022-01-04 00:11:12.758397 +00:00,4940.00,true,524
1815,2020-04-30 17:58:17.650586 +00:00,2020-05-04 23:17:55.650586 +00:00,7541.00,true,524
1816,2022-06-18 12:29:10.058167 +00:00,2022-06-21 10:39:05.058167 +00:00,2274.00,true,524
1817,2017-05-08 19:12:10.009602 +00:00,2017-05-19 21:29:55.009602 +00:00,2612.00,true,524
1818,2025-07-17 02:15:26.112393 +00:00,2025-07-17 02:23:50.112393 +00:00,6495.00,true,525
1819,2025-10-01 21:33:59.385691 +00:00,,5255.00,false,525
1820,2025-07-19 17:51:48.860533 +00:00,2025-07-25 11:36:11.860533 +00:00,6561.00,true,525
1821,2011-07-27 17:39:16.920741 +00:00,2011-07-27 17:54:29.920741 +00:00,16960.00,true,526
1822,2021-11-15 07:28:26.635624 +00:00,2021-11-15 20:41:01.635624 +00:00,2104.00,true,526
1823,2016-12-27 11:29:09.382121 +00:00,,14246.00,false,526
1824,2015-07-10 11:11:50.204624 +00:00,2015-07-10 11:15:56.204624 +00:00,16694.00,true,527
1825,2025-08-13 18:21:49.395949 +00:00,2025-08-17 10:32:29.395949 +00:00,20244.00,true,527
1826,2012-10-01 10:46:36.615410 +00:00,2012-10-01 10:50:32.615410 +00:00,8274.00,true,528
1827,2019-12-08 07:58:20.026702 +00:00,2019-12-08 08:05:27.026702 +00:00,8383.00,true,529
1828,2023-07-12 23:39:05.285373 +00:00,2023-07-20 08:01:31.285373 +00:00,28626.00,true,529
1829,2020-05-08 15:20:01.912556 +00:00,2020-05-20 03:04:23.912556 +00:00,6471.00,true,529
1830,2024-04-21 12:24:45.031970 +00:00,2024-04-21 12:31:07.031970 +00:00,1197.00,true,530
1831,2024-05-05 22:35:19.393161 +00:00,2024-05-10 13:59:19.393161 +00:00,17259.00,true,530
1832,2024-08-24 01:43:00.968670 +00:00,2024-08-31 17:39:01.968670 +00:00,17098.00,true,530
1833,2022-06-20 23:47:41.855226 +00:00,2022-06-21 00:02:24.855226 +00:00,418.00,true,531
1834,2022-11-07 23:40:51.666923 +00:00,2022-11-17 15:07:26.666923 +00:00,5961.00,true,531
1835,2024-11-08 00:45:36.934556 +00:00,2024-11-09 21:23:19.934556 +00:00,5099.00,true,531
1836,2025-06-03 15:42:32.699893 +00:00,2025-06-06 05:37:48.699893 +00:00,881.00,true,531
1837,2023-08-26 03:39:18.594939 +00:00,2023-08-30 02:24:30.594939 +00:00,3509.00,true,531
1838,2025-07-13 22:06:42.220935 +00:00,2025-07-13 22:18:33.220935 +00:00,5287.00,true,532
1839,2025-08-18 15:47:25.547328 +00:00,2025-08-25 08:02:03.547328 +00:00,5449.00,true,532
1840,2025-09-16 01:34:34.033390 +00:00,2025-09-25 21:35:43.033390 +00:00,5252.00,true,532
1841,2025-09-20 20:44:05.974661 +00:00,2025-09-28 12:27:42.974661 +00:00,824.00,true,532
1842,2023-10-03 11:39:22.929032 +00:00,2023-10-03 11:50:23.929032 +00:00,24459.00,true,533
1843,2024-11-18 08:27:03.981690 +00:00,2024-11-23 03:02:44.981690 +00:00,3777.00,true,533
1844,2025-10-01 18:03:35.187973 +00:00,,3243.00,false,533
1845,2022-01-30 17:24:06.058501 +00:00,2022-01-30 17:26:26.058501 +00:00,4408.00,true,534
1846,2025-08-08 18:47:09.843610 +00:00,2025-08-18 16:00:09.843610 +00:00,10599.00,true,534
1847,2023-04-12 01:51:43.156919 +00:00,2023-04-23 05:55:16.156919 +00:00,7119.00,true,534
1848,2025-08-31 02:04:10.243476 +00:00,2025-08-31 02:06:28.243476 +00:00,1297.00,true,535
1849,2025-09-30 00:02:12.555072 +00:00,2025-10-04 12:53:11.555072 +00:00,2914.00,true,535
1850,2025-09-30 06:48:12.688476 +00:00,,23764.00,false,535
1851,2025-09-06 15:55:59.823239 +00:00,,7088.00,false,535
1852,2025-09-10 15:18:51.987395 +00:00,2025-09-16 03:14:49.987395 +00:00,186.00,true,535
1853,2025-09-01 08:48:28.453131 +00:00,2025-09-09 08:17:26.453131 +00:00,23609.00,true,535
1854,2010-11-20 16:07:54.373407 +00:00,2010-11-20 16:23:10.373407 +00:00,24704.00,true,536
1855,2013-10-28 06:47:04.742812 +00:00,,1953.00,false,536
1856,2011-08-24 08:33:43.654332 +00:00,2011-08-24 08:49:29.654332 +00:00,561.00,true,537
1857,2014-08-04 00:56:18.814394 +00:00,2014-08-13 03:06:04.814394 +00:00,9579.00,true,537
1858,2023-07-22 21:06:12.018580 +00:00,2023-07-23 06:16:51.018580 +00:00,4236.00,true,537
1859,2025-08-23 13:26:58.487185 +00:00,2025-08-23 13:43:18.487185 +00:00,8689.00,true,538
1860,2025-10-01 14:50:42.743329 +00:00,2025-10-01 14:53:11.743329 +00:00,3569.00,true,539
1861,2025-10-02 09:43:21.852256 +00:00,2025-10-04 22:40:31.852256 +00:00,6.00,true,539
1862,2025-10-04 22:04:38.431151 +00:00,2025-10-05 22:11:58.431151 +00:00,3712.00,true,539
1863,2025-10-03 06:23:40.342746 +00:00,,11767.00,false,539
1864,2025-10-04 11:35:52.790395 +00:00,,11.00,false,539
1865,2025-10-02 17:34:32.543196 +00:00,,5215.00,false,539
1866,2025-01-04 04:38:18.903112 +00:00,2025-01-04 04:43:32.903112 +00:00,4421.00,true,540
1867,2025-06-20 09:31:16.319617 +00:00,2025-06-22 13:49:09.319617 +00:00,10353.00,true,540
1868,2025-06-02 17:39:29.074005 +00:00,2025-06-08 05:44:01.074005 +00:00,1020.00,true,540
1869,2025-06-02 08:28:28.464560 +00:00,2025-06-04 20:07:45.464560 +00:00,357.00,true,540
1870,2025-09-10 09:37:03.638311 +00:00,2025-09-17 23:10:03.638311 +00:00,4695.00,true,540
1871,2016-02-09 05:15:00.306536 +00:00,2016-02-09 05:30:23.306536 +00:00,7818.00,true,541
1872,2019-01-11 07:40:29.508768 +00:00,2019-01-15 06:36:41.508768 +00:00,27868.00,true,541
1873,2021-04-06 05:49:32.751276 +00:00,2021-04-16 07:20:03.751276 +00:00,5514.00,true,541
1874,2017-10-05 16:30:56.137491 +00:00,,2336.00,false,541
1875,2025-07-05 02:09:36.190020 +00:00,2025-07-05 02:15:04.190020 +00:00,1767.00,true,542
1876,2025-09-13 17:34:11.519443 +00:00,2025-09-23 03:35:30.519443 +00:00,2751.00,true,542
1877,2025-09-26 16:45:54.391748 +00:00,,11098.00,false,542
1878,2025-07-19 02:10:39.633071 +00:00,2025-07-20 08:38:50.633071 +00:00,13468.00,true,542
1879,2025-08-05 10:41:06.950995 +00:00,2025-08-11 13:39:48.950995 +00:00,14209.00,true,542
1880,2025-07-23 00:06:04.866857 +00:00,2025-07-23 05:54:53.866857 +00:00,3514.00,true,542
1881,2024-05-22 05:29:13.078524 +00:00,2024-05-22 05:33:52.078524 +00:00,14844.00,true,543
1882,2024-06-29 20:41:44.210902 +00:00,2024-07-01 09:43:04.210902 +00:00,3638.00,true,543
1883,2024-09-20 00:08:37.765606 +00:00,2024-09-22 13:37:02.765606 +00:00,23138.00,true,543
1884,2025-06-04 17:31:31.265147 +00:00,2025-06-05 09:00:03.265147 +00:00,27538.00,true,543
1885,2015-08-17 14:36:42.637755 +00:00,2015-08-17 14:40:26.637755 +00:00,1516.00,true,544
1886,2016-09-10 21:16:11.487102 +00:00,2016-09-16 01:47:39.487102 +00:00,12198.00,true,544
1887,2024-07-19 06:30:21.709768 +00:00,2024-07-19 06:39:57.709768 +00:00,2034.00,true,545
1888,2025-01-20 06:31:16.380173 +00:00,2025-01-31 16:46:08.380173 +00:00,8712.00,true,545
1889,2025-09-02 15:35:47.479950 +00:00,2025-09-06 20:45:38.479950 +00:00,23336.00,true,545
1890,2025-08-15 18:06:07.341846 +00:00,2025-08-23 07:38:50.341846 +00:00,14466.00,true,545
1891,2025-08-08 04:37:35.273404 +00:00,2025-08-19 08:46:40.273404 +00:00,1959.00,true,545
1892,2025-08-29 00:41:22.580098 +00:00,2025-08-29 00:44:17.580098 +00:00,6556.00,true,546
1893,2025-09-09 20:08:07.891268 +00:00,2025-09-16 23:27:17.891268 +00:00,17246.00,true,546
1894,2025-09-14 10:45:04.176598 +00:00,2025-09-19 14:07:46.176598 +00:00,14466.00,true,546
1895,2025-08-05 09:20:22.930808 +00:00,2025-08-05 09:24:50.930808 +00:00,1831.00,true,547
1896,2025-09-07 22:31:41.000460 +00:00,2025-09-14 12:09:39.000460 +00:00,8639.00,true,547
1897,2020-03-18 13:00:05.072605 +00:00,2020-03-18 13:14:40.072605 +00:00,1415.00,true,548
1898,2020-11-01 13:00:48.568845 +00:00,2020-11-08 03:20:36.568845 +00:00,7472.00,true,548
1899,2020-11-06 16:29:29.483191 +00:00,2020-11-09 18:59:27.483191 +00:00,1765.00,true,548
1900,2025-02-07 14:30:54.217005 +00:00,2025-02-18 22:05:34.217005 +00:00,20667.00,true,548
1901,2021-04-15 19:27:36.741455 +00:00,2021-04-15 19:43:59.741455 +00:00,1124.00,true,549
1902,2022-05-05 11:02:24.887322 +00:00,2022-05-06 10:27:36.887322 +00:00,1880.00,true,549
1903,2024-12-24 17:01:27.820528 +00:00,2024-12-27 13:40:44.820528 +00:00,497.00,true,549
1904,2025-08-10 15:07:20.941597 +00:00,2025-08-10 15:23:07.941597 +00:00,28303.00,true,550
1905,2020-07-23 23:43:31.596792 +00:00,2020-07-23 23:44:11.596792 +00:00,14134.00,true,551
1906,2025-09-16 01:19:27.909377 +00:00,2025-09-19 02:21:27.909377 +00:00,13286.00,true,551
1907,2024-01-20 13:01:26.435530 +00:00,2024-01-20 13:06:46.435530 +00:00,3873.00,true,552
1908,2025-05-12 13:10:22.802538 +00:00,2025-05-18 17:39:15.802538 +00:00,60.00,true,552
1909,2025-04-20 11:21:30.321820 +00:00,2025-04-22 06:19:48.321820 +00:00,4182.00,true,552
1910,2025-09-17 03:32:43.955962 +00:00,2025-09-17 03:33:30.955962 +00:00,63154.00,true,553
1911,2020-04-19 03:43:27.837887 +00:00,2020-04-19 03:54:35.837887 +00:00,10432.00,true,554
1912,2023-09-08 00:13:50.785149 +00:00,2023-09-09 19:53:16.785149 +00:00,7209.00,true,554
1913,2021-10-11 10:02:32.845167 +00:00,2021-10-14 22:55:43.845167 +00:00,7689.00,true,554
1914,2022-12-13 10:41:32.288121 +00:00,2022-12-19 04:35:37.288121 +00:00,4661.00,true,554
1915,2019-01-05 18:18:51.574742 +00:00,2019-01-05 18:33:45.574742 +00:00,13234.00,true,555
1916,2023-04-15 06:34:32.878755 +00:00,,4131.00,false,555
1917,2015-11-04 07:43:36.780640 +00:00,2015-11-04 07:57:54.780640 +00:00,2358.00,true,556
1918,2011-05-13 04:56:45.547548 +00:00,2011-05-13 04:58:36.547548 +00:00,28461.00,true,557
1919,2013-01-18 23:51:35.034798 +00:00,2013-01-19 00:03:36.034798 +00:00,39155.00,true,558
1920,2022-04-26 00:24:50.047377 +00:00,2022-05-05 11:05:05.047377 +00:00,7867.00,true,558
1921,2016-08-26 09:36:10.942908 +00:00,2016-08-28 12:12:02.942908 +00:00,718.00,true,558
1922,2013-08-31 01:05:42.841156 +00:00,2013-09-08 07:14:02.841156 +00:00,9017.00,true,558
1923,2014-02-20 11:21:20.715553 +00:00,2014-02-20 11:33:51.715553 +00:00,10692.00,true,559
1924,2017-10-20 15:21:14.017360 +00:00,2017-10-30 04:06:59.017360 +00:00,18201.00,true,559
1925,2023-07-19 16:30:50.676404 +00:00,2023-07-29 03:11:38.676404 +00:00,1014.00,true,559
1926,2025-08-26 22:34:29.679569 +00:00,2025-08-26 22:48:26.679569 +00:00,878.00,true,560
1927,2025-09-07 20:29:19.061642 +00:00,2025-09-11 16:16:31.061642 +00:00,552.00,true,560
1928,2025-10-04 17:58:07.752697 +00:00,,962.00,false,560
1929,2025-09-07 17:45:54.727496 +00:00,2025-09-12 01:20:18.727496 +00:00,1162.00,true,560
1930,2025-09-17 21:11:56.551139 +00:00,2025-09-29 02:56:46.551139 +00:00,327.00,true,560
1931,2025-09-07 23:53:34.697043 +00:00,2025-09-09 12:10:17.697043 +00:00,154.00,true,560
1932,2025-07-19 07:20:32.322535 +00:00,2025-07-19 07:29:39.322535 +00:00,1212.00,true,561
1933,2025-09-08 00:41:20.065834 +00:00,2025-09-14 18:15:03.065834 +00:00,4839.00,true,561
1934,2025-09-22 11:20:01.110260 +00:00,2025-10-02 21:02:22.110260 +00:00,4597.00,true,561
1935,2025-09-03 07:44:04.974414 +00:00,2025-09-14 17:09:46.974414 +00:00,6608.00,true,561
1936,2025-10-01 12:58:32.180485 +00:00,,19112.00,false,561
1937,2013-07-17 05:39:49.401228 +00:00,2013-07-17 05:53:57.401228 +00:00,11304.00,true,562
1938,2014-04-28 04:43:58.814913 +00:00,2014-05-08 04:26:18.814913 +00:00,14181.00,true,562
1939,2016-08-05 03:42:31.248127 +00:00,2016-08-05 03:45:52.248127 +00:00,10538.00,true,563
1940,2018-05-05 01:10:57.773507 +00:00,2018-05-09 15:52:44.773507 +00:00,6699.00,true,563
1941,2025-08-14 17:53:33.845887 +00:00,2025-08-18 14:44:37.845887 +00:00,10392.00,true,563
1942,2024-01-24 00:59:40.021217 +00:00,2024-01-30 23:12:19.021217 +00:00,30760.00,true,563
1943,2017-01-22 18:57:07.186422 +00:00,2017-01-29 04:50:29.186422 +00:00,4050.00,true,563
1944,2012-07-25 15:20:21.947783 +00:00,2012-07-25 15:31:45.947783 +00:00,467.00,true,564
1945,2018-05-12 17:02:44.084016 +00:00,2018-05-17 01:48:53.084016 +00:00,230.00,true,564
1946,2020-07-21 06:17:02.921194 +00:00,2020-07-25 13:57:38.921194 +00:00,799.00,true,564
1947,2020-05-12 04:20:25.953019 +00:00,2020-05-18 15:10:56.953019 +00:00,2191.00,true,564
1948,2020-04-25 13:43:02.661180 +00:00,2020-05-03 05:09:30.661180 +00:00,296.00,true,564
1949,2014-05-20 14:27:26.688676 +00:00,2014-05-20 15:57:03.688676 +00:00,3951.00,true,564
1950,2025-08-25 05:47:53.449430 +00:00,2025-08-25 06:01:07.449430 +00:00,37848.00,true,565
1951,2025-09-02 16:45:04.745039 +00:00,2025-09-05 15:22:20.745039 +00:00,3496.00,true,565
1952,2025-10-03 08:28:01.851139 +00:00,,1101.00,false,565
1953,2025-09-22 05:23:10.815127 +00:00,2025-09-30 19:45:01.815127 +00:00,17962.00,true,565
1954,2025-10-02 19:45:06.237781 +00:00,2025-10-02 19:48:31.237781 +00:00,860.00,true,566
1955,2025-10-03 18:35:49.243670 +00:00,,7405.00,false,566
1956,2025-10-03 06:31:25.512218 +00:00,2025-10-04 22:31:31.512218 +00:00,26312.00,true,566
1957,2017-03-21 06:07:04.519201 +00:00,2017-03-21 06:22:55.519201 +00:00,1660.00,true,567
1958,2024-12-01 20:52:20.871318 +00:00,,3929.00,false,567
1959,2022-11-25 13:47:31.808485 +00:00,2022-12-05 10:31:22.808485 +00:00,275.00,true,567
1960,2024-12-20 02:24:22.929458 +00:00,2024-12-28 02:16:15.929458 +00:00,1883.00,true,567
1961,2017-12-01 16:22:09.582256 +00:00,2017-12-02 09:06:27.582256 +00:00,812.00,true,567
1962,2025-07-17 05:38:39.382885 +00:00,2025-07-21 11:53:17.382885 +00:00,849.00,true,567
1963,2011-06-09 16:53:24.650532 +00:00,2011-06-09 16:54:10.650532 +00:00,40689.00,true,568
1964,2019-07-21 04:59:08.257824 +00:00,2019-07-21 05:09:04.257824 +00:00,9469.00,true,569
1965,2025-06-24 15:06:12.972658 +00:00,2025-07-05 09:52:55.972658 +00:00,6792.00,true,569
1966,2025-09-13 19:38:54.946907 +00:00,2025-09-13 19:43:53.946907 +00:00,4754.00,true,570
1967,2025-09-30 00:46:32.567791 +00:00,,3425.00,false,570
1968,2025-09-18 16:19:29.327366 +00:00,2025-09-21 06:27:28.327366 +00:00,2507.00,true,570
1969,2025-09-16 21:02:03.819641 +00:00,2025-09-23 03:41:16.819641 +00:00,878.00,true,570
1970,2025-09-21 07:37:27.720078 +00:00,2025-09-23 10:18:18.720078 +00:00,10883.00,true,570
1971,2025-09-24 06:50:22.656897 +00:00,2025-09-24 07:04:14.656897 +00:00,738.00,true,571
1972,2025-10-02 17:32:13.763985 +00:00,,1282.00,false,571
1973,2025-09-28 16:53:00.726115 +00:00,2025-10-02 23:39:25.726115 +00:00,2086.00,true,571
1974,2025-10-01 02:12:39.071348 +00:00,2025-10-01 15:22:08.071348 +00:00,5448.00,true,571
1975,2025-10-03 09:09:03.272869 +00:00,2025-10-06 04:24:53.272869 +00:00,2400.00,true,571
1976,2025-10-01 06:05:27.983760 +00:00,2025-10-05 01:51:58.983760 +00:00,789.00,true,571
1977,2025-08-23 15:50:09.634751 +00:00,2025-08-23 15:52:03.634751 +00:00,1051.00,true,572
1978,2025-09-11 02:51:56.216275 +00:00,2025-09-14 02:40:43.216275 +00:00,6992.00,true,572
1979,2025-10-03 14:18:59.798614 +00:00,,43605.00,false,572
1980,2010-01-03 13:33:00.587082 +00:00,2010-01-03 13:36:07.587082 +00:00,3968.00,true,573
1981,2010-07-05 08:12:31.401497 +00:00,2010-07-14 12:26:43.401497 +00:00,9585.00,true,573
1982,2012-11-09 02:57:43.767303 +00:00,2012-11-19 03:43:47.767303 +00:00,3600.00,true,573
1983,2020-01-29 04:04:33.051029 +00:00,2020-01-29 04:20:50.051029 +00:00,782.00,true,574
1984,2023-01-19 21:21:07.766442 +00:00,2023-01-27 09:12:35.766442 +00:00,4314.00,true,574
1985,2024-07-02 11:21:16.115266 +00:00,2024-07-06 06:24:29.115266 +00:00,3408.00,true,574
1986,2023-11-09 09:27:50.893384 +00:00,2023-11-20 13:46:22.893384 +00:00,8282.00,true,574
1987,2023-08-04 22:31:50.313052 +00:00,2023-08-07 03:44:40.313052 +00:00,4151.00,true,574
1988,2022-11-27 23:55:11.830240 +00:00,2022-12-06 20:50:38.830240 +00:00,1184.00,true,574
1989,2025-09-10 21:39:42.585604 +00:00,2025-09-10 21:53:03.585604 +00:00,6197.00,true,575
1990,2025-09-12 19:56:42.383606 +00:00,2025-09-16 21:39:37.383606 +00:00,17177.00,true,575
1991,2010-04-01 11:44:04.766460 +00:00,2010-04-01 11:48:07.766460 +00:00,10292.00,true,576
1992,2012-07-15 11:11:04.928883 +00:00,2012-07-16 00:45:37.928883 +00:00,14550.00,true,576
1993,2018-07-19 15:36:39.051809 +00:00,,15623.00,false,576
1994,2022-08-13 16:13:10.934162 +00:00,2022-08-13 16:14:30.934162 +00:00,32492.00,true,577
1995,2012-03-16 11:47:39.623184 +00:00,2012-03-16 11:56:59.623184 +00:00,27054.00,true,578
1996,2016-11-15 08:27:45.786401 +00:00,2016-11-18 04:34:57.786401 +00:00,14313.00,true,578
1997,2025-06-20 21:26:30.766350 +00:00,2025-06-28 05:41:22.766350 +00:00,606.00,true,578
1998,2018-05-15 12:17:36.736175 +00:00,2018-05-21 06:57:18.736175 +00:00,12951.00,true,578
1999,2025-07-25 00:18:52.468022 +00:00,2025-07-25 00:35:14.468022 +00:00,10290.00,true,579
2000,2025-10-01 00:35:34.303955 +00:00,2025-10-01 22:29:52.303955 +00:00,4326.00,true,579
2001,2025-08-15 15:13:35.842589 +00:00,2025-08-21 15:58:53.842589 +00:00,163.00,true,579
2002,2025-07-06 13:27:57.925133 +00:00,2025-07-06 13:33:54.925133 +00:00,460.00,true,580
2003,2025-09-17 18:29:42.368124 +00:00,2025-09-26 10:01:52.368124 +00:00,885.00,true,580
2004,2025-09-22 03:38:36.594407 +00:00,,1452.00,false,580
2005,2025-09-07 09:39:54.123969 +00:00,2025-09-12 21:52:57.123969 +00:00,52.00,true,580
2006,2025-09-27 14:42:32.761566 +00:00,2025-09-30 09:07:15.761566 +00:00,1533.00,true,580
2007,2025-08-21 23:04:08.017705 +00:00,2025-08-22 21:12:54.017705 +00:00,1543.00,true,580
2008,2025-07-30 19:06:36.646211 +00:00,2025-07-30 19:15:58.646211 +00:00,17934.00,true,581
2009,2025-08-13 21:02:40.438688 +00:00,2025-08-21 23:10:59.438688 +00:00,4044.00,true,581
2010,2015-06-11 23:45:15.708367 +00:00,2015-06-11 23:50:38.708367 +00:00,13655.00,true,582
2011,2016-05-17 02:23:59.925037 +00:00,2016-05-26 17:28:28.925037 +00:00,2545.00,true,582
2012,2023-09-16 03:54:51.660441 +00:00,2023-09-17 22:14:55.660441 +00:00,18510.00,true,582
2013,2024-07-10 23:54:44.569739 +00:00,2024-07-15 17:16:04.569739 +00:00,16200.00,true,582
2014,2024-12-23 05:28:53.170414 +00:00,2024-12-24 21:54:51.170414 +00:00,4021.00,true,582
2015,2018-06-02 21:32:54.710168 +00:00,2018-06-09 18:07:35.710168 +00:00,4788.00,true,582
2016,2021-12-21 17:38:06.019156 +00:00,2021-12-21 17:46:03.019156 +00:00,4546.00,true,583
2017,2023-09-27 11:08:09.968754 +00:00,2023-10-05 23:47:56.968754 +00:00,2505.00,true,583
2018,2024-03-07 07:25:22.367049 +00:00,2024-03-17 03:12:17.367049 +00:00,1263.00,true,583
2019,2023-09-28 13:49:41.528262 +00:00,2023-10-09 08:08:39.528262 +00:00,1833.00,true,583
2020,2024-03-11 13:21:47.768612 +00:00,2024-03-11 16:28:30.768612 +00:00,392.00,true,583
2021,2020-11-21 19:13:56.848200 +00:00,2020-11-21 19:16:50.848200 +00:00,4609.00,true,584
2022,2021-02-21 17:04:31.734776 +00:00,2021-02-26 14:46:01.734776 +00:00,10378.00,true,584
2023,2022-09-02 19:03:57.473979 +00:00,2022-09-06 09:19:31.473979 +00:00,17929.00,true,584
2024,2025-07-15 01:03:38.672219 +00:00,2025-07-15 01:10:01.672219 +00:00,813.00,true,585
2025,2025-09-14 18:32:17.344342 +00:00,2025-09-18 13:20:54.344342 +00:00,212.00,true,585
2026,2025-08-30 14:17:15.503981 +00:00,2025-08-30 14:23:31.503981 +00:00,1211.00,true,585
2027,2025-09-05 03:48:21.428441 +00:00,2025-09-07 10:38:42.428441 +00:00,904.00,true,585
2028,2025-07-21 16:13:09.984421 +00:00,2025-07-23 23:23:05.984421 +00:00,42.00,true,585
2029,2025-07-11 17:48:38.294348 +00:00,2025-07-11 18:02:10.294348 +00:00,2048.00,true,586
2030,2025-07-18 01:40:33.608073 +00:00,2025-07-25 11:20:47.608073 +00:00,34.00,true,586
2031,2025-08-30 08:51:29.614782 +00:00,2025-08-31 19:27:06.614782 +00:00,5827.00,true,586
2032,2013-07-05 04:56:09.323603 +00:00,2013-07-05 05:02:32.323603 +00:00,405.00,true,587
2033,2024-02-07 20:15:09.721039 +00:00,,125.00,false,587
2034,2023-10-12 04:53:22.407171 +00:00,2023-10-17 14:50:21.407171 +00:00,292.00,true,587
2035,2014-02-05 00:25:55.493269 +00:00,2014-02-05 00:28:00.493269 +00:00,2525.00,true,588
2036,2016-09-10 07:53:15.372933 +00:00,2016-09-11 12:31:59.372933 +00:00,275.00,true,588
2037,2021-07-25 12:09:01.108273 +00:00,2021-08-04 05:46:41.108273 +00:00,4364.00,true,588
2038,2025-09-10 09:17:02.829966 +00:00,2025-09-10 09:33:19.829966 +00:00,5161.00,true,589
2039,2025-10-03 09:45:35.518265 +00:00,,53411.00,false,589
2040,2025-10-02 20:44:46.917305 +00:00,,2958.00,false,589
2041,2025-09-18 04:07:20.171960 +00:00,2025-09-29 11:08:43.171960 +00:00,8834.00,true,589
2042,2025-09-08 13:33:09.811638 +00:00,2025-09-08 13:47:40.811638 +00:00,22562.00,true,590
2043,2025-09-17 03:39:02.813614 +00:00,2025-09-18 16:26:27.813614 +00:00,19958.00,true,590
2044,2025-09-27 16:59:10.167546 +00:00,,13612.00,false,590
2045,2019-12-21 18:35:12.660896 +00:00,2019-12-21 18:46:54.660896 +00:00,32063.00,true,591
2046,2023-10-23 02:00:49.166568 +00:00,2023-10-27 05:36:01.166568 +00:00,1471.00,true,591
2047,2018-12-09 10:16:53.637953 +00:00,2018-12-09 10:29:26.637953 +00:00,91899.00,true,592
2048,2012-09-18 04:56:33.407919 +00:00,2012-09-18 05:03:12.407919 +00:00,7663.00,true,593
2049,2024-11-20 21:49:40.013838 +00:00,,4066.00,false,593
2050,2015-07-22 04:10:43.131895 +00:00,2015-08-01 19:17:22.131895 +00:00,2772.00,true,593
2051,2021-11-10 22:48:58.774176 +00:00,2021-11-22 05:34:39.774176 +00:00,3318.00,true,593
2052,2016-05-15 21:41:41.829199 +00:00,2016-05-17 13:31:23.829199 +00:00,32184.00,true,593
2053,2012-04-14 03:45:38.771574 +00:00,2012-04-14 04:01:42.771574 +00:00,18173.00,true,594
2054,2020-10-28 12:07:09.246208 +00:00,2020-10-30 10:01:05.246208 +00:00,8197.00,true,594
2055,2024-10-29 23:15:39.893741 +00:00,2024-11-02 17:12:16.893741 +00:00,4513.00,true,594
2056,2025-08-29 19:09:46.394371 +00:00,2025-08-29 19:16:09.394371 +00:00,48963.00,true,595
2057,2025-08-17 06:13:11.360716 +00:00,2025-08-17 06:29:08.360716 +00:00,3406.00,true,596
2058,2025-08-20 17:11:43.556162 +00:00,2025-08-21 05:42:24.556162 +00:00,4373.00,true,596
2059,2025-09-27 22:30:37.518214 +00:00,,1964.00,false,596
2060,2025-09-17 08:09:34.119123 +00:00,2025-09-28 20:01:46.119123 +00:00,508.00,true,596
2061,2023-12-13 13:06:38.576756 +00:00,2023-12-13 13:19:25.576756 +00:00,24780.00,true,597
2062,2014-02-09 22:40:43.147182 +00:00,2014-02-09 22:47:24.147182 +00:00,1580.00,true,598
2063,2021-01-20 04:57:39.897718 +00:00,2021-01-29 13:27:33.897718 +00:00,14872.00,true,598
2064,2025-09-15 21:06:11.310674 +00:00,2025-09-15 21:20:54.310674 +00:00,10364.00,true,599
2065,2012-04-18 22:25:38.922112 +00:00,2012-04-18 22:41:18.922112 +00:00,28258.00,true,600
2066,2025-10-03 17:41:22.350727 +00:00,2025-10-03 17:41:37.350727 +00:00,22561.00,true,601
2067,2025-10-04 16:59:51.688022 +00:00,,3058.00,false,601
2068,2025-10-04 20:13:07.755365 +00:00,,439.00,false,601
2069,2025-10-04 21:30:14.846282 +00:00,2025-10-06 01:08:02.846282 +00:00,2717.00,true,601
2070,2025-10-04 19:50:21.102130 +00:00,,886.00,false,601
2071,2016-05-15 13:04:09.868320 +00:00,2016-05-15 13:06:25.868320 +00:00,582.00,true,602
2072,2017-03-20 11:47:44.961109 +00:00,2017-03-31 16:03:37.961109 +00:00,971.00,true,602
2073,2023-03-08 18:42:14.164998 +00:00,2023-03-17 04:33:59.164998 +00:00,9447.00,true,602
2074,2018-10-20 07:39:16.090462 +00:00,2018-10-21 00:15:06.090462 +00:00,2226.00,true,602
2075,2024-12-15 13:19:00.562672 +00:00,2024-12-15 13:19:44.562672 +00:00,11946.00,true,603
2076,2025-02-24 09:27:15.087223 +00:00,2025-02-27 12:28:30.087223 +00:00,24686.00,true,603
2077,2022-03-03 16:01:55.413796 +00:00,2022-03-03 16:17:33.413796 +00:00,10723.00,true,604
2078,2025-08-15 03:47:43.157941 +00:00,2025-08-15 15:53:21.157941 +00:00,9243.00,true,604
2079,2022-09-03 22:46:53.790792 +00:00,2022-09-12 12:39:41.790792 +00:00,3861.00,true,604
2080,2023-01-10 09:04:43.124640 +00:00,2023-01-17 16:19:08.124640 +00:00,2579.00,true,604
2081,2013-10-27 23:43:23.741792 +00:00,2013-10-27 23:48:51.741792 +00:00,4029.00,true,605
2082,2020-03-13 14:59:10.448048 +00:00,2020-03-23 03:59:27.448048 +00:00,2242.00,true,605
2083,2024-05-16 18:43:40.751039 +00:00,2024-05-20 03:36:34.751039 +00:00,3553.00,true,605
2084,2020-02-25 19:37:35.694562 +00:00,2020-03-04 20:58:45.694562 +00:00,2794.00,true,605
2085,2017-10-09 20:48:03.603400 +00:00,2017-10-15 19:08:22.603400 +00:00,5568.00,true,605
2086,2014-09-07 05:08:14.296166 +00:00,,2740.00,false,605
2087,2014-07-28 10:50:06.041204 +00:00,2014-07-28 11:00:56.041204 +00:00,14021.00,true,606
2088,2025-06-22 18:55:00.955289 +00:00,2025-06-29 07:31:07.955289 +00:00,14516.00,true,606
2089,2023-03-17 21:41:35.254716 +00:00,2023-03-23 00:13:44.254716 +00:00,3132.00,true,606
2090,2018-03-21 10:25:39.737875 +00:00,2018-03-21 10:34:12.737875 +00:00,4082.00,true,607
2091,2019-08-04 12:19:16.368622 +00:00,2019-08-13 15:11:46.368622 +00:00,3918.00,true,607
2092,2019-04-20 19:44:45.644778 +00:00,2019-04-27 18:00:51.644778 +00:00,13699.00,true,607
2093,2021-06-01 17:43:31.524149 +00:00,2021-06-11 12:02:48.524149 +00:00,1432.00,true,607
2094,2023-09-11 22:13:24.767045 +00:00,2023-09-22 21:06:20.767045 +00:00,8593.00,true,607
2095,2023-03-20 13:05:57.819367 +00:00,2023-03-24 14:53:41.819367 +00:00,374.00,true,607
2096,2016-01-13 14:20:52.569973 +00:00,2016-01-13 14:23:36.569973 +00:00,494.00,true,608
2097,2018-02-27 01:29:38.492671 +00:00,2018-03-08 05:54:38.492671 +00:00,11139.00,true,608
2098,2023-03-22 05:25:44.940264 +00:00,2023-03-30 03:39:09.940264 +00:00,8574.00,true,608
2099,2017-03-30 16:35:51.829301 +00:00,2017-04-09 02:45:12.829301 +00:00,3644.00,true,608
2100,2021-12-29 08:31:25.966987 +00:00,2021-12-29 08:34:28.966987 +00:00,2789.00,true,609
2101,2022-09-19 06:36:22.244971 +00:00,2022-09-26 07:28:12.244971 +00:00,5570.00,true,609
2102,2024-12-07 21:43:06.272256 +00:00,2024-12-10 07:05:03.272256 +00:00,5328.00,true,609
2103,2023-12-24 17:47:31.880699 +00:00,2023-12-31 17:50:59.880699 +00:00,5093.00,true,609
2104,2024-11-04 10:56:00.064030 +00:00,2024-11-11 13:28:01.064030 +00:00,2112.00,true,609
2105,2023-08-14 19:30:08.794481 +00:00,2023-08-20 08:17:48.794481 +00:00,8200.00,true,609
2106,2022-10-19 10:27:04.593286 +00:00,2022-10-19 10:40:19.593286 +00:00,18944.00,true,610
2107,2022-12-03 19:44:49.589671 +00:00,2022-12-06 07:40:11.589671 +00:00,7427.00,true,610
2108,2023-05-12 09:14:11.721424 +00:00,2023-05-18 09:44:08.721424 +00:00,6521.00,true,610
2109,2017-09-14 16:11:49.437352 +00:00,2017-09-14 16:26:31.437352 +00:00,19223.00,true,611
2110,2016-12-22 11:45:40.281731 +00:00,2016-12-22 11:59:15.281731 +00:00,8294.00,true,612
2111,2021-08-09 22:53:35.041255 +00:00,2021-08-13 06:07:32.041255 +00:00,14272.00,true,612
2112,2025-01-24 10:26:08.356938 +00:00,2025-01-30 18:37:11.356938 +00:00,1298.00,true,612
2113,2025-05-03 11:12:28.149781 +00:00,2025-05-03 11:14:23.149781 +00:00,2033.00,true,613
2114,2025-05-11 07:31:27.375172 +00:00,2025-05-15 23:30:52.375172 +00:00,9666.00,true,613
2115,2025-07-29 10:07:47.199049 +00:00,2025-07-31 01:26:38.199049 +00:00,4695.00,true,613
2116,2025-05-16 01:04:07.998702 +00:00,2025-05-19 12:59:06.998702 +00:00,14646.00,true,613
2117,2025-07-09 03:50:51.648528 +00:00,2025-07-19 13:33:50.648528 +00:00,4960.00,true,613
2118,2025-05-11 10:18:42.159199 +00:00,2025-05-16 09:56:43.159199 +00:00,14624.00,true,613
2119,2015-01-08 04:18:11.062747 +00:00,2015-01-08 04:21:57.062747 +00:00,15146.00,true,614
2120,2019-04-03 14:19:45.071148 +00:00,2019-04-03 15:20:56.071148 +00:00,27202.00,true,614
2121,2021-03-31 10:20:43.823183 +00:00,2021-03-31 13:34:41.823183 +00:00,5363.00,true,614
2122,2025-08-09 13:44:04.815830 +00:00,2025-08-09 13:44:18.815830 +00:00,1652.00,true,615
2123,2025-09-10 19:46:45.632957 +00:00,2025-09-15 18:28:58.632957 +00:00,78.00,true,615
2124,2025-09-21 09:07:14.910047 +00:00,2025-09-23 14:24:51.910047 +00:00,1690.00,true,615
2125,2016-11-17 16:48:03.723193 +00:00,2016-11-17 16:54:29.723193 +00:00,1483.00,true,616
2126,2023-02-06 23:10:14.036110 +00:00,2023-02-08 00:02:20.036110 +00:00,1820.00,true,616
2127,2017-12-05 03:21:19.702311 +00:00,2017-12-10 14:24:36.702311 +00:00,219.00,true,616
2128,2022-08-27 13:38:47.749810 +00:00,2022-08-31 19:07:04.749810 +00:00,19150.00,true,616
2129,2022-01-20 19:09:43.560019 +00:00,2022-01-23 09:38:10.560019 +00:00,30.00,true,616
2130,2019-02-02 07:16:24.084018 +00:00,2019-02-09 21:59:46.084018 +00:00,933.00,true,616
2131,2025-07-26 18:13:58.492184 +00:00,2025-07-26 18:16:56.492184 +00:00,1138.00,true,617
2132,2025-09-10 02:44:31.099596 +00:00,2025-09-11 05:42:32.099596 +00:00,2986.00,true,617
2133,2025-09-21 23:12:38.121934 +00:00,2025-09-26 21:45:03.121934 +00:00,356.00,true,617
2134,2025-09-04 17:58:13.492839 +00:00,2025-09-13 01:28:57.492839 +00:00,34.00,true,617
2135,2025-09-30 18:37:36.550104 +00:00,,1003.00,false,617
2136,2025-07-28 11:00:03.719702 +00:00,2025-08-04 15:34:53.719702 +00:00,419.00,true,617
2137,2023-02-26 07:03:47.771735 +00:00,2023-02-26 07:19:21.771735 +00:00,27913.00,true,618
2138,2024-12-21 04:39:42.788870 +00:00,2025-01-01 05:05:53.788870 +00:00,31730.00,true,618
2139,2025-05-18 19:53:43.982751 +00:00,2025-05-28 02:39:36.982751 +00:00,7407.00,true,618
2140,2025-07-16 20:03:59.141070 +00:00,2025-07-16 20:04:11.141070 +00:00,843.00,true,619
2141,2025-09-09 03:41:24.155216 +00:00,2025-09-15 09:09:24.155216 +00:00,59.00,true,619
2142,2011-06-10 13:27:58.671431 +00:00,2011-06-10 13:43:16.671431 +00:00,26842.00,true,620
2143,2022-08-20 14:26:55.165944 +00:00,2022-08-23 17:01:26.165944 +00:00,11087.00,true,620
2144,2024-10-21 00:32:00.138942 +00:00,2024-10-26 14:37:18.138942 +00:00,546.00,true,620
2145,2013-08-04 01:01:53.092032 +00:00,2013-08-11 04:44:24.092032 +00:00,2704.00,true,620
2146,2025-09-22 08:54:05.854891 +00:00,2025-09-22 09:07:35.854891 +00:00,6499.00,true,621
2147,2025-09-25 15:49:06.668127 +00:00,2025-10-04 05:22:15.668127 +00:00,7405.00,true,621
2148,2025-10-03 00:30:35.898846 +00:00,,8588.00,false,621
2149,2025-10-03 07:57:44.140161 +00:00,,8070.00,false,621
2150,2025-09-26 21:07:00.337662 +00:00,2025-09-26 21:09:30.337662 +00:00,15848.00,true,622
2151,2025-10-01 02:17:27.742561 +00:00,,6724.00,false,622
2152,2025-10-02 00:29:23.006911 +00:00,2025-10-03 06:52:05.006911 +00:00,8276.00,true,622
2153,2025-09-27 05:50:04.921266 +00:00,2025-09-27 05:54:24.921266 +00:00,10705.00,true,623
2154,2025-10-02 05:01:37.954734 +00:00,,6713.00,false,623
2155,2025-10-03 22:37:21.923724 +00:00,,1454.00,false,623
2156,2015-08-17 04:42:55.703951 +00:00,2015-08-17 04:49:26.703951 +00:00,4278.00,true,624
2157,2020-08-13 16:17:00.409471 +00:00,2020-08-21 14:47:53.409471 +00:00,41.00,true,624
2158,2021-08-17 04:34:30.302916 +00:00,2021-08-17 22:49:17.302916 +00:00,733.00,true,624
2159,2025-09-01 05:46:20.206001 +00:00,2025-09-01 05:54:29.206001 +00:00,2141.00,true,625
2160,2025-09-10 02:24:45.777931 +00:00,,3757.00,false,625
2161,2025-10-01 17:51:21.195616 +00:00,,622.00,false,625
2162,2025-09-26 04:53:18.239776 +00:00,,2926.00,false,625
2163,2025-09-14 05:27:16.260647 +00:00,2025-09-17 14:09:39.260647 +00:00,916.00,true,625
2164,2025-10-01 08:41:17.343515 +00:00,,4907.00,false,625
2165,2016-04-13 09:19:48.049833 +00:00,2016-04-13 09:20:58.049833 +00:00,7570.00,true,626
2166,2021-03-08 02:22:17.554574 +00:00,2021-03-17 10:07:46.554574 +00:00,4178.00,true,626
2167,2023-11-25 16:23:45.982593 +00:00,2023-11-25 16:24:17.982593 +00:00,637.00,true,627
2168,2025-01-13 02:44:13.606415 +00:00,2025-01-24 14:21:10.606415 +00:00,1281.00,true,627
2169,2024-01-25 01:40:46.246902 +00:00,2024-02-02 06:50:21.246902 +00:00,3990.00,true,627
2170,2024-09-01 06:39:25.948684 +00:00,2024-09-06 11:46:18.948684 +00:00,15236.00,true,627
2171,2025-06-07 09:03:55.706854 +00:00,2025-06-10 04:35:14.706854 +00:00,1345.00,true,627
2172,2023-03-26 03:50:35.136575 +00:00,2023-03-26 04:05:38.136575 +00:00,1468.00,true,628
2173,2025-06-11 04:04:36.951866 +00:00,2025-06-14 20:12:51.951866 +00:00,1679.00,true,628
2174,2017-02-22 10:58:00.673102 +00:00,2017-02-22 11:02:53.673102 +00:00,1603.00,true,629
2175,2020-07-18 07:44:43.611730 +00:00,2020-07-25 22:47:54.611730 +00:00,4350.00,true,629
2176,2024-03-14 19:18:44.927141 +00:00,2024-03-19 04:28:42.927141 +00:00,1335.00,true,629
2177,2020-03-30 13:38:36.963914 +00:00,2020-04-06 01:02:52.963914 +00:00,641.00,true,629
2178,2020-09-05 08:33:51.800836 +00:00,2020-09-15 07:59:37.800836 +00:00,8476.00,true,629
2179,2023-12-01 03:01:50.497540 +00:00,2023-12-08 06:23:38.497540 +00:00,7318.00,true,629
2180,2012-05-22 17:35:33.019026 +00:00,2012-05-22 17:44:19.019026 +00:00,7542.00,true,630
2181,2023-03-14 19:01:07.760729 +00:00,2023-03-24 01:18:08.760729 +00:00,12788.00,true,630
2182,2025-04-22 09:07:40.793592 +00:00,2025-04-22 09:08:19.793592 +00:00,30061.00,true,631
2183,2015-09-20 20:53:03.236246 +00:00,2015-09-20 21:08:15.236246 +00:00,2096.00,true,632
2184,2022-01-16 22:57:45.565422 +00:00,2022-01-19 14:59:05.565422 +00:00,45726.00,true,632
2185,2022-04-27 08:52:43.333234 +00:00,,613.00,false,632
2186,2018-12-22 13:29:43.852488 +00:00,2018-12-24 00:45:30.852488 +00:00,11236.00,true,632
2187,2015-08-20 05:05:26.657141 +00:00,2015-08-20 05:13:38.657141 +00:00,45707.00,true,633
2188,2023-07-16 16:01:43.809350 +00:00,2023-07-19 09:45:10.809350 +00:00,9415.00,true,633
2189,2023-08-01 07:27:58.708259 +00:00,2023-08-12 05:41:55.708259 +00:00,5179.00,true,633
2190,2014-05-29 16:34:34.668033 +00:00,2014-05-29 16:38:16.668033 +00:00,6513.00,true,634
2191,2021-01-16 19:37:45.387770 +00:00,2021-01-23 21:29:09.387770 +00:00,6032.00,true,634
2192,2017-05-01 10:39:05.020889 +00:00,2017-05-04 02:42:52.020889 +00:00,436.00,true,634
2193,2019-09-02 05:16:01.673668 +00:00,2019-09-02 05:26:50.673668 +00:00,12386.00,true,635
2194,2025-04-25 09:57:01.959414 +00:00,2025-04-28 17:59:39.959414 +00:00,2803.00,true,635
2195,2025-09-02 00:12:23.831794 +00:00,2025-09-06 16:05:09.831794 +00:00,3945.00,true,635
2196,2025-01-24 03:44:07.004400 +00:00,,1604.00,false,635
2197,2022-02-26 05:13:49.582914 +00:00,2022-03-08 15:51:34.582914 +00:00,1934.00,true,635
2198,2024-05-31 22:26:31.132890 +00:00,2024-06-07 23:23:21.132890 +00:00,4133.00,true,635
2199,2018-04-20 14:33:04.360350 +00:00,2018-04-20 14:41:02.360350 +00:00,22575.00,true,636
2200,2022-12-24 15:54:35.043673 +00:00,2023-01-01 12:47:35.043673 +00:00,18856.00,true,636
2201,2019-09-23 18:22:35.809867 +00:00,2019-09-29 09:27:27.809867 +00:00,14217.00,true,636
2202,2025-09-05 21:27:59.610669 +00:00,2025-09-05 21:34:46.610669 +00:00,685.00,true,637
2203,2025-09-28 22:06:01.498062 +00:00,,19325.00,false,637
2204,2025-09-29 20:00:43.449844 +00:00,2025-10-01 14:45:22.449844 +00:00,133.00,true,637
2205,2025-09-26 19:17:13.579742 +00:00,,12584.00,false,637
2206,2020-09-14 02:50:28.260377 +00:00,2020-09-14 02:55:11.260377 +00:00,23489.00,true,638
2207,2010-12-28 18:17:03.688008 +00:00,2010-12-28 18:20:58.688008 +00:00,5227.00,true,639
2208,2022-06-19 21:40:10.350691 +00:00,2022-06-22 12:45:38.350691 +00:00,249.00,true,639
2209,2010-05-15 14:38:47.680023 +00:00,2010-05-15 14:46:10.680023 +00:00,1787.00,true,640
2210,2021-08-02 15:04:49.058072 +00:00,2021-08-05 10:20:07.058072 +00:00,376.00,true,640
2211,2025-02-27 00:03:37.552968 +00:00,2025-02-27 00:05:21.552968 +00:00,17397.00,true,641
2212,2025-06-15 23:12:11.099501 +00:00,2025-06-17 02:31:16.099501 +00:00,4611.00,true,641
2213,2025-03-03 13:12:23.632068 +00:00,2025-03-10 04:26:43.632068 +00:00,15646.00,true,641
2214,2025-05-22 22:39:38.533776 +00:00,2025-05-31 14:32:18.533776 +00:00,13494.00,true,641
2215,2013-08-25 18:30:58.757642 +00:00,2013-08-25 18:39:09.757642 +00:00,11987.00,true,642
2216,2020-01-28 09:57:33.276515 +00:00,2020-02-02 17:39:33.276515 +00:00,7445.00,true,642
2217,2017-01-20 11:12:16.097558 +00:00,2017-01-20 11:25:34.097558 +00:00,7571.00,true,643
2218,2025-05-11 08:35:02.683626 +00:00,,27560.00,false,643
2219,2020-05-10 00:05:20.111165 +00:00,2020-05-11 00:14:04.111165 +00:00,4951.00,true,643
2220,2018-07-02 22:01:33.543183 +00:00,2018-07-06 13:30:46.543183 +00:00,13214.00,true,643
2221,2020-02-19 20:27:21.609325 +00:00,2020-02-26 10:25:44.609325 +00:00,4981.00,true,643
2222,2019-01-24 21:35:31.869367 +00:00,2019-02-03 19:50:15.869367 +00:00,2179.00,true,643
2223,2017-08-29 01:07:41.258869 +00:00,2017-08-29 01:09:17.258869 +00:00,5491.00,true,644
2224,2018-12-09 01:43:16.530339 +00:00,2018-12-16 06:25:48.530339 +00:00,17239.00,true,644
2225,2017-04-15 03:56:22.690069 +00:00,2017-04-15 03:57:00.690069 +00:00,10594.00,true,645
2226,2023-09-10 22:50:53.032453 +00:00,2023-09-21 09:47:15.032453 +00:00,11653.00,true,645
2227,2020-04-17 06:23:59.704115 +00:00,2020-04-28 10:04:10.704115 +00:00,24421.00,true,645
2228,2017-07-06 12:24:12.877458 +00:00,2017-07-06 12:30:21.877458 +00:00,3039.00,true,646
2229,2017-08-09 21:49:44.560898 +00:00,2017-08-19 17:13:33.560898 +00:00,1018.00,true,646
2230,2022-11-17 01:35:38.501367 +00:00,2022-11-20 03:04:14.501367 +00:00,2972.00,true,646
2231,2021-01-05 04:38:30.510586 +00:00,2021-01-05 05:41:03.510586 +00:00,1425.00,true,646
2232,2018-01-26 14:26:37.893307 +00:00,2018-01-30 04:54:55.893307 +00:00,913.00,true,646
2233,2018-12-04 05:05:08.288682 +00:00,2018-12-04 05:20:47.288682 +00:00,8610.00,true,647
2234,2021-09-02 09:13:04.199428 +00:00,2021-09-10 14:04:19.199428 +00:00,3301.00,true,647
2235,2023-01-12 12:17:42.422772 +00:00,2023-01-19 14:39:39.422772 +00:00,8969.00,true,647
2236,2021-09-12 19:43:20.769091 +00:00,2021-09-17 04:54:23.769091 +00:00,1983.00,true,647
2237,2019-03-24 16:46:55.361370 +00:00,2019-03-27 11:29:47.361370 +00:00,4400.00,true,647
2238,2018-11-12 22:41:05.457595 +00:00,2018-11-12 22:49:35.457595 +00:00,33927.00,true,648
2239,2021-10-17 02:55:51.422323 +00:00,2021-10-19 16:10:35.422323 +00:00,42677.00,true,648
2240,2023-10-27 10:40:24.376190 +00:00,2023-10-27 10:45:36.376190 +00:00,5743.00,true,649
2241,2024-02-04 16:40:32.262676 +00:00,2024-02-08 05:08:15.262676 +00:00,28150.00,true,649
2242,2023-12-26 08:53:35.389729 +00:00,2024-01-03 11:48:36.389729 +00:00,4105.00,true,649
2243,2018-11-22 10:42:01.801006 +00:00,2018-11-22 10:46:36.801006 +00:00,713.00,true,650
2244,2022-09-05 00:39:40.726136 +00:00,2022-09-14 22:07:21.726136 +00:00,35.00,true,650
2245,2016-10-11 07:08:54.219795 +00:00,2016-10-11 07:16:23.219795 +00:00,32279.00,true,651
2246,2019-01-17 17:32:59.353821 +00:00,2019-01-28 19:42:29.353821 +00:00,211.00,true,651
2247,2018-11-16 02:13:34.449135 +00:00,2018-11-18 16:00:30.449135 +00:00,16810.00,true,651
2248,2024-05-22 13:42:06.722729 +00:00,2024-05-30 19:07:29.722729 +00:00,2348.00,true,651
2249,2025-07-12 01:53:55.766339 +00:00,2025-07-12 02:03:23.766339 +00:00,30307.00,true,652
2250,2025-08-31 02:07:19.848864 +00:00,2025-09-07 16:31:37.848864 +00:00,179.00,true,652
2251,2025-08-29 13:21:58.960622 +00:00,2025-09-09 08:46:59.960622 +00:00,14022.00,true,652
2252,2025-08-06 03:17:43.507389 +00:00,2025-08-09 04:52:29.507389 +00:00,1015.00,true,652
2253,2025-03-19 15:09:23.970430 +00:00,2025-03-19 15:25:47.970430 +00:00,735.00,true,653
2254,2025-08-29 21:13:42.053845 +00:00,,5749.00,false,653
2255,2025-08-20 14:54:04.624215 +00:00,2025-08-26 10:29:54.624215 +00:00,37153.00,true,653
2256,2025-09-27 20:03:29.500046 +00:00,2025-10-01 12:13:47.500046 +00:00,2426.00,true,653
2257,2016-11-04 11:48:17.247699 +00:00,2016-11-04 12:01:45.247699 +00:00,10289.00,true,654
2258,2020-02-11 21:06:50.864630 +00:00,2020-02-17 22:06:07.864630 +00:00,9467.00,true,654
2259,2017-11-10 16:29:12.929146 +00:00,2017-11-15 11:07:41.929146 +00:00,4965.00,true,654
2260,2020-12-20 12:44:03.617909 +00:00,2020-12-24 22:02:44.617909 +00:00,1966.00,true,654
2261,2020-07-05 14:06:48.394879 +00:00,2020-07-09 22:03:32.394879 +00:00,2221.00,true,654
2262,2011-09-13 05:15:20.406485 +00:00,2011-09-13 05:29:29.406485 +00:00,1712.00,true,655
2263,2012-06-09 14:52:04.469391 +00:00,2012-06-16 19:19:54.469391 +00:00,14103.00,true,655
2264,2021-04-23 23:34:04.395406 +00:00,2021-04-25 18:45:22.395406 +00:00,580.00,true,655
2265,2024-11-17 11:48:34.567720 +00:00,2024-11-17 11:52:16.567720 +00:00,2044.00,true,656
2266,2025-01-27 18:28:15.328913 +00:00,2025-02-04 04:48:55.328913 +00:00,4929.00,true,656
2267,2025-05-01 00:23:00.209919 +00:00,2025-05-12 04:57:46.209919 +00:00,1377.00,true,656
2268,2025-09-06 20:33:28.191798 +00:00,,695.00,false,656
2269,2025-05-17 06:24:14.208200 +00:00,,1838.00,false,656
2270,2025-09-30 18:37:04.325127 +00:00,,8024.00,false,656
2271,2019-12-08 00:00:26.939541 +00:00,2019-12-08 00:07:05.939541 +00:00,12639.00,true,657
2272,2023-12-18 21:10:15.285055 +00:00,2023-12-30 02:04:19.285055 +00:00,12966.00,true,657
2273,2019-05-06 18:15:07.481503 +00:00,2019-05-06 18:19:55.481503 +00:00,29117.00,true,658
2274,2020-07-20 09:32:03.944133 +00:00,2020-07-20 09:43:58.944133 +00:00,95.00,true,659
2275,2022-06-18 17:40:52.640757 +00:00,2022-06-24 04:32:05.640757 +00:00,33.00,true,659
2276,2022-05-24 02:29:56.236276 +00:00,2022-05-26 11:01:37.236276 +00:00,24.00,true,659
2277,2024-08-18 11:56:02.166541 +00:00,2024-08-22 17:27:01.166541 +00:00,52.00,true,659
2278,2013-11-23 10:38:48.139056 +00:00,2013-11-23 10:48:42.139056 +00:00,10766.00,true,660
2279,2019-11-16 12:36:10.686133 +00:00,2019-11-26 13:02:41.686133 +00:00,17021.00,true,660
2280,2023-07-23 08:04:20.147845 +00:00,2023-07-23 17:10:03.147845 +00:00,7233.00,true,660
2281,2025-04-22 23:50:58.706066 +00:00,2025-04-28 11:13:22.706066 +00:00,5495.00,true,660
2282,2024-05-13 19:58:37.605178 +00:00,2024-05-24 07:13:50.605178 +00:00,6243.00,true,660
2283,2025-07-05 23:16:37.514113 +00:00,2025-07-05 23:28:53.514113 +00:00,14214.00,true,661
2284,2025-08-31 01:23:02.386093 +00:00,2025-09-08 13:44:52.386093 +00:00,6136.00,true,661
2285,2025-08-27 13:30:38.558323 +00:00,2025-09-07 03:26:12.558323 +00:00,9882.00,true,661
2286,2014-07-05 21:28:17.068842 +00:00,2014-07-05 21:40:17.068842 +00:00,5153.00,true,662
2287,2024-06-13 02:09:45.463039 +00:00,2024-06-20 09:24:56.463039 +00:00,1022.00,true,662
2288,2025-09-17 18:11:48.662576 +00:00,2025-09-17 18:27:26.662576 +00:00,1767.00,true,663
2289,2025-10-02 15:39:51.686419 +00:00,2025-10-06 01:28:01.686419 +00:00,17443.00,true,663
2290,2025-09-27 15:18:11.144330 +00:00,,2141.00,false,663
2291,2025-09-18 07:59:11.878245 +00:00,,11983.00,false,663
2292,2025-09-20 06:53:31.157038 +00:00,2025-09-20 14:58:26.157038 +00:00,5239.00,true,663
2293,2025-09-26 16:58:57.202795 +00:00,2025-10-05 11:05:57.202795 +00:00,8464.00,true,663
2294,2025-08-22 22:41:40.056540 +00:00,2025-08-22 22:49:54.056540 +00:00,53139.00,true,664
2295,2013-03-06 19:57:54.677713 +00:00,2013-03-06 20:05:10.677713 +00:00,490.00,true,665
2296,2013-11-28 03:49:27.141214 +00:00,2013-12-02 20:50:41.141214 +00:00,28905.00,true,665
2297,2019-05-08 13:29:42.335906 +00:00,2019-05-16 01:13:32.335906 +00:00,3005.00,true,665
2298,2015-10-13 03:35:38.132473 +00:00,2015-10-19 15:15:35.132473 +00:00,20169.00,true,665
2299,2014-07-30 08:49:03.080849 +00:00,2014-07-30 08:59:26.080849 +00:00,15322.00,true,666
2300,2015-01-16 22:54:30.108477 +00:00,2015-01-24 09:39:28.108477 +00:00,4830.00,true,666
2301,2010-09-24 00:49:58.770187 +00:00,2010-09-24 01:00:45.770187 +00:00,598.00,true,667
2302,2024-06-24 20:51:05.640172 +00:00,2024-06-29 02:22:48.640172 +00:00,3165.00,true,667
2303,2012-02-09 18:04:34.476364 +00:00,2012-02-14 00:31:30.476364 +00:00,698.00,true,667
2304,2013-02-10 18:44:04.957667 +00:00,2013-02-16 07:03:32.957667 +00:00,4336.00,true,667
2305,2012-01-18 00:53:06.610046 +00:00,2012-01-26 02:07:10.610046 +00:00,2757.00,true,667
2306,2017-10-13 13:58:36.511267 +00:00,2017-10-13 15:35:35.511267 +00:00,595.00,true,667
2307,2014-12-10 05:07:56.196034 +00:00,2014-12-10 05:18:45.196034 +00:00,33675.00,true,668
2308,2024-02-25 22:03:32.088012 +00:00,2024-03-02 18:00:11.088012 +00:00,26932.00,true,668
2309,2025-08-04 05:47:48.301825 +00:00,2025-08-04 05:56:18.301825 +00:00,3121.00,true,669
2310,2025-09-25 07:57:11.635800 +00:00,2025-09-29 02:45:34.635800 +00:00,2459.00,true,669
2311,2025-09-20 23:18:40.347048 +00:00,2025-09-30 17:34:28.347048 +00:00,6357.00,true,669
2312,2025-09-04 18:54:33.826199 +00:00,2025-09-07 22:03:43.826199 +00:00,1530.00,true,669
2313,2025-08-16 10:13:52.339627 +00:00,2025-08-23 07:36:16.339627 +00:00,7276.00,true,669
2314,2021-10-23 22:05:05.030591 +00:00,2021-10-23 22:05:51.030591 +00:00,20662.00,true,670
2315,2022-02-11 00:45:13.899361 +00:00,2022-02-20 21:58:05.899361 +00:00,1412.00,true,670
2316,2025-08-24 23:55:37.212991 +00:00,2025-09-04 19:49:33.212991 +00:00,10940.00,true,670
2317,2025-03-26 00:00:46.203074 +00:00,2025-03-26 06:47:41.203074 +00:00,9998.00,true,670
2318,2021-12-05 18:27:11.856587 +00:00,2021-12-09 19:23:05.856587 +00:00,15842.00,true,670
2319,2023-01-22 04:30:19.573585 +00:00,2023-01-22 04:46:11.573585 +00:00,17253.00,true,671
2320,2025-03-04 13:06:06.378806 +00:00,2025-03-11 06:19:14.378806 +00:00,13772.00,true,671
2321,2024-03-22 05:16:28.514299 +00:00,2024-03-27 21:30:08.514299 +00:00,1484.00,true,671
2322,2024-05-19 03:15:46.312228 +00:00,2024-05-29 00:05:58.312228 +00:00,11112.00,true,671
2323,2025-09-13 03:43:06.297478 +00:00,2025-09-13 03:59:27.297478 +00:00,63242.00,true,672
2324,2018-12-12 10:32:41.491471 +00:00,2018-12-12 10:41:51.491471 +00:00,1888.00,true,673
2325,2025-07-30 12:30:03.745939 +00:00,2025-07-30 12:38:52.745939 +00:00,3191.00,true,674
2326,2025-09-28 09:36:04.055911 +00:00,2025-10-05 08:57:05.055911 +00:00,3122.00,true,674
2327,2025-09-16 04:33:48.585465 +00:00,2025-09-19 08:47:48.585465 +00:00,21535.00,true,674
2328,2025-08-09 04:00:10.365702 +00:00,2025-08-17 08:11:58.365702 +00:00,1115.00,true,674
2329,2025-09-26 02:53:54.175754 +00:00,2025-09-26 03:10:24.175754 +00:00,6570.00,true,675
2330,2025-10-03 00:46:30.720133 +00:00,,9764.00,false,675
2331,2025-09-27 23:17:21.575710 +00:00,2025-10-04 15:45:41.575710 +00:00,19190.00,true,675
2332,2023-12-08 13:08:03.458498 +00:00,2023-12-08 13:08:50.458498 +00:00,14447.00,true,676
2333,2025-03-26 01:03:32.799954 +00:00,2025-03-27 19:02:50.799954 +00:00,2884.00,true,676
2334,2024-07-28 19:21:51.277124 +00:00,2024-08-04 22:39:27.277124 +00:00,1277.00,true,676
2335,2025-06-04 07:39:42.132781 +00:00,,34049.00,false,676
2336,2016-09-19 03:36:41.003401 +00:00,2016-09-19 03:50:20.003401 +00:00,7915.00,true,677
2337,2017-10-04 18:56:40.236983 +00:00,2017-10-09 03:03:06.236983 +00:00,10034.00,true,677
2338,2017-08-09 16:32:47.351540 +00:00,2017-08-16 12:55:21.351540 +00:00,25644.00,true,677
2339,2025-07-12 03:48:21.180856 +00:00,2025-07-12 04:01:56.180856 +00:00,3694.00,true,678
2340,2025-07-17 11:46:28.852427 +00:00,2025-07-20 01:51:40.852427 +00:00,294.00,true,678
2341,2025-08-23 22:12:07.313697 +00:00,,382.00,false,678
2342,2025-09-26 04:26:29.380189 +00:00,,210.00,false,678
2343,2025-07-24 16:26:26.351548 +00:00,2025-08-02 04:36:20.351548 +00:00,700.00,true,678
2344,2025-09-07 11:09:49.220443 +00:00,2025-09-18 08:38:43.220443 +00:00,1605.00,true,678
2345,2025-07-27 04:19:26.579769 +00:00,2025-07-27 04:23:43.579769 +00:00,26746.00,true,679
2346,2023-03-28 20:37:53.700625 +00:00,2023-03-28 20:52:25.700625 +00:00,15739.00,true,680
2347,2025-03-30 21:39:45.951048 +00:00,2025-03-30 21:43:07.951048 +00:00,5262.00,true,681
2348,2025-07-03 00:12:52.553939 +00:00,2025-07-09 21:38:15.553939 +00:00,11721.00,true,681
2349,2025-10-02 08:26:22.630406 +00:00,,4129.00,false,681
2350,2010-03-12 22:30:59.124106 +00:00,2010-03-12 22:34:40.124106 +00:00,3073.00,true,682
2351,2021-03-23 13:24:57.334025 +00:00,2021-03-25 21:49:37.334025 +00:00,1793.00,true,682
2352,2010-06-09 07:57:57.706771 +00:00,2010-06-16 22:56:51.706771 +00:00,1329.00,true,682
2353,2024-07-12 15:38:33.212540 +00:00,2024-07-12 15:48:51.212540 +00:00,7247.00,true,683
2354,2025-05-20 16:24:27.397772 +00:00,2025-05-21 11:09:18.397772 +00:00,54508.00,true,683
2355,2025-08-19 22:09:41.245813 +00:00,2025-08-19 22:11:57.245813 +00:00,185.00,true,684
2356,2025-09-10 15:55:24.025368 +00:00,2025-09-17 11:29:45.025368 +00:00,216.00,true,684
2357,2025-09-25 04:27:24.966865 +00:00,2025-09-30 08:07:21.966865 +00:00,225.00,true,684
2358,2025-09-26 20:54:40.040406 +00:00,,106.00,false,684
2359,2022-09-25 00:00:19.135372 +00:00,2022-09-25 00:11:37.135372 +00:00,69408.00,true,685
2360,2011-11-22 22:55:56.531678 +00:00,2011-11-22 23:09:02.531678 +00:00,37180.00,true,686
2361,2017-09-08 00:36:21.977678 +00:00,2017-09-08 00:52:19.977678 +00:00,2605.00,true,687
2362,2021-05-28 12:18:17.425691 +00:00,2021-05-29 04:25:10.425691 +00:00,10334.00,true,687
2363,2020-01-12 06:40:25.440142 +00:00,2020-01-21 10:27:17.440142 +00:00,10828.00,true,687
2364,2023-03-29 09:25:15.760948 +00:00,2023-03-29 09:36:26.760948 +00:00,1179.00,true,688
2365,2024-11-21 02:22:54.287162 +00:00,2024-12-01 19:50:44.287162 +00:00,1619.00,true,688
2366,2024-09-16 08:18:23.340115 +00:00,2024-09-27 14:58:36.340115 +00:00,7597.00,true,688
2367,2025-03-13 23:14:51.904724 +00:00,2025-03-16 21:01:34.904724 +00:00,2605.00,true,688
2368,2023-07-25 23:50:57.081117 +00:00,2023-08-05 03:38:22.081117 +00:00,1080.00,true,688
2369,2023-05-16 06:36:44.111403 +00:00,2023-05-17 16:28:09.111403 +00:00,6102.00,true,688
2370,2021-03-14 14:26:12.201867 +00:00,2021-03-14 14:36:39.201867 +00:00,2828.00,true,689
2371,2021-05-20 06:16:52.899518 +00:00,2021-05-25 00:32:51.899518 +00:00,28087.00,true,689
2372,2025-09-07 10:01:45.694747 +00:00,2025-09-07 10:16:24.694747 +00:00,6620.00,true,690
2373,2019-04-09 08:57:49.248017 +00:00,2019-04-09 09:08:41.248017 +00:00,21.00,true,691
2374,2020-08-04 13:03:20.612516 +00:00,2020-08-10 01:09:01.612516 +00:00,32.00,true,691
2375,2023-09-16 01:24:38.605010 +00:00,,87.00,false,691
2376,2023-04-21 22:58:47.408511 +00:00,2023-04-24 18:31:43.408511 +00:00,140.00,true,691
2377,2020-01-26 05:53:58.473283 +00:00,2020-01-26 06:08:33.473283 +00:00,17031.00,true,692
2378,2016-10-12 02:45:23.867814 +00:00,2016-10-12 02:49:16.867814 +00:00,32327.00,true,693
2379,2013-06-08 00:56:55.340539 +00:00,2013-06-08 01:00:52.340539 +00:00,3301.00,true,694
2380,2019-10-12 17:51:46.154710 +00:00,2019-10-12 23:50:43.154710 +00:00,2220.00,true,694
2381,2024-01-22 15:20:14.342133 +00:00,2024-01-26 02:14:16.342133 +00:00,5042.00,true,694
2382,2023-12-11 16:24:28.752663 +00:00,2023-12-22 15:17:47.752663 +00:00,11970.00,true,694
2383,2015-01-27 07:49:44.722549 +00:00,2015-02-02 08:41:36.722549 +00:00,10707.00,true,694
2384,2021-09-14 21:15:15.748759 +00:00,2021-09-24 16:18:31.748759 +00:00,6137.00,true,694
2385,2018-10-31 16:43:25.304671 +00:00,2018-10-31 16:58:21.304671 +00:00,25405.00,true,695
2386,2021-03-03 02:58:14.009181 +00:00,,867.00,false,695
2387,2024-08-31 11:54:33.735203 +00:00,2024-09-07 00:06:31.735203 +00:00,4020.00,true,695
2388,2022-06-05 08:33:38.404532 +00:00,2022-06-06 00:33:15.404532 +00:00,12524.00,true,695
2389,2019-03-13 06:32:33.071503 +00:00,2019-03-21 15:13:44.071503 +00:00,6998.00,true,695
2390,2018-02-09 10:57:45.357550 +00:00,2018-02-09 11:03:07.357550 +00:00,10723.00,true,696
2391,2020-11-09 07:30:05.817124 +00:00,2020-11-14 08:01:09.817124 +00:00,15824.00,true,696
2392,2024-01-15 03:37:15.556414 +00:00,2024-01-25 23:35:52.556414 +00:00,4039.00,true,696
2393,2023-08-03 07:41:25.376125 +00:00,2023-08-11 20:31:11.376125 +00:00,8743.00,true,696
2394,2024-02-15 15:41:27.657536 +00:00,2024-02-19 22:03:43.657536 +00:00,8460.00,true,696
2395,2018-06-24 16:38:30.901719 +00:00,2018-06-24 16:52:56.901719 +00:00,1040.00,true,697
2396,2018-02-21 21:45:32.258851 +00:00,2018-02-21 22:01:06.258851 +00:00,18836.00,true,698
2397,2014-07-11 20:11:17.820535 +00:00,2014-07-11 20:22:00.820535 +00:00,439.00,true,699
2398,2019-07-08 20:06:18.880579 +00:00,2019-07-13 14:34:08.880579 +00:00,4723.00,true,699
2399,2016-02-06 08:47:08.501842 +00:00,2016-02-14 15:24:41.501842 +00:00,2293.00,true,699
2400,2020-02-16 09:48:38.338694 +00:00,2020-02-25 06:16:10.338694 +00:00,1345.00,true,699
2401,2019-10-24 03:57:52.963638 +00:00,2019-11-01 10:53:07.963638 +00:00,11322.00,true,699
2402,2014-10-31 05:40:56.016658 +00:00,2014-11-09 09:25:26.016658 +00:00,2797.00,true,699
2403,2025-08-12 15:58:16.103668 +00:00,2025-08-12 16:07:28.103668 +00:00,7063.00,true,700
2404,2025-09-03 19:31:27.758017 +00:00,2025-09-12 22:06:45.758017 +00:00,5273.00,true,700
2405,2025-09-22 22:20:15.861900 +00:00,2025-09-28 20:26:48.861900 +00:00,220.00,true,700
2406,2025-09-09 04:36:01.339778 +00:00,2025-09-14 14:11:31.339778 +00:00,11670.00,true,700
2407,2025-08-30 23:31:01.986440 +00:00,2025-08-31 00:18:54.986440 +00:00,5287.00,true,700
2408,2025-08-27 09:08:19.400470 +00:00,2025-09-03 05:36:19.400470 +00:00,1391.00,true,700
2409,2025-08-04 22:01:21.188438 +00:00,2025-08-04 22:14:56.188438 +00:00,27.00,true,701
2410,2025-09-06 11:52:43.197405 +00:00,2025-09-09 08:40:52.197405 +00:00,150.00,true,701
2411,2025-09-12 19:21:03.710915 +00:00,2025-09-17 16:07:24.710915 +00:00,74.00,true,701
2412,2025-09-17 02:35:27.191050 +00:00,2025-09-20 22:42:34.191050 +00:00,173.00,true,701
2413,2025-08-15 14:33:27.591518 +00:00,2025-08-24 00:30:18.591518 +00:00,241.00,true,701
2414,2025-09-03 04:13:35.979745 +00:00,2025-09-12 10:05:09.979745 +00:00,37.00,true,701
2415,2025-07-30 23:15:48.510305 +00:00,2025-07-30 23:19:58.510305 +00:00,3434.00,true,702
2416,2025-08-25 12:09:18.849105 +00:00,,7901.00,false,702
2417,2025-08-16 23:07:13.472214 +00:00,2025-08-28 08:19:50.472214 +00:00,1570.00,true,702
2418,2010-03-04 01:43:54.915531 +00:00,2010-03-04 01:57:14.915531 +00:00,257.00,true,703
2419,2020-02-08 17:34:33.815271 +00:00,2020-02-18 04:24:51.815271 +00:00,1936.00,true,703
2420,2015-06-05 07:05:51.909066 +00:00,2015-06-14 13:42:47.909066 +00:00,1232.00,true,703
2421,2010-12-16 02:57:33.228806 +00:00,2010-12-16 03:09:36.228806 +00:00,1042.00,true,704
2422,2018-01-04 12:02:52.358662 +00:00,2018-01-11 15:55:56.358662 +00:00,3107.00,true,704
2423,2023-03-12 09:28:10.174746 +00:00,,645.00,false,704
2424,2022-05-14 18:37:25.121231 +00:00,2022-05-15 10:06:12.121231 +00:00,9269.00,true,704
2425,2016-07-08 20:02:30.254193 +00:00,2016-07-17 15:11:41.254193 +00:00,18382.00,true,704
2426,2025-07-15 20:53:53.438560 +00:00,2025-07-15 21:06:55.438560 +00:00,25735.00,true,705
2427,2018-05-31 14:28:07.538303 +00:00,2018-05-31 14:36:16.538303 +00:00,9749.00,true,706
2428,2021-03-28 10:00:39.182734 +00:00,2021-04-05 05:41:25.182734 +00:00,5014.00,true,706
2429,2014-04-23 00:19:00.787637 +00:00,2014-04-23 00:28:39.787637 +00:00,3691.00,true,707
2430,2014-12-28 15:07:06.141713 +00:00,,11313.00,false,707
2431,2016-11-05 22:38:42.381311 +00:00,2016-11-06 02:56:29.381311 +00:00,8831.00,true,707
2432,2023-03-31 00:14:06.836563 +00:00,2023-04-08 10:04:16.836563 +00:00,4807.00,true,707
2433,2015-03-16 12:46:22.770889 +00:00,2015-03-21 23:33:12.770889 +00:00,2637.00,true,707
2434,2025-05-21 23:48:09.474159 +00:00,2025-05-22 12:49:56.474159 +00:00,67.00,true,707
2435,2011-11-07 13:27:26.232284 +00:00,2011-11-07 13:33:05.232284 +00:00,5239.00,true,708
2436,2017-06-17 05:05:24.573914 +00:00,2017-06-23 18:37:42.573914 +00:00,233.00,true,708
2437,2016-02-01 10:39:17.257663 +00:00,2016-02-06 23:24:44.257663 +00:00,9341.00,true,708
2438,2017-07-05 08:54:36.399778 +00:00,2017-07-05 19:11:13.399778 +00:00,14702.00,true,708
2439,2012-10-20 20:58:02.078830 +00:00,2012-10-26 18:12:49.078830 +00:00,8301.00,true,708
2440,2011-10-17 18:46:32.410171 +00:00,2011-10-17 19:00:14.410171 +00:00,27138.00,true,709
2441,2024-06-10 00:50:30.303957 +00:00,2024-06-11 15:49:38.303957 +00:00,90.00,true,709
2442,2016-07-04 00:06:16.702827 +00:00,2016-07-04 00:22:12.702827 +00:00,515.00,true,710
2443,2023-06-20 18:12:24.626860 +00:00,2023-06-27 16:20:03.626860 +00:00,518.00,true,710
2444,2018-03-11 02:55:08.280449 +00:00,2018-03-17 17:07:41.280449 +00:00,3370.00,true,710
2445,2023-06-22 22:53:17.455877 +00:00,2023-07-03 02:31:22.455877 +00:00,816.00,true,710
2446,2025-06-22 06:19:17.476190 +00:00,2025-06-28 12:30:14.476190 +00:00,84.00,true,710
2447,2016-12-27 07:07:51.298693 +00:00,2017-01-04 12:51:59.298693 +00:00,2482.00,true,710
2448,2015-09-13 07:28:37.088323 +00:00,2015-09-13 07:30:54.088323 +00:00,5943.00,true,711
2449,2021-04-08 20:55:50.125290 +00:00,2021-04-16 05:33:41.125290 +00:00,4134.00,true,711
2450,2021-11-23 06:12:00.212899 +00:00,2021-12-04 01:57:22.212899 +00:00,20590.00,true,711
2451,2020-02-26 13:58:53.770804 +00:00,2020-03-08 13:20:36.770804 +00:00,23315.00,true,711
2452,2025-09-01 12:32:29.256613 +00:00,2025-09-12 19:01:42.256613 +00:00,1455.00,true,711
2453,2024-06-02 18:10:40.669428 +00:00,2024-06-02 18:11:42.669428 +00:00,2624.00,true,712
2454,2024-12-17 04:41:21.635556 +00:00,2024-12-19 10:08:42.635556 +00:00,1780.00,true,712
2455,2013-10-18 16:46:58.709790 +00:00,2013-10-18 16:58:42.709790 +00:00,3681.00,true,713
2456,2021-03-16 04:18:33.147674 +00:00,2021-03-20 22:20:08.147674 +00:00,6855.00,true,713
2457,2018-10-21 09:57:05.277616 +00:00,,76.00,false,713
2458,2022-07-14 20:50:33.576850 +00:00,2022-07-19 16:33:19.576850 +00:00,19660.00,true,713
2459,2015-04-18 06:54:52.592780 +00:00,2015-04-18 07:01:30.592780 +00:00,4481.00,true,714
2460,2020-05-31 06:17:53.159096 +00:00,2020-06-03 08:48:08.159096 +00:00,5400.00,true,714
2461,2020-07-24 17:42:19.841972 +00:00,2020-07-26 07:28:46.841972 +00:00,10409.00,true,714
2462,2025-01-23 06:34:52.236028 +00:00,2025-02-02 14:57:14.236028 +00:00,15259.00,true,714
2463,2016-03-30 14:19:10.096808 +00:00,2016-03-30 14:32:47.096808 +00:00,1324.00,true,715
2464,2017-01-13 17:17:28.401080 +00:00,2017-01-19 05:45:44.401080 +00:00,895.00,true,715
2465,2024-04-24 07:00:17.179503 +00:00,2024-05-04 22:59:43.179503 +00:00,690.00,true,715
2466,2017-07-03 19:02:44.658504 +00:00,2017-07-15 04:53:37.658504 +00:00,79.00,true,715
2467,2020-12-25 05:37:05.565492 +00:00,2021-01-03 10:39:09.565492 +00:00,367.00,true,715
2468,2020-12-04 02:03:22.821772 +00:00,2020-12-08 13:37:00.821772 +00:00,1361.00,true,715
2469,2014-06-16 02:03:08.176805 +00:00,2014-06-16 02:08:04.176805 +00:00,539.00,true,716
2470,2018-09-04 17:13:25.669970 +00:00,2018-09-06 17:41:45.669970 +00:00,6830.00,true,716
2471,2024-08-03 16:57:29.684594 +00:00,2024-08-04 08:51:59.684594 +00:00,16125.00,true,716
2472,2012-10-11 14:47:28.477730 +00:00,2012-10-11 14:55:08.477730 +00:00,7367.00,true,717
2473,2018-10-05 13:50:48.588508 +00:00,2018-10-10 05:18:06.588508 +00:00,2523.00,true,717
2474,2017-10-31 11:27:40.358124 +00:00,2017-11-06 04:06:59.358124 +00:00,7395.00,true,717
2475,2024-08-31 10:24:20.328622 +00:00,2024-09-07 11:18:25.328622 +00:00,3594.00,true,717
2476,2017-05-17 00:02:00.740146 +00:00,2017-05-18 17:20:44.740146 +00:00,2683.00,true,717
2477,2025-08-15 12:53:46.226078 +00:00,2025-08-15 12:56:31.226078 +00:00,3878.00,true,718
2478,2025-09-16 02:05:27.028988 +00:00,2025-09-24 14:37:03.028988 +00:00,2058.00,true,718
2479,2025-10-04 06:27:33.091437 +00:00,,3610.00,false,718
2480,2025-08-24 06:30:40.211944 +00:00,2025-09-04 06:29:48.211944 +00:00,4374.00,true,718
2481,2025-08-11 04:50:22.072841 +00:00,2025-08-11 04:56:00.072841 +00:00,2070.00,true,719
2482,2025-09-18 03:17:27.249916 +00:00,2025-09-27 06:40:46.249916 +00:00,20960.00,true,719
2483,2025-08-20 10:47:09.171113 +00:00,,4533.00,false,719
2484,2025-09-07 15:18:02.513940 +00:00,2025-09-12 00:21:49.513940 +00:00,108.00,true,719
2485,2025-03-19 10:11:07.630768 +00:00,2025-03-19 10:17:04.630768 +00:00,32791.00,true,720
2486,2025-09-09 10:23:45.245939 +00:00,2025-09-09 10:32:03.245939 +00:00,29880.00,true,721
2487,2024-12-04 22:52:16.760125 +00:00,2024-12-04 22:56:54.760125 +00:00,8666.00,true,722
2488,2025-08-14 02:29:46.346146 +00:00,2025-08-21 12:02:01.346146 +00:00,3306.00,true,722
2489,2025-03-24 00:44:39.446928 +00:00,2025-03-25 12:33:07.446928 +00:00,9234.00,true,722
2490,2017-10-06 02:21:50.946019 +00:00,2017-10-06 02:26:01.946019 +00:00,7524.00,true,723
2491,2022-11-16 16:44:07.266569 +00:00,2022-11-16 16:59:35.266569 +00:00,543.00,true,724
2492,2025-05-14 22:49:20.509949 +00:00,2025-05-16 16:13:13.509949 +00:00,1963.00,true,724
2493,2025-01-07 14:02:04.163022 +00:00,2025-01-08 14:57:37.163022 +00:00,8228.00,true,724
2494,2023-11-29 17:08:17.831573 +00:00,2023-12-04 23:31:36.831573 +00:00,817.00,true,724
2495,2025-09-04 21:33:10.676860 +00:00,2025-09-07 14:39:36.676860 +00:00,5827.00,true,724
2496,2024-09-26 05:20:55.482907 +00:00,2024-10-04 04:05:18.482907 +00:00,1158.00,true,724
2497,2022-08-18 01:36:48.146584 +00:00,2022-08-18 01:45:03.146584 +00:00,2836.00,true,725
2498,2023-01-14 06:55:54.705467 +00:00,2023-01-24 02:13:21.705467 +00:00,1253.00,true,725
2499,2025-02-06 17:48:21.705243 +00:00,2025-02-13 21:20:04.705243 +00:00,6412.00,true,725
2500,2025-09-06 21:50:11.276542 +00:00,2025-09-18 01:37:44.276542 +00:00,2586.00,true,725
2501,2024-04-02 18:05:25.038244 +00:00,2024-04-07 16:48:51.038244 +00:00,1595.00,true,725
2502,2025-07-22 02:07:46.742532 +00:00,2025-07-23 10:36:04.742532 +00:00,5698.00,true,725
2503,2023-10-30 22:44:02.608662 +00:00,2023-10-30 22:49:20.608662 +00:00,36932.00,true,726
2504,2012-04-27 13:04:04.187135 +00:00,2012-04-27 13:05:28.187135 +00:00,9747.00,true,727
2505,2025-06-30 16:56:07.933083 +00:00,2025-07-06 13:27:34.933083 +00:00,15528.00,true,727
2506,2010-10-27 14:42:15.990663 +00:00,2010-10-27 14:45:27.990663 +00:00,1706.00,true,728
2507,2021-10-02 07:47:17.308263 +00:00,2021-10-02 12:12:24.308263 +00:00,1216.00,true,728
2508,2017-12-22 06:16:02.344326 +00:00,2017-12-24 18:42:20.344326 +00:00,18327.00,true,728
2509,2012-11-01 03:18:31.506191 +00:00,2012-11-01 09:08:39.506191 +00:00,5748.00,true,728
2510,2014-12-20 09:17:54.260765 +00:00,2014-12-23 14:56:13.260765 +00:00,19710.00,true,728
2511,2022-08-27 21:25:12.552522 +00:00,2022-08-27 21:39:23.552522 +00:00,8168.00,true,729
2512,2025-02-01 15:24:04.165307 +00:00,2025-02-11 14:02:36.165307 +00:00,5455.00,true,729
2513,2025-03-11 13:55:36.428155 +00:00,2025-03-22 19:25:48.428155 +00:00,4884.00,true,729
2514,2022-09-28 18:06:35.226695 +00:00,2022-10-05 05:20:26.226695 +00:00,32228.00,true,729
2515,2025-06-09 05:43:19.943987 +00:00,2025-06-11 18:17:41.943987 +00:00,2590.00,true,729
2516,2024-07-15 04:10:28.090224 +00:00,2024-07-16 09:03:49.090224 +00:00,2096.00,true,729
2517,2022-07-05 18:09:30.923621 +00:00,2022-07-05 18:14:42.923621 +00:00,7558.00,true,730
2518,2024-08-24 18:28:00.228862 +00:00,2024-09-03 16:04:56.228862 +00:00,2978.00,true,730
2519,2023-08-02 12:24:08.450959 +00:00,2023-08-09 10:56:01.450959 +00:00,438.00,true,730
2520,2023-10-28 23:06:09.577949 +00:00,2023-10-30 09:52:09.577949 +00:00,5455.00,true,730
2521,2023-03-28 12:02:03.705427 +00:00,2023-04-01 11:23:06.705427 +00:00,1364.00,true,730
2522,2024-02-03 19:28:40.295334 +00:00,2024-02-04 11:08:03.295334 +00:00,3311.00,true,730
2523,2018-07-02 14:31:24.642293 +00:00,2018-07-02 14:44:01.642293 +00:00,8786.00,true,731
2524,2020-07-06 10:28:41.527752 +00:00,2020-07-06 12:18:05.527752 +00:00,18295.00,true,731
2525,2024-08-22 07:42:08.782409 +00:00,2024-08-31 15:27:20.782409 +00:00,581.00,true,731
2526,2019-05-05 09:49:18.852469 +00:00,2019-05-15 08:14:35.852469 +00:00,3181.00,true,731
2527,2025-08-31 00:29:19.228505 +00:00,2025-08-31 00:42:32.228505 +00:00,315.00,true,732
2528,2025-09-10 12:55:59.688118 +00:00,2025-09-16 20:40:33.688118 +00:00,382.00,true,732
2529,2025-09-23 19:59:02.172254 +00:00,2025-09-26 06:31:56.172254 +00:00,2119.00,true,732
2530,2025-09-06 05:31:28.582137 +00:00,2025-09-06 08:02:45.582137 +00:00,7598.00,true,732
2531,2025-09-22 19:09:59.996954 +00:00,2025-09-25 15:35:24.996954 +00:00,865.00,true,732
2532,2025-09-27 09:27:12.994315 +00:00,2025-10-06 02:52:07.994315 +00:00,543.00,true,732
2533,2016-01-28 02:56:58.703789 +00:00,2016-01-28 03:09:26.703789 +00:00,2502.00,true,733
2534,2024-03-18 19:50:30.921173 +00:00,2024-03-19 08:55:22.921173 +00:00,221.00,true,733
2535,2020-05-10 22:22:18.618541 +00:00,2020-05-19 17:16:08.618541 +00:00,322.00,true,733
2536,2022-12-20 02:35:55.072586 +00:00,2022-12-30 21:13:35.072586 +00:00,207.00,true,733
2537,2025-07-29 02:43:14.535815 +00:00,2025-07-29 02:46:07.535815 +00:00,713.00,true,734
2538,2025-08-26 22:28:51.669718 +00:00,2025-08-27 04:23:09.669718 +00:00,20803.00,true,734
2539,2025-09-23 23:00:23.367366 +00:00,2025-10-04 00:50:42.367366 +00:00,66.00,true,734
2540,2025-09-11 23:03:22.125706 +00:00,2025-09-23 06:55:04.125706 +00:00,4727.00,true,734
2541,2025-08-05 04:16:36.363918 +00:00,2025-08-15 21:50:55.363918 +00:00,5577.00,true,734
2542,2025-09-14 00:46:49.358504 +00:00,2025-09-20 18:20:09.358504 +00:00,8308.00,true,734
2543,2017-12-18 20:02:42.806681 +00:00,2017-12-18 20:03:17.806681 +00:00,18369.00,true,735
2544,2025-07-25 15:21:56.844347 +00:00,2025-07-28 03:30:52.844347 +00:00,22045.00,true,735
2545,2021-11-12 08:56:48.789001 +00:00,2021-11-13 23:51:35.789001 +00:00,7853.00,true,735
2546,2023-10-06 18:27:27.337551 +00:00,2023-10-07 13:25:49.337551 +00:00,10683.00,true,735
2547,2018-09-16 09:48:23.952105 +00:00,2018-09-26 10:42:28.952105 +00:00,2104.00,true,735
2548,2011-06-18 18:21:24.873151 +00:00,2011-06-18 18:30:36.873151 +00:00,2232.00,true,736
2549,2013-08-02 20:25:33.546197 +00:00,2013-08-03 03:00:12.546197 +00:00,1376.00,true,736
2550,2023-05-21 12:31:17.477730 +00:00,2023-05-28 03:02:23.477730 +00:00,2256.00,true,736
2551,2019-12-08 04:04:52.218332 +00:00,2019-12-11 09:00:04.218332 +00:00,692.00,true,736
2552,2014-02-22 05:38:22.684435 +00:00,2014-02-23 02:41:19.684435 +00:00,187.00,true,736
2553,2023-05-24 07:34:57.710992 +00:00,2023-05-31 16:37:38.710992 +00:00,3014.00,true,736
2554,2016-10-26 18:45:06.129755 +00:00,2016-10-26 18:59:33.129755 +00:00,265.00,true,737
2555,2025-05-13 02:30:54.580163 +00:00,2025-05-16 11:55:33.580163 +00:00,2043.00,true,737
2556,2018-03-14 04:49:30.178618 +00:00,2018-03-22 09:18:31.178618 +00:00,2284.00,true,737
2557,2018-10-26 15:31:27.405814 +00:00,2018-11-02 20:33:14.405814 +00:00,1958.00,true,737
2558,2020-07-01 21:12:39.778295 +00:00,2020-07-04 06:15:47.778295 +00:00,2410.00,true,737
2559,2025-03-01 19:41:31.571360 +00:00,2025-03-09 04:23:29.571360 +00:00,1157.00,true,737
2560,2023-06-04 23:59:02.043131 +00:00,2023-06-05 00:08:11.043131 +00:00,3984.00,true,738
2561,2024-02-26 17:31:08.202814 +00:00,2024-03-08 21:47:18.202814 +00:00,3409.00,true,738
2562,2025-08-24 05:32:42.463357 +00:00,2025-08-24 06:49:52.463357 +00:00,12896.00,true,738
2563,2024-07-20 16:38:59.160670 +00:00,2024-07-26 10:09:53.160670 +00:00,2288.00,true,738
2564,2025-09-29 00:07:53.237389 +00:00,2025-09-29 00:20:37.237389 +00:00,6091.00,true,739
2565,2025-10-03 01:51:44.172926 +00:00,,1408.00,false,739
2566,2025-10-01 23:30:38.313293 +00:00,,1305.00,false,739
2567,2024-01-08 14:53:28.493570 +00:00,2024-01-08 15:09:17.493570 +00:00,3851.00,true,740
2568,2025-06-10 02:48:48.052130 +00:00,2025-06-16 10:08:17.052130 +00:00,8316.00,true,740
2569,2025-08-26 20:41:24.243747 +00:00,2025-08-26 20:50:26.243747 +00:00,310.00,true,741
2570,2025-09-13 23:20:30.086484 +00:00,2025-09-13 23:29:37.086484 +00:00,5228.00,true,741
2571,2025-09-28 23:29:26.016307 +00:00,,7378.00,false,741
2572,2025-09-08 04:28:15.762659 +00:00,2025-09-10 03:11:45.762659 +00:00,717.00,true,741
2573,2025-08-30 14:28:26.617289 +00:00,2025-09-07 13:41:33.617289 +00:00,1219.00,true,741
2574,2025-09-06 02:55:32.659954 +00:00,2025-09-16 19:28:17.659954 +00:00,976.00,true,741
2575,2020-07-18 11:22:33.110354 +00:00,2020-07-18 11:29:46.110354 +00:00,2529.00,true,742
2576,2023-06-14 01:14:45.443362 +00:00,2023-06-16 22:23:45.443362 +00:00,1179.00,true,742
2577,2022-05-31 19:17:16.692950 +00:00,2022-06-08 12:31:35.692950 +00:00,537.00,true,742
2578,2024-09-28 04:23:03.794096 +00:00,2024-10-08 20:31:06.794096 +00:00,1442.00,true,742
2579,2021-01-11 18:36:42.993715 +00:00,,8397.00,false,742
2580,2021-06-16 21:21:29.454028 +00:00,2021-06-22 02:38:00.454028 +00:00,1510.00,true,742
2581,2025-09-20 01:34:20.507215 +00:00,2025-09-20 01:42:39.507215 +00:00,1346.00,true,743
2582,2025-09-24 23:55:09.420573 +00:00,2025-09-25 12:34:44.420573 +00:00,1057.00,true,743
2583,2025-09-25 17:14:48.369760 +00:00,2025-09-29 04:29:14.369760 +00:00,440.00,true,743
2584,2025-09-27 17:05:37.977826 +00:00,2025-09-29 16:56:59.977826 +00:00,4647.00,true,743
2585,2025-09-28 02:59:27.465232 +00:00,2025-10-02 23:44:32.465232 +00:00,70.00,true,743
2586,2025-10-03 00:36:04.382761 +00:00,2025-10-03 00:52:54.382761 +00:00,5407.00,true,743
2587,2023-09-28 10:14:11.865578 +00:00,2023-09-28 10:17:36.865578 +00:00,7701.00,true,744
2588,2025-06-15 14:21:09.640032 +00:00,2025-06-16 04:25:56.640032 +00:00,13722.00,true,744
2589,2025-09-09 05:18:06.028574 +00:00,2025-09-09 05:24:33.028574 +00:00,1260.00,true,745
2590,2025-09-10 21:12:22.114625 +00:00,2025-09-20 14:55:08.114625 +00:00,1171.00,true,745
2591,2025-09-14 09:04:14.845829 +00:00,2025-09-23 03:51:53.845829 +00:00,1640.00,true,745
2592,2025-09-13 02:51:25.911912 +00:00,2025-09-18 22:12:26.911912 +00:00,18107.00,true,745
2593,2025-10-04 15:31:14.391659 +00:00,,2157.00,false,745
2594,2025-09-19 21:20:29.340633 +00:00,,18950.00,false,745
2595,2013-07-23 12:52:27.150869 +00:00,2013-07-23 13:03:03.150869 +00:00,1020.00,true,746
2596,2025-05-08 14:33:04.584610 +00:00,2025-05-15 11:02:28.584610 +00:00,5729.00,true,746
2597,2016-05-05 09:48:33.568153 +00:00,2016-05-11 04:58:36.568153 +00:00,4905.00,true,746
2598,2013-09-08 21:08:23.937852 +00:00,2013-09-16 19:03:33.937852 +00:00,1183.00,true,746
2599,2010-09-14 10:32:33.598203 +00:00,2010-09-14 10:42:19.598203 +00:00,14073.00,true,747
2600,2019-01-22 15:27:50.600484 +00:00,2019-01-26 23:27:39.600484 +00:00,22153.00,true,747
2601,2020-03-16 11:46:06.890794 +00:00,2020-03-18 01:05:35.890794 +00:00,10436.00,true,747
2602,2024-03-27 15:17:21.325984 +00:00,2024-04-01 08:22:25.325984 +00:00,1939.00,true,747
2603,2020-06-30 15:23:11.668149 +00:00,2020-06-30 15:30:48.668149 +00:00,8689.00,true,748
2604,2020-11-24 08:29:59.913819 +00:00,2020-12-03 05:22:01.913819 +00:00,9808.00,true,748
2605,2023-07-04 17:19:20.357322 +00:00,,3383.00,false,748
2606,2024-12-23 12:09:55.702907 +00:00,2024-12-24 21:12:53.702907 +00:00,17849.00,true,748
2607,2025-07-06 12:20:51.898386 +00:00,2025-07-16 09:44:24.898386 +00:00,8274.00,true,748
2608,2025-09-11 00:51:26.811424 +00:00,2025-09-11 01:00:39.811424 +00:00,11624.00,true,749
2609,2025-09-19 19:27:36.048622 +00:00,2025-09-29 21:04:03.048622 +00:00,15111.00,true,749
2610,2025-09-28 18:36:16.696922 +00:00,2025-10-02 03:49:43.696922 +00:00,12707.00,true,749
2611,2025-09-18 21:37:02.347885 +00:00,2025-09-23 20:26:06.347885 +00:00,1172.00,true,749
2612,2014-01-22 09:02:18.760542 +00:00,2014-01-22 09:15:03.760542 +00:00,8398.00,true,750
2613,2023-03-25 05:46:21.905083 +00:00,2023-03-25 05:47:52.905083 +00:00,2665.00,true,751
2614,2025-04-19 20:44:16.003564 +00:00,2025-04-23 20:06:37.003564 +00:00,2600.00,true,751
2615,2025-09-08 15:13:45.996978 +00:00,2025-09-08 15:15:29.996978 +00:00,6975.00,true,752
2616,2025-09-23 15:37:19.392326 +00:00,2025-10-03 05:28:12.392326 +00:00,9674.00,true,752
2617,2025-09-30 15:40:55.052364 +00:00,,1914.00,false,752
2618,2025-09-18 04:35:47.361875 +00:00,2025-09-20 17:27:17.361875 +00:00,487.00,true,752
2619,2020-12-17 19:08:18.687746 +00:00,2020-12-17 19:11:27.687746 +00:00,38207.00,true,753
2620,2017-09-26 20:44:49.673436 +00:00,2017-09-26 20:53:42.673436 +00:00,12156.00,true,754
2621,2019-03-04 14:34:18.501507 +00:00,2019-03-05 10:06:54.501507 +00:00,3784.00,true,754
2622,2017-11-10 10:28:30.864267 +00:00,2017-11-10 10:30:44.864267 +00:00,2897.00,true,755
2623,2024-01-24 16:45:07.850052 +00:00,2024-01-30 22:08:02.850052 +00:00,334.00,true,755
2624,2021-01-01 07:24:53.172892 +00:00,2021-01-05 08:52:20.172892 +00:00,772.00,true,755
2625,2024-12-08 02:57:40.058044 +00:00,2024-12-08 06:16:22.058044 +00:00,3592.00,true,755
2626,2023-04-13 11:58:11.573047 +00:00,2023-04-19 14:16:04.573047 +00:00,11772.00,true,755
2627,2018-06-13 06:53:01.105743 +00:00,2018-06-16 14:26:26.105743 +00:00,2245.00,true,755
2628,2025-07-02 05:00:57.724673 +00:00,2025-07-02 05:11:05.724673 +00:00,31043.00,true,756
2629,2025-07-12 18:14:26.837511 +00:00,2025-07-23 04:19:46.837511 +00:00,8847.00,true,756
2630,2012-04-11 06:09:20.308501 +00:00,2012-04-11 06:12:04.308501 +00:00,3348.00,true,757
2631,2020-11-02 21:54:49.053128 +00:00,,12314.00,false,757
2632,2023-09-23 11:52:31.756163 +00:00,2023-09-26 05:01:46.756163 +00:00,18636.00,true,757
2633,2023-10-22 07:11:52.965368 +00:00,2023-10-22 07:19:30.965368 +00:00,447.00,true,758
2634,2024-11-26 18:33:15.168895 +00:00,,182.00,false,758
2635,2024-05-19 23:37:58.453023 +00:00,2024-05-24 04:44:47.453023 +00:00,182.00,true,758
2636,2025-05-22 16:44:33.909569 +00:00,2025-06-02 23:38:34.909569 +00:00,568.00,true,758
2637,2024-02-08 03:26:22.605192 +00:00,2024-02-17 20:49:36.605192 +00:00,21.00,true,758
2638,2020-08-27 07:22:40.237255 +00:00,2020-08-27 07:24:36.237255 +00:00,37.00,true,759
2639,2024-01-03 00:17:01.435590 +00:00,2024-01-13 17:00:19.435590 +00:00,773.00,true,759
2640,2021-01-26 11:39:04.171729 +00:00,2021-01-31 05:19:29.171729 +00:00,38.00,true,759
2641,2022-01-17 05:14:20.192313 +00:00,2022-01-22 23:22:12.192313 +00:00,10.00,true,759
2642,2025-04-22 10:48:11.143182 +00:00,2025-05-03 02:10:11.143182 +00:00,67.00,true,759
2643,2025-07-06 13:39:03.916557 +00:00,2025-07-09 21:18:47.916557 +00:00,53.00,true,759
2644,2025-08-07 07:28:05.100919 +00:00,2025-08-07 07:37:59.100919 +00:00,8533.00,true,760
2645,2025-09-29 05:10:25.179921 +00:00,2025-10-04 14:27:47.179921 +00:00,1784.00,true,760
2646,2025-08-20 16:38:12.546002 +00:00,2025-08-20 20:20:43.546002 +00:00,509.00,true,760
2647,2025-08-27 21:42:55.956244 +00:00,2025-08-30 08:37:57.956244 +00:00,21331.00,true,760
2648,2012-03-20 10:10:43.329774 +00:00,2012-03-20 10:12:53.329774 +00:00,741.00,true,761
2649,2017-07-27 03:19:46.096924 +00:00,2017-07-29 06:18:52.096924 +00:00,14185.00,true,761
2650,2017-07-01 02:16:58.501721 +00:00,2017-07-01 05:23:59.501721 +00:00,1478.00,true,761
2651,2012-03-21 01:54:11.346095 +00:00,2012-03-21 15:15:25.346095 +00:00,13329.00,true,761
2652,2025-06-20 09:32:19.187759 +00:00,2025-06-26 14:10:17.187759 +00:00,37540.00,true,761
2653,2025-07-03 02:08:04.877613 +00:00,2025-07-03 02:16:50.877613 +00:00,73741.00,true,762
2654,2025-07-21 10:08:30.880951 +00:00,2025-07-21 10:09:05.880951 +00:00,1988.00,true,763
2655,2025-08-23 06:10:59.225709 +00:00,2025-08-30 02:34:54.225709 +00:00,5668.00,true,763
2656,2025-08-11 00:58:08.418554 +00:00,2025-08-19 08:57:39.418554 +00:00,5666.00,true,763
2657,2025-09-24 02:53:23.762115 +00:00,2025-09-30 19:26:30.762115 +00:00,235.00,true,763
2658,2025-09-29 14:39:20.235680 +00:00,2025-09-29 14:47:42.235680 +00:00,18583.00,true,764
2659,2025-07-03 20:16:22.306508 +00:00,2025-07-03 20:31:02.306508 +00:00,3629.00,true,765
2660,2025-07-05 02:37:10.344660 +00:00,2025-07-07 17:07:49.344660 +00:00,16580.00,true,765
2661,2025-08-03 07:35:52.672591 +00:00,2025-08-06 14:46:20.672591 +00:00,10655.00,true,765
2662,2025-07-14 07:23:09.005045 +00:00,2025-07-17 09:06:19.005045 +00:00,232.00,true,765
2663,2025-07-20 13:42:19.977331 +00:00,2025-07-31 11:05:56.977331 +00:00,5436.00,true,765
2664,2025-09-08 01:14:59.761916 +00:00,2025-09-13 17:48:05.761916 +00:00,3127.00,true,765
2665,2015-07-18 05:57:51.073061 +00:00,2015-07-18 06:02:38.073061 +00:00,2427.00,true,766
2666,2017-03-24 18:59:14.740231 +00:00,2017-03-30 21:36:03.740231 +00:00,4776.00,true,766
2667,2016-09-04 10:52:32.603889 +00:00,2016-09-08 12:10:06.603889 +00:00,4419.00,true,766
2668,2024-07-05 03:37:24.127794 +00:00,2024-07-09 00:15:43.127794 +00:00,623.00,true,766
2669,2021-01-28 16:47:53.370815 +00:00,2021-02-06 06:40:24.370815 +00:00,264.00,true,766
2670,2025-08-15 00:21:28.740674 +00:00,2025-08-15 00:37:19.740674 +00:00,7152.00,true,767
2671,2025-08-20 18:29:53.726006 +00:00,2025-08-22 03:36:33.726006 +00:00,180.00,true,767
2672,2025-09-11 21:54:53.296666 +00:00,2025-09-16 23:26:10.296666 +00:00,5996.00,true,767
2673,2025-09-10 14:31:12.007555 +00:00,2025-09-11 18:03:40.007555 +00:00,1602.00,true,767
2674,2025-09-20 02:55:54.919411 +00:00,2025-09-24 12:56:33.919411 +00:00,6231.00,true,767
2675,2025-07-29 00:54:24.667502 +00:00,2025-07-29 01:03:23.667502 +00:00,1091.00,true,768
2676,2025-09-01 13:51:38.400923 +00:00,2025-09-04 16:58:59.400923 +00:00,2795.00,true,768
2677,2025-08-13 08:17:27.812364 +00:00,2025-08-15 07:47:53.812364 +00:00,3169.00,true,768
2678,2025-08-04 17:21:15.034468 +00:00,2025-08-14 06:24:38.034468 +00:00,2394.00,true,768
2679,2025-09-04 11:39:20.865470 +00:00,2025-09-11 01:05:40.865470 +00:00,583.00,true,768
2680,2025-08-13 19:40:40.858558 +00:00,2025-08-13 19:40:56.858558 +00:00,78587.00,true,769
2681,2012-10-03 14:51:16.751997 +00:00,2012-10-03 15:00:14.751997 +00:00,1786.00,true,770
2682,2019-08-01 09:44:39.024181 +00:00,2019-08-01 09:45:09.024181 +00:00,760.00,true,771
2683,2023-06-08 19:33:14.444874 +00:00,2023-06-20 02:49:29.444874 +00:00,2672.00,true,771
2684,2023-10-18 03:46:00.777608 +00:00,2023-10-28 16:39:48.777608 +00:00,2246.00,true,771
2685,2025-10-03 03:44:29.749387 +00:00,,3142.00,false,771
2686,2025-05-22 23:09:50.936617 +00:00,2025-05-22 23:24:25.936617 +00:00,31912.00,true,772
2687,2013-11-09 16:19:20.471442 +00:00,2013-11-09 16:33:49.471442 +00:00,19676.00,true,773
2688,2017-12-25 19:15:40.509321 +00:00,2017-12-29 12:07:15.509321 +00:00,21797.00,true,773
2689,2020-05-25 21:03:30.205030 +00:00,2020-06-03 02:07:38.205030 +00:00,11576.00,true,773
2690,2017-11-01 12:14:10.072409 +00:00,2017-11-08 15:17:15.072409 +00:00,5915.00,true,773
2691,2020-12-31 09:43:13.620381 +00:00,2020-12-31 09:53:25.620381 +00:00,707.00,true,774
2692,2021-10-07 04:07:22.848465 +00:00,2021-10-12 17:39:24.848465 +00:00,4950.00,true,774
2693,2022-09-11 10:20:00.483876 +00:00,2022-09-11 10:21:42.483876 +00:00,542.00,true,775
2694,2025-09-25 05:43:38.958080 +00:00,2025-10-01 21:19:03.958080 +00:00,2473.00,true,775
2695,2024-08-31 13:16:20.263180 +00:00,2024-08-31 23:38:45.263180 +00:00,5053.00,true,775
2696,2024-10-09 18:33:52.868801 +00:00,2024-10-09 20:26:00.868801 +00:00,4210.00,true,775
2697,2021-11-23 07:30:37.956698 +00:00,2021-11-23 07:42:47.956698 +00:00,8300.00,true,776
2698,2022-01-07 22:08:24.519722 +00:00,2022-01-10 16:20:25.519722 +00:00,28596.00,true,776
2699,2025-09-30 01:59:34.056154 +00:00,2025-09-30 02:08:28.056154 +00:00,5202.00,true,777
2700,2025-10-03 02:36:27.676731 +00:00,,1152.00,false,777
2701,2025-10-01 10:31:48.014153 +00:00,2025-10-03 07:24:27.014153 +00:00,12692.00,true,777
2702,2010-10-30 21:19:32.046733 +00:00,2010-10-30 21:33:01.046733 +00:00,4018.00,true,778
2703,2012-03-22 11:45:10.091265 +00:00,2012-03-30 15:34:07.091265 +00:00,26108.00,true,778
2704,2015-12-12 20:37:04.136066 +00:00,2015-12-22 10:31:18.136066 +00:00,9425.00,true,778
2705,2016-05-25 17:36:24.666795 +00:00,2016-06-05 08:25:20.666795 +00:00,4284.00,true,778
2706,2015-01-26 05:24:11.481669 +00:00,2015-01-29 01:07:42.481669 +00:00,5859.00,true,778
2707,2018-03-15 07:45:10.987579 +00:00,2018-03-26 11:59:28.987579 +00:00,4090.00,true,778
2708,2013-05-31 09:18:35.720567 +00:00,2013-05-31 09:29:57.720567 +00:00,8961.00,true,779
2709,2021-07-17 00:42:51.777140 +00:00,2021-07-19 19:07:39.777140 +00:00,7176.00,true,779
2710,2022-07-31 10:23:26.415296 +00:00,2022-08-10 14:44:06.415296 +00:00,577.00,true,779
2711,2020-02-23 05:55:26.556395 +00:00,2020-02-23 22:21:10.556395 +00:00,35446.00,true,779
2712,2025-09-26 13:25:01.886997 +00:00,2025-09-26 13:31:41.886997 +00:00,11480.00,true,780
2713,2025-09-26 16:48:19.886698 +00:00,2025-10-02 21:23:50.886698 +00:00,9656.00,true,780
2714,2025-10-02 21:48:56.348621 +00:00,,3803.00,false,780
2715,2025-09-28 21:53:35.424303 +00:00,,6376.00,false,780
2716,2018-02-22 19:16:44.959511 +00:00,2018-02-22 19:31:40.959511 +00:00,103.00,true,781
2717,2018-07-07 22:39:21.361969 +00:00,2018-07-14 16:46:49.361969 +00:00,2367.00,true,781
2718,2023-10-04 16:17:14.966029 +00:00,2023-10-10 05:12:25.966029 +00:00,882.00,true,781
2719,2019-08-16 12:07:58.577781 +00:00,2019-08-25 18:38:09.577781 +00:00,1341.00,true,781
2720,2024-10-22 16:45:02.376290 +00:00,2024-10-29 16:34:18.376290 +00:00,686.00,true,781
2721,2023-04-24 17:54:56.067228 +00:00,2023-04-27 15:45:46.067228 +00:00,515.00,true,781
2722,2022-06-14 16:23:58.288149 +00:00,2022-06-14 16:35:54.288149 +00:00,22964.00,true,782
2723,2022-12-13 23:59:55.789868 +00:00,2022-12-15 23:03:23.789868 +00:00,9743.00,true,782
2724,2023-12-13 18:17:55.847553 +00:00,2023-12-15 20:01:31.847553 +00:00,4609.00,true,782
2725,2022-12-21 00:34:03.948918 +00:00,2022-12-28 10:10:21.948918 +00:00,3137.00,true,782
2726,2025-09-29 11:59:40.937647 +00:00,,18004.00,false,782
2727,2025-08-10 03:07:25.515061 +00:00,2025-08-10 03:09:43.515061 +00:00,8430.00,true,783
2728,2025-09-27 12:24:05.283052 +00:00,2025-09-29 21:22:19.283052 +00:00,1532.00,true,783
2729,2025-09-03 07:55:53.763987 +00:00,2025-09-12 13:56:19.763987 +00:00,19558.00,true,783
2730,2025-09-17 19:54:09.874487 +00:00,2025-09-27 23:09:32.874487 +00:00,24286.00,true,783
2731,2025-09-16 00:15:38.429990 +00:00,2025-09-26 01:26:38.429990 +00:00,9146.00,true,783
2732,2025-10-03 21:14:34.465299 +00:00,2025-10-03 21:26:33.465299 +00:00,132.00,true,784
2733,2025-10-04 15:38:08.263919 +00:00,,7925.00,false,784
2734,2025-10-03 23:56:54.388551 +00:00,,15329.00,false,784
2735,2025-10-04 22:18:23.221566 +00:00,,4968.00,false,784
2736,2025-10-04 22:50:45.114592 +00:00,,7062.00,false,784
2737,2021-12-20 06:04:03.575786 +00:00,2021-12-20 06:15:37.575786 +00:00,772.00,true,785
2738,2024-10-28 16:51:53.864348 +00:00,2024-11-05 07:29:12.864348 +00:00,2166.00,true,785
2739,2025-05-22 05:44:40.925163 +00:00,2025-05-30 15:36:24.925163 +00:00,4389.00,true,785
2740,2023-05-07 17:05:27.867339 +00:00,2023-05-17 09:52:44.867339 +00:00,4608.00,true,785
2741,2024-11-29 14:40:41.183721 +00:00,2024-11-29 14:49:58.183721 +00:00,5084.00,true,786
2742,2025-09-24 03:39:15.176389 +00:00,2025-09-24 03:52:05.176389 +00:00,9003.00,true,787
2743,2025-09-26 12:57:51.566325 +00:00,2025-10-02 01:51:04.566325 +00:00,6239.00,true,787
2744,2025-10-04 03:28:03.112072 +00:00,,19957.00,false,787
2745,2025-09-29 01:50:53.720916 +00:00,2025-10-04 13:10:00.720916 +00:00,7848.00,true,787
2746,2025-08-26 22:22:39.292609 +00:00,2025-08-26 22:35:14.292609 +00:00,4220.00,true,788
2747,2025-10-03 07:20:21.803484 +00:00,2025-10-05 22:18:37.803484 +00:00,1729.00,true,788
2748,2025-09-08 09:52:10.237700 +00:00,2025-09-18 22:08:29.237700 +00:00,123.00,true,788
2749,2025-09-23 09:23:24.760476 +00:00,2025-09-25 20:38:48.760476 +00:00,1537.00,true,788
2750,2025-10-02 23:14:31.421042 +00:00,2025-10-03 05:13:06.421042 +00:00,775.00,true,788
2751,2012-01-09 00:40:14.014854 +00:00,2012-01-09 00:45:20.014854 +00:00,250.00,true,789
2752,2013-08-20 04:35:23.553085 +00:00,2013-08-20 07:41:40.553085 +00:00,148.00,true,789
2753,2019-06-19 05:57:26.620790 +00:00,2019-06-30 19:10:04.620790 +00:00,17.00,true,789
2754,2013-01-17 22:10:36.365603 +00:00,2013-01-25 17:51:47.365603 +00:00,295.00,true,789
2755,2023-06-23 08:16:28.348640 +00:00,2023-07-04 16:08:05.348640 +00:00,905.00,true,789
2756,2021-07-14 02:09:39.377208 +00:00,2021-07-17 06:31:59.377208 +00:00,6.00,true,789
2757,2024-05-28 02:33:02.609024 +00:00,2024-05-28 02:45:57.609024 +00:00,47514.00,true,790
2758,2025-07-15 08:24:58.064677 +00:00,2025-07-25 18:18:48.064677 +00:00,5210.00,true,790
2759,2017-12-19 12:54:10.718651 +00:00,2017-12-19 13:09:49.718651 +00:00,3233.00,true,791
2760,2023-11-22 04:48:26.221116 +00:00,2023-12-01 11:52:01.221116 +00:00,5952.00,true,791
2761,2023-03-26 00:19:29.360440 +00:00,2023-03-28 08:06:26.360440 +00:00,25939.00,true,791
2762,2016-10-04 14:17:00.706143 +00:00,2016-10-04 14:26:26.706143 +00:00,289.00,true,792
2763,2022-11-16 11:03:26.195506 +00:00,2022-11-26 08:34:19.195506 +00:00,15193.00,true,792
2764,2019-06-11 09:57:33.073817 +00:00,2019-06-22 21:16:55.073817 +00:00,5966.00,true,792
2765,2017-07-15 16:12:14.305293 +00:00,2017-07-23 10:39:09.305293 +00:00,3889.00,true,792
2766,2018-02-07 22:05:11.756914 +00:00,2018-02-11 17:35:57.756914 +00:00,18743.00,true,792
2767,2021-05-14 13:34:31.146457 +00:00,,126.00,false,792
2768,2012-11-02 20:43:02.963039 +00:00,2012-11-02 20:49:06.963039 +00:00,21917.00,true,793
2769,2022-01-19 12:18:54.041901 +00:00,2022-01-21 06:21:47.041901 +00:00,7109.00,true,793
2770,2023-10-26 18:59:25.331768 +00:00,2023-10-26 19:11:45.331768 +00:00,947.00,true,794
2771,2025-06-15 04:06:47.816823 +00:00,2025-06-22 06:50:20.816823 +00:00,3430.00,true,794
2772,2024-02-08 03:57:33.794886 +00:00,2024-02-15 14:14:17.794886 +00:00,28073.00,true,794
2773,2023-10-16 23:56:50.837248 +00:00,2023-10-17 00:01:33.837248 +00:00,5624.00,true,795
2774,2024-09-06 05:07:09.974793 +00:00,2024-09-09 19:03:49.974793 +00:00,3422.00,true,795
2775,2024-07-01 22:03:34.261170 +00:00,2024-07-08 17:25:28.261170 +00:00,6224.00,true,795
2776,2024-09-10 01:39:09.752138 +00:00,2024-09-18 20:36:35.752138 +00:00,3810.00,true,795
2777,2024-12-28 07:47:17.538325 +00:00,2025-01-07 13:03:54.538325 +00:00,2771.00,true,795
2778,2025-10-01 20:09:04.458720 +00:00,,2953.00,false,795
2779,2011-02-09 13:45:07.290497 +00:00,2011-02-09 13:46:35.290497 +00:00,12586.00,true,796
2780,2018-09-09 11:53:30.479979 +00:00,,22117.00,false,796
2781,2020-04-27 12:07:06.557795 +00:00,2020-05-01 00:11:35.557795 +00:00,2555.00,true,796
2782,2018-08-08 10:15:50.524889 +00:00,2018-08-13 21:31:02.524889 +00:00,5881.00,true,796
2783,2014-05-28 16:49:08.329223 +00:00,2014-05-31 08:18:14.329223 +00:00,4575.00,true,796
2784,2014-01-10 20:58:27.237851 +00:00,2014-01-11 05:42:22.237851 +00:00,15640.00,true,796
2785,2017-02-17 07:43:40.234144 +00:00,2017-02-17 07:46:16.234144 +00:00,2713.00,true,797
2786,2025-01-26 06:34:16.555053 +00:00,2025-01-29 18:46:55.555053 +00:00,11070.00,true,797
2787,2017-11-16 18:16:05.361921 +00:00,2017-11-21 09:31:18.361921 +00:00,4422.00,true,797
2788,2018-07-21 20:12:28.545486 +00:00,2018-07-21 20:22:27.545486 +00:00,4697.00,true,798
2789,2022-03-16 16:09:48.359523 +00:00,2022-03-19 11:11:10.359523 +00:00,4665.00,true,798
2790,2023-05-06 17:31:20.048974 +00:00,2023-05-14 13:05:06.048974 +00:00,1407.00,true,798
2791,2022-04-13 04:33:43.278278 +00:00,2022-04-19 12:44:07.278278 +00:00,3697.00,true,798
2792,2016-06-02 14:05:34.816329 +00:00,2016-06-02 14:20:57.816329 +00:00,2595.00,true,799
2793,2023-08-13 12:52:11.276049 +00:00,2023-08-18 17:39:24.276049 +00:00,6916.00,true,799
2794,2017-03-12 20:17:13.543626 +00:00,2017-03-12 22:29:43.543626 +00:00,15086.00,true,799
2795,2021-02-28 04:39:34.208030 +00:00,2021-03-07 01:07:49.208030 +00:00,8205.00,true,799
2796,2024-05-13 18:39:53.567206 +00:00,2024-05-23 04:38:58.567206 +00:00,4128.00,true,799
2797,2013-07-14 09:56:16.568305 +00:00,2013-07-14 10:10:19.568305 +00:00,388.00,true,800
2798,2016-05-24 20:27:54.814417 +00:00,2016-06-04 15:13:10.814417 +00:00,8840.00,true,800
2799,2025-09-29 10:25:32.093155 +00:00,2025-09-29 10:38:45.093155 +00:00,20311.00,true,801
2800,2025-10-04 06:41:11.579188 +00:00,2025-10-04 18:14:35.579188 +00:00,16200.00,true,801
2801,2025-10-04 15:09:08.268186 +00:00,,12318.00,false,801
2802,2025-02-21 18:24:32.040858 +00:00,2025-02-21 18:40:01.040858 +00:00,996.00,true,802
2803,2025-05-08 14:46:02.195852 +00:00,2025-05-13 17:21:24.195852 +00:00,1680.00,true,802
2804,2025-09-23 02:40:23.929086 +00:00,2025-09-26 01:48:24.929086 +00:00,1561.00,true,802
2805,2025-05-21 03:18:13.074045 +00:00,2025-05-24 13:34:10.074045 +00:00,23.00,true,802
2806,2025-03-20 08:56:42.397508 +00:00,2025-03-30 00:15:13.397508 +00:00,939.00,true,802
2807,2025-02-22 17:32:27.098841 +00:00,2025-03-05 11:10:22.098841 +00:00,281.00,true,802
2808,2025-07-03 20:12:30.772338 +00:00,2025-07-03 20:23:37.772338 +00:00,5953.00,true,803
2809,2025-09-02 20:12:07.736278 +00:00,2025-09-10 17:27:13.736278 +00:00,22041.00,true,803
2810,2025-09-01 23:04:09.550040 +00:00,2025-09-12 12:27:57.550040 +00:00,34807.00,true,803
2811,2012-11-19 03:18:01.405915 +00:00,2012-11-19 03:26:42.405915 +00:00,282.00,true,804
2812,2025-06-21 06:35:56.495011 +00:00,2025-06-26 07:06:49.495011 +00:00,146.00,true,804
2813,2021-09-20 23:22:05.406809 +00:00,2021-09-25 21:59:02.406809 +00:00,401.00,true,804
2814,2020-03-10 08:28:16.243166 +00:00,2020-03-19 02:09:16.243166 +00:00,981.00,true,804
2815,2013-05-03 00:03:59.455461 +00:00,2013-05-10 02:21:23.455461 +00:00,162.00,true,804
2816,2024-03-13 18:40:20.273139 +00:00,2024-03-13 18:44:40.273139 +00:00,9266.00,true,805
2817,2024-04-28 20:19:40.283203 +00:00,2024-05-04 05:32:37.283203 +00:00,37569.00,true,805
2818,2014-02-01 00:50:19.195125 +00:00,2014-02-01 01:05:22.195125 +00:00,904.00,true,806
2819,2020-07-18 05:09:54.520205 +00:00,2020-07-26 12:40:36.520205 +00:00,2332.00,true,806
2820,2025-09-05 05:38:59.611410 +00:00,2025-09-09 21:13:10.611410 +00:00,3636.00,true,806
2821,2015-07-02 13:15:15.954811 +00:00,,519.00,false,806
2822,2023-07-04 21:31:38.358376 +00:00,2023-07-08 23:20:06.358376 +00:00,155.00,true,806
2823,2025-09-08 20:53:03.226651 +00:00,2025-09-08 20:53:22.226651 +00:00,65560.00,true,807
2824,2010-10-14 03:36:13.408617 +00:00,2010-10-14 03:42:19.408617 +00:00,848.00,true,808
2825,2025-08-16 08:43:04.991805 +00:00,2025-08-18 19:11:01.991805 +00:00,119.00,true,808
2826,2018-09-07 01:25:58.981206 +00:00,2018-09-13 22:55:00.981206 +00:00,3017.00,true,808
2827,2025-06-05 01:13:17.877311 +00:00,2025-06-05 01:23:19.877311 +00:00,16563.00,true,809
2828,2025-08-01 15:36:48.302737 +00:00,2025-08-06 00:45:59.302737 +00:00,4190.00,true,809
2829,2025-08-29 00:31:08.401345 +00:00,2025-08-30 22:45:25.401345 +00:00,4885.00,true,809
2830,2025-08-29 07:01:30.076364 +00:00,2025-09-04 07:24:36.076364 +00:00,2931.00,true,809
2831,2025-09-07 20:31:58.413189 +00:00,2025-09-19 08:54:19.413189 +00:00,3209.00,true,809
2832,2021-08-23 14:38:13.267322 +00:00,2021-08-23 14:50:21.267322 +00:00,13947.00,true,810
2833,2023-12-01 14:01:45.810380 +00:00,2023-12-05 12:56:28.810380 +00:00,53811.00,true,810
2834,2022-11-18 07:36:18.482934 +00:00,2022-11-18 07:47:25.482934 +00:00,3025.00,true,811
2835,2024-10-08 04:56:52.088127 +00:00,2024-10-14 18:54:42.088127 +00:00,363.00,true,811
2836,2022-11-20 01:06:13.958669 +00:00,2022-11-26 17:55:54.958669 +00:00,1820.00,true,811
2837,2025-09-14 08:14:46.279768 +00:00,2025-09-24 10:11:57.279768 +00:00,2514.00,true,811
2838,2024-01-21 21:14:09.452481 +00:00,,102.00,false,811
2839,2024-10-10 05:09:27.970946 +00:00,2024-10-11 08:06:35.970946 +00:00,859.00,true,811
2840,2018-10-25 15:57:08.258507 +00:00,2018-10-25 15:59:34.258507 +00:00,23919.00,true,812
2841,2022-08-04 15:03:01.591683 +00:00,2022-08-10 13:02:16.591683 +00:00,11501.00,true,812
2842,2019-09-29 09:47:29.012742 +00:00,2019-10-10 18:28:31.012742 +00:00,7815.00,true,812
2843,2022-08-01 06:42:27.684822 +00:00,2022-08-05 12:51:21.684822 +00:00,5845.00,true,812
2844,2016-02-17 14:01:24.795396 +00:00,2016-02-17 14:12:14.795396 +00:00,2371.00,true,813
2845,2020-07-24 04:16:42.274500 +00:00,2020-07-26 05:00:18.274500 +00:00,3262.00,true,813
2846,2022-01-27 20:05:41.357579 +00:00,2022-02-03 21:27:03.357579 +00:00,5191.00,true,813
2847,2023-12-31 11:26:01.537016 +00:00,2023-12-31 11:40:34.537016 +00:00,34212.00,true,814
2848,2025-07-07 18:16:40.068832 +00:00,2025-07-07 18:22:10.068832 +00:00,27828.00,true,815
2849,2025-01-13 01:52:38.993573 +00:00,2025-01-13 02:02:09.993573 +00:00,6541.00,true,816
2850,2025-07-11 22:28:14.508276 +00:00,2025-07-12 17:50:53.508276 +00:00,688.00,true,816
2851,2025-03-06 16:13:33.450454 +00:00,2025-03-16 14:24:05.450454 +00:00,682.00,true,816
2852,2025-03-21 20:23:59.386551 +00:00,2025-04-02 00:35:16.386551 +00:00,3199.00,true,816
2853,2025-05-13 06:53:39.859806 +00:00,2025-05-24 09:26:45.859806 +00:00,6118.00,true,816
2854,2025-07-11 11:32:28.027495 +00:00,2025-07-20 17:46:20.027495 +00:00,2162.00,true,816
2855,2022-12-24 17:08:05.225554 +00:00,2022-12-24 17:08:18.225554 +00:00,15493.00,true,817
2856,2024-11-23 08:27:16.428756 +00:00,2024-11-29 05:55:26.428756 +00:00,6834.00,true,817
2857,2024-07-24 23:06:31.488957 +00:00,2024-07-28 14:05:51.488957 +00:00,6390.00,true,817
2858,2018-12-11 07:45:12.512154 +00:00,2018-12-11 07:49:59.512154 +00:00,8831.00,true,818
2859,2025-09-21 01:48:58.526119 +00:00,2025-09-30 20:09:53.526119 +00:00,1506.00,true,818
2860,2023-08-20 09:05:56.176578 +00:00,2023-08-25 04:57:11.176578 +00:00,3068.00,true,818
2861,2012-11-22 18:00:32.457675 +00:00,2012-11-22 18:01:34.457675 +00:00,822.00,true,819
2862,2020-12-08 01:32:34.930293 +00:00,2020-12-16 00:09:09.930293 +00:00,721.00,true,819
2863,2018-05-04 13:26:28.998018 +00:00,2018-05-05 17:41:43.998018 +00:00,1644.00,true,819
2864,2020-08-25 22:14:25.393864 +00:00,2020-08-26 02:21:35.393864 +00:00,4795.00,true,819
2865,2012-07-05 22:36:20.691984 +00:00,2012-07-05 22:41:52.691984 +00:00,43337.00,true,820
2866,2011-07-08 03:10:44.036605 +00:00,2011-07-08 03:15:24.036605 +00:00,8628.00,true,821
2867,2020-03-07 12:10:30.955035 +00:00,2020-03-17 10:59:02.955035 +00:00,9137.00,true,821
2868,2012-01-27 13:25:18.979970 +00:00,2012-01-31 09:17:32.979970 +00:00,11890.00,true,821
2869,2016-12-21 11:08:37.003030 +00:00,2016-12-21 11:24:05.003030 +00:00,380.00,true,822
2870,2024-12-18 17:56:03.574259 +00:00,2024-12-24 09:52:06.574259 +00:00,9084.00,true,822
2871,2025-06-28 05:27:45.687081 +00:00,2025-07-03 07:49:22.687081 +00:00,31617.00,true,822
2872,2015-07-07 13:43:30.919765 +00:00,2015-07-07 13:56:47.919765 +00:00,2286.00,true,823
2873,2016-03-23 18:20:12.282499 +00:00,2016-04-01 07:24:28.282499 +00:00,119.00,true,823
2874,2020-03-22 08:24:10.398047 +00:00,2020-03-24 22:06:27.398047 +00:00,301.00,true,823
2875,2024-07-27 15:50:12.973870 +00:00,2024-08-03 01:20:09.973870 +00:00,350.00,true,823
2876,2020-05-05 05:44:13.353936 +00:00,2020-05-12 09:55:48.353936 +00:00,1336.00,true,823
2877,2016-12-24 08:25:40.070759 +00:00,2016-12-24 08:28:12.070759 +00:00,17620.00,true,824
2878,2020-12-11 00:06:29.124109 +00:00,2020-12-13 08:14:54.124109 +00:00,34548.00,true,824
2879,2025-08-27 10:33:27.581960 +00:00,2025-08-27 10:38:27.581960 +00:00,3837.00,true,825
2880,2025-09-22 22:21:02.007052 +00:00,2025-09-29 09:36:16.007052 +00:00,6656.00,true,825
2881,2025-08-31 17:44:09.741776 +00:00,2025-09-01 12:22:39.741776 +00:00,1674.00,true,825
2882,2025-09-14 04:25:35.383889 +00:00,2025-09-18 02:46:03.383889 +00:00,3213.00,true,825
2883,2019-03-16 04:02:22.302434 +00:00,2019-03-16 04:13:35.302434 +00:00,2280.00,true,826
2884,2019-04-08 15:33:23.945342 +00:00,2019-04-08 15:34:24.945342 +00:00,2586.00,true,827
2885,2024-10-05 01:07:01.346393 +00:00,2024-10-15 05:15:13.346393 +00:00,7271.00,true,827
2886,2018-03-12 00:04:14.215487 +00:00,2018-03-12 00:05:24.215487 +00:00,4823.00,true,828
2887,2023-01-02 11:48:08.863704 +00:00,2023-01-07 11:45:43.863704 +00:00,2473.00,true,828
2888,2022-04-19 22:15:34.802603 +00:00,2022-04-20 19:09:51.802603 +00:00,3242.00,true,828
2889,2023-05-31 19:32:44.843770 +00:00,2023-06-02 06:41:45.843770 +00:00,11696.00,true,828
2890,2023-10-30 05:19:23.261795 +00:00,2023-11-10 18:00:21.261795 +00:00,22557.00,true,828
2891,2021-02-01 20:00:23.553017 +00:00,2021-02-02 05:34:35.553017 +00:00,5327.00,true,828
2892,2025-07-20 14:12:13.338658 +00:00,2025-07-20 14:16:31.338658 +00:00,7236.00,true,829
2893,2025-07-26 07:21:24.496939 +00:00,2025-07-28 16:43:39.496939 +00:00,7650.00,true,829
2894,2025-08-18 14:13:23.752985 +00:00,2025-08-26 11:42:54.752985 +00:00,430.00,true,829
2895,2025-09-01 09:28:04.020685 +00:00,2025-09-09 04:38:42.020685 +00:00,681.00,true,829
2896,2025-09-16 03:33:36.224547 +00:00,2025-09-27 17:20:04.224547 +00:00,9662.00,true,829
2897,2025-09-17 17:03:09.460049 +00:00,2025-09-29 04:10:59.460049 +00:00,3828.00,true,829
2898,2011-10-27 02:12:56.975266 +00:00,2011-10-27 02:19:38.975266 +00:00,27242.00,true,830
2899,2018-11-20 07:08:52.335689 +00:00,2018-11-20 07:10:35.335689 +00:00,1493.00,true,831
2900,2023-12-14 00:20:27.608875 +00:00,2023-12-19 11:37:59.608875 +00:00,7693.00,true,831
2901,2021-08-27 14:25:55.193117 +00:00,2021-09-06 06:32:34.193117 +00:00,2893.00,true,831
2902,2019-08-10 02:01:25.109075 +00:00,2019-08-12 05:02:56.109075 +00:00,3654.00,true,831
2903,2023-10-25 04:29:48.641464 +00:00,,12811.00,false,831
2904,2023-11-10 02:33:33.231668 +00:00,2023-11-21 05:51:21.231668 +00:00,1317.00,true,831
2905,2017-06-27 12:08:42.752747 +00:00,2017-06-27 12:11:58.752747 +00:00,13774.00,true,832
2906,2020-06-14 19:30:31.179713 +00:00,2020-06-19 06:44:46.179713 +00:00,3324.00,true,832
2907,2023-02-14 10:53:31.035602 +00:00,2023-02-16 10:53:49.035602 +00:00,2584.00,true,832
2908,2022-08-13 01:00:07.410020 +00:00,2022-08-13 09:02:43.410020 +00:00,2774.00,true,832
2909,2012-03-17 06:20:22.814673 +00:00,2012-03-17 06:32:57.814673 +00:00,485.00,true,833
2910,2025-06-30 20:49:36.141081 +00:00,2025-07-07 08:13:55.141081 +00:00,511.00,true,833
2911,2015-01-19 11:36:11.503605 +00:00,,2228.00,false,833
2912,2024-11-11 13:27:13.337795 +00:00,2024-11-21 06:24:26.337795 +00:00,5485.00,true,833
2913,2014-01-01 00:14:57.563962 +00:00,2014-01-05 15:57:37.563962 +00:00,1620.00,true,833
2914,2015-04-05 07:45:43.833054 +00:00,2015-04-05 08:02:02.833054 +00:00,30028.00,true,834
2915,2019-11-19 21:34:39.797969 +00:00,2019-11-24 06:26:52.797969 +00:00,75.00,true,834
2916,2017-08-26 04:26:00.867162 +00:00,2017-09-01 17:56:32.867162 +00:00,648.00,true,834
2917,2010-05-23 23:38:50.420070 +00:00,2010-05-23 23:52:08.420070 +00:00,15668.00,true,835
2918,2019-12-21 23:51:21.286839 +00:00,2019-12-26 20:50:59.286839 +00:00,12899.00,true,835
2919,2016-08-08 16:35:09.357134 +00:00,2016-08-08 16:43:14.357134 +00:00,5040.00,true,836
2920,2023-11-28 20:12:18.788496 +00:00,2023-12-02 23:03:37.788496 +00:00,543.00,true,836
2921,2025-08-08 16:13:52.563743 +00:00,2025-08-18 05:18:41.563743 +00:00,2619.00,true,836
2922,2024-06-16 10:36:20.134831 +00:00,2024-06-27 01:58:49.134831 +00:00,116.00,true,836
2923,2024-02-23 03:36:35.600364 +00:00,2024-02-23 23:56:39.600364 +00:00,3700.00,true,836
2924,2020-12-28 06:24:53.740557 +00:00,2020-12-28 06:37:40.740557 +00:00,21768.00,true,837
2925,2022-01-15 13:24:51.372246 +00:00,2022-01-25 22:00:24.372246 +00:00,18997.00,true,837
2926,2020-12-20 01:59:12.412865 +00:00,2020-12-20 02:10:21.412865 +00:00,9465.00,true,838
2927,2022-07-31 05:55:41.643293 +00:00,2022-08-10 05:27:27.643293 +00:00,9138.00,true,838
2928,2022-11-05 01:44:44.949376 +00:00,2022-11-06 03:09:16.949376 +00:00,14004.00,true,838
2929,2021-12-05 19:19:56.499590 +00:00,2021-12-13 05:55:52.499590 +00:00,5978.00,true,838
2930,2021-01-11 02:19:17.928533 +00:00,2021-01-11 02:29:02.928533 +00:00,63567.00,true,839
2931,2010-08-05 11:33:45.918647 +00:00,2010-08-05 11:39:19.918647 +00:00,5625.00,true,840
2932,2024-04-19 16:49:17.089837 +00:00,2024-04-27 08:54:06.089837 +00:00,27793.00,true,840
2933,2015-05-23 23:04:45.599599 +00:00,2015-05-23 23:06:56.599599 +00:00,3820.00,true,841
2934,2018-08-14 21:06:01.868948 +00:00,2018-08-16 04:10:52.868948 +00:00,1725.00,true,841
2935,2022-04-26 11:28:50.778987 +00:00,2022-04-29 21:47:37.778987 +00:00,458.00,true,841
2936,2015-10-05 14:06:19.038028 +00:00,2015-10-09 11:09:33.038028 +00:00,671.00,true,841
2937,2025-01-20 07:43:20.795509 +00:00,2025-01-24 04:42:39.795509 +00:00,732.00,true,841
2938,2025-07-30 02:24:14.260090 +00:00,2025-07-30 02:40:24.260090 +00:00,12514.00,true,842
2939,2025-08-19 21:30:20.137023 +00:00,2025-08-25 14:04:11.137023 +00:00,15621.00,true,842
2940,2025-09-25 09:50:02.724090 +00:00,2025-09-26 11:55:50.724090 +00:00,15425.00,true,842
2941,2025-09-09 00:47:38.107285 +00:00,2025-09-11 12:54:19.107285 +00:00,2528.00,true,842
2942,2025-09-05 06:47:16.110399 +00:00,2025-09-13 17:22:10.110399 +00:00,8125.00,true,842
2943,2025-08-11 11:05:44.473076 +00:00,2025-08-15 14:58:47.473076 +00:00,12671.00,true,842
2944,2013-09-17 15:30:22.829181 +00:00,2013-09-17 15:35:12.829181 +00:00,13374.00,true,843
2945,2025-08-26 14:43:04.264871 +00:00,2025-08-26 14:55:11.264871 +00:00,515.00,true,844
2946,2025-08-27 02:02:53.932308 +00:00,2025-09-03 04:43:43.932308 +00:00,2611.00,true,844
2947,2012-01-07 12:46:42.099747 +00:00,2012-01-07 13:01:27.099747 +00:00,97.00,true,845
2948,2014-04-12 11:07:43.032688 +00:00,2014-04-15 04:03:23.032688 +00:00,398.00,true,845
2949,2019-04-15 09:44:38.859765 +00:00,2019-04-16 20:57:07.859765 +00:00,39.00,true,845
2950,2019-07-29 23:23:42.365664 +00:00,2019-08-06 10:54:45.365664 +00:00,446.00,true,845
2951,2017-07-20 00:23:27.290433 +00:00,2017-07-20 00:37:27.290433 +00:00,138.00,true,846
2952,2021-12-14 13:38:07.110388 +00:00,2021-12-21 09:24:39.110388 +00:00,95.00,true,846
2953,2019-11-13 21:43:07.406829 +00:00,2019-11-20 09:15:32.406829 +00:00,19.00,true,846
2954,2018-02-23 19:08:48.170906 +00:00,2018-02-23 19:10:35.170906 +00:00,8335.00,true,847
2955,2023-11-18 06:23:20.348094 +00:00,2023-11-23 02:00:50.348094 +00:00,37658.00,true,847
2956,2022-08-09 19:37:40.493829 +00:00,2022-08-09 19:39:05.493829 +00:00,15422.00,true,848
2957,2025-01-06 07:05:16.663851 +00:00,2025-01-09 16:19:33.663851 +00:00,11544.00,true,848
2958,2023-11-16 06:00:37.615840 +00:00,2023-11-26 20:22:54.615840 +00:00,4945.00,true,848
2959,2024-10-24 14:03:01.059388 +00:00,2024-10-31 01:25:21.059388 +00:00,2880.00,true,848
2960,2023-06-11 16:25:11.548133 +00:00,2023-06-17 23:13:00.548133 +00:00,6265.00,true,848
2961,2023-03-20 07:59:35.746653 +00:00,2023-03-30 05:00:11.746653 +00:00,3608.00,true,848
2962,2021-12-26 23:06:53.092127 +00:00,2021-12-26 23:21:14.092127 +00:00,1585.00,true,849
2963,2025-09-15 23:23:18.131565 +00:00,2025-09-26 03:52:28.131565 +00:00,4020.00,true,849
2964,2024-09-30 00:52:51.771484 +00:00,2024-10-04 18:48:19.771484 +00:00,12.00,true,849
2965,2025-08-28 19:48:26.263033 +00:00,2025-08-29 14:58:04.263033 +00:00,21.00,true,849
2966,2023-07-12 08:40:52.127168 +00:00,2023-07-12 08:55:31.127168 +00:00,5173.00,true,850
2967,2024-12-24 13:21:19.215921 +00:00,2024-12-29 07:14:21.215921 +00:00,14328.00,true,850
2968,2025-01-15 02:31:16.693003 +00:00,2025-01-20 08:34:24.693003 +00:00,16517.00,true,850
2969,2024-09-04 12:03:15.905203 +00:00,2024-09-07 01:28:04.905203 +00:00,25914.00,true,850
2970,2012-05-30 23:11:46.087652 +00:00,2012-05-30 23:24:56.087652 +00:00,1251.00,true,851
2971,2017-06-01 00:17:06.304641 +00:00,2017-06-08 05:17:01.304641 +00:00,2217.00,true,851
2972,2018-04-11 14:58:46.659766 +00:00,2018-04-16 23:20:33.659766 +00:00,45.00,true,851
2973,2013-08-10 06:44:05.093550 +00:00,2013-08-18 13:15:29.093550 +00:00,3615.00,true,851
2974,2024-05-10 20:47:42.397072 +00:00,2024-05-19 00:31:57.397072 +00:00,3924.00,true,851
2975,2016-10-13 09:05:53.833428 +00:00,2016-10-21 06:42:40.833428 +00:00,3154.00,true,851
2976,2025-07-01 08:26:32.969841 +00:00,2025-07-01 08:37:08.969841 +00:00,22.00,true,852
2977,2025-09-23 22:17:31.672991 +00:00,2025-10-02 07:35:04.672991 +00:00,9.00,true,852
2978,2025-10-03 08:49:11.149909 +00:00,,1459.00,false,852
2979,2025-08-24 16:46:26.557472 +00:00,2025-08-24 19:29:50.557472 +00:00,125.00,true,852
2980,2025-08-10 02:19:52.589602 +00:00,2025-08-10 18:16:00.589602 +00:00,387.00,true,852
2981,2025-10-04 15:32:27.704177 +00:00,,414.00,false,852
2982,2018-10-18 00:26:53.892438 +00:00,2018-10-18 00:36:16.892438 +00:00,1162.00,true,853
2983,2023-08-18 16:03:54.375943 +00:00,2023-08-29 23:06:41.375943 +00:00,5997.00,true,853
2984,2022-10-15 06:38:57.083258 +00:00,2022-10-20 21:54:22.083258 +00:00,7418.00,true,853
2985,2021-03-15 03:10:20.691235 +00:00,2021-03-23 06:38:40.691235 +00:00,1230.00,true,853
2986,2011-03-14 14:33:53.412102 +00:00,2011-03-14 14:41:00.412102 +00:00,16562.00,true,854
2987,2020-07-28 13:58:56.241760 +00:00,2020-07-28 14:11:44.241760 +00:00,771.00,true,855
2988,2021-06-29 01:56:24.708174 +00:00,2021-07-07 03:34:50.708174 +00:00,187.00,true,855
2989,2022-12-01 03:43:14.217002 +00:00,2022-12-04 14:06:21.217002 +00:00,4332.00,true,855
2990,2018-07-05 14:16:29.743320 +00:00,2018-07-05 14:21:07.743320 +00:00,6251.00,true,856
2991,2018-09-20 20:01:34.181492 +00:00,2018-09-27 11:03:42.181492 +00:00,12760.00,true,856
2992,2025-07-13 21:35:09.380040 +00:00,2025-07-13 21:45:32.380040 +00:00,2922.00,true,857
2993,2025-07-22 23:27:59.563874 +00:00,2025-08-03 10:16:40.563874 +00:00,371.00,true,857
2994,2025-08-06 02:50:38.534511 +00:00,2025-08-08 19:07:30.534511 +00:00,6408.00,true,857
2995,2025-08-09 00:14:25.033272 +00:00,2025-08-14 19:12:45.033272 +00:00,12163.00,true,857
2996,2025-08-30 14:48:03.206980 +00:00,2025-08-30 15:01:28.206980 +00:00,19076.00,true,858
2997,2025-10-04 06:57:45.625831 +00:00,,32796.00,false,858
2998,2025-09-30 12:49:50.451126 +00:00,2025-10-04 12:29:07.451126 +00:00,4772.00,true,858
2999,2025-09-25 09:30:46.761975 +00:00,2025-10-05 17:16:55.761975 +00:00,974.00,true,858
3000,2025-09-12 17:24:54.696612 +00:00,2025-09-13 14:32:11.696612 +00:00,3897.00,true,858
3001,2013-05-28 08:20:06.572680 +00:00,2013-05-28 08:25:26.572680 +00:00,4790.00,true,859
3002,2017-10-13 10:49:31.292483 +00:00,2017-10-17 23:23:55.292483 +00:00,576.00,true,859
3003,2023-09-11 11:07:43.179117 +00:00,2023-09-11 18:03:19.179117 +00:00,1977.00,true,859
3004,2016-07-06 06:38:26.333936 +00:00,2016-07-15 22:56:47.333936 +00:00,635.00,true,859
3005,2014-04-01 12:56:10.465586 +00:00,2014-04-01 12:57:58.465586 +00:00,47209.00,true,860
3006,2019-07-10 10:01:12.719874 +00:00,2019-07-10 10:04:28.719874 +00:00,7097.00,true,861
3007,2025-03-23 23:58:27.611015 +00:00,2025-04-03 06:59:00.611015 +00:00,2906.00,true,861
3008,2025-06-08 20:36:55.390816 +00:00,2025-06-17 02:19:10.390816 +00:00,1169.00,true,861
3009,2024-03-07 01:11:14.514967 +00:00,2024-03-08 07:48:35.514967 +00:00,7460.00,true,861
3010,2024-09-27 07:13:52.291655 +00:00,2024-09-28 04:15:56.291655 +00:00,1973.00,true,861
3011,2023-06-01 11:14:00.212708 +00:00,,5013.00,false,861
3012,2016-08-26 11:17:45.050924 +00:00,2016-08-26 11:21:00.050924 +00:00,6730.00,true,862
3013,2021-09-26 20:58:14.296866 +00:00,2021-10-08 04:31:27.296866 +00:00,7920.00,true,862
3014,2018-09-04 13:54:19.730550 +00:00,,6242.00,false,862
3015,2020-12-18 06:18:53.804852 +00:00,2020-12-27 22:12:18.804852 +00:00,7890.00,true,862
3016,2025-05-30 02:20:54.974533 +00:00,2025-05-31 01:38:40.974533 +00:00,3279.00,true,862
3017,2018-07-28 00:07:56.304872 +00:00,2018-08-02 17:13:00.304872 +00:00,445.00,true,862
3018,2014-04-27 01:38:25.143050 +00:00,2014-04-27 01:40:16.143050 +00:00,3663.00,true,863
3019,2023-07-18 16:02:54.920742 +00:00,2023-07-20 11:44:04.920742 +00:00,11187.00,true,863
3020,2021-06-26 12:39:28.335758 +00:00,2021-06-28 16:21:03.335758 +00:00,7441.00,true,863
3021,2025-09-26 11:13:04.556777 +00:00,2025-09-26 11:16:45.556777 +00:00,9830.00,true,864
3022,2025-10-01 08:05:55.998146 +00:00,,8167.00,false,864
3023,2025-09-29 07:58:20.747925 +00:00,2025-10-04 04:16:13.747925 +00:00,25848.00,true,864
3024,2025-09-29 05:11:49.962799 +00:00,,16691.00,false,864
3025,2025-09-16 01:40:17.883912 +00:00,2025-09-16 01:43:19.883912 +00:00,13869.00,true,865
3026,2025-09-19 13:48:29.094979 +00:00,2025-09-30 01:13:12.094979 +00:00,607.00,true,865
3027,2025-09-18 12:41:12.659071 +00:00,2025-09-29 15:40:22.659071 +00:00,37.00,true,865
3028,2017-01-12 15:38:15.147014 +00:00,2017-01-12 15:41:09.147014 +00:00,14772.00,true,866
3029,2025-10-04 03:39:21.725108 +00:00,2025-10-04 03:53:45.725108 +00:00,41280.00,true,867
3030,2011-07-16 06:28:05.555300 +00:00,2011-07-16 06:33:57.555300 +00:00,5919.00,true,868
3031,2020-07-14 20:34:08.209871 +00:00,2020-07-19 12:21:59.209871 +00:00,848.00,true,868
3032,2016-04-04 00:51:53.494887 +00:00,2016-04-11 20:52:02.494887 +00:00,1594.00,true,868
3033,2015-03-13 01:08:42.845699 +00:00,2015-03-16 21:21:38.845699 +00:00,7441.00,true,868
3034,2014-05-27 15:22:16.354171 +00:00,2014-05-29 04:47:32.354171 +00:00,1420.00,true,868
3035,2018-10-23 18:54:18.816794 +00:00,2018-10-26 16:32:12.816794 +00:00,3216.00,true,868
3036,2024-05-27 21:04:39.196730 +00:00,2024-05-27 21:08:49.196730 +00:00,20708.00,true,869
3037,2021-05-04 02:45:31.026593 +00:00,2021-05-04 02:45:58.026593 +00:00,5649.00,true,870
3038,2022-06-18 23:26:08.223091 +00:00,2022-06-29 15:40:10.223091 +00:00,54.00,true,870
3039,2024-08-04 21:41:07.032092 +00:00,2024-08-13 04:47:59.032092 +00:00,3564.00,true,870
3040,2025-04-22 19:04:04.412432 +00:00,2025-05-01 09:38:15.412432 +00:00,3656.00,true,870
3041,2025-09-21 04:19:16.288320 +00:00,2025-09-21 04:27:53.288320 +00:00,8176.00,true,871
3042,2025-09-23 15:19:58.470915 +00:00,2025-09-27 14:22:06.470915 +00:00,2319.00,true,871
3043,2025-09-22 21:31:14.890840 +00:00,2025-10-01 05:01:13.890840 +00:00,4958.00,true,871
3044,2025-10-01 06:48:46.291569 +00:00,2025-10-02 19:56:18.291569 +00:00,3693.00,true,871
3045,2015-07-30 01:32:11.776283 +00:00,2015-07-30 01:38:41.776283 +00:00,1806.00,true,872
3046,2022-04-08 15:24:35.012138 +00:00,2022-04-17 00:39:09.012138 +00:00,61.00,true,872
3047,2020-12-07 07:02:44.293531 +00:00,2020-12-16 17:13:04.293531 +00:00,256.00,true,872
3048,2022-09-03 08:36:37.682450 +00:00,2022-09-13 22:39:45.682450 +00:00,435.00,true,872
3049,2016-11-04 15:33:12.880954 +00:00,2016-11-09 21:38:51.880954 +00:00,472.00,true,872
3050,2018-04-05 04:47:05.431146 +00:00,2018-04-05 04:49:52.431146 +00:00,366.00,true,873
3051,2021-04-26 00:55:11.039365 +00:00,2021-05-04 11:31:14.039365 +00:00,6581.00,true,873
3052,2022-05-17 03:17:53.903005 +00:00,2022-05-24 01:49:40.903005 +00:00,19485.00,true,873
3053,2023-05-22 22:12:09.805518 +00:00,2023-05-27 06:07:23.805518 +00:00,866.00,true,873
3054,2024-12-16 23:37:42.372959 +00:00,2024-12-26 19:18:40.372959 +00:00,175.00,true,873
3055,2018-11-26 12:36:25.993124 +00:00,2018-12-01 05:54:12.993124 +00:00,7207.00,true,873
3056,2013-11-10 02:53:55.684829 +00:00,2013-11-10 03:00:44.684829 +00:00,3804.00,true,874
3057,2021-07-27 06:53:54.542316 +00:00,2021-08-01 06:46:27.542316 +00:00,1190.00,true,874
3058,2024-03-20 13:37:12.386786 +00:00,2024-03-24 08:56:11.386786 +00:00,2050.00,true,874
3059,2018-07-18 10:14:23.970368 +00:00,2018-07-19 16:33:26.970368 +00:00,2943.00,true,874
3060,2018-12-16 06:15:11.708188 +00:00,2018-12-17 00:12:54.708188 +00:00,1728.00,true,874
3061,2024-12-21 19:50:23.258725 +00:00,2024-12-23 05:06:11.258725 +00:00,925.00,true,874
3062,2025-09-12 06:22:47.908280 +00:00,2025-09-12 06:35:58.908280 +00:00,6425.00,true,875
3063,2025-09-13 02:41:34.861160 +00:00,2025-09-17 16:44:02.861160 +00:00,3318.00,true,875
3064,2025-10-02 03:27:06.670734 +00:00,2025-10-06 05:51:49.670734 +00:00,4561.00,true,875
3065,2025-09-13 13:42:24.137080 +00:00,2025-09-21 11:58:36.137080 +00:00,2358.00,true,875
3066,2025-09-25 19:55:04.852201 +00:00,2025-09-29 18:18:55.852201 +00:00,5996.00,true,875
3067,2025-09-23 21:09:18.388730 +00:00,2025-09-25 19:48:42.388730 +00:00,1935.00,true,875
3068,2025-07-06 09:53:38.199148 +00:00,2025-07-06 10:00:11.199148 +00:00,1460.00,true,876
3069,2025-08-02 00:11:58.636914 +00:00,2025-08-04 21:09:26.636914 +00:00,3009.00,true,876
3070,2025-09-24 11:26:51.709161 +00:00,2025-10-05 03:53:32.709161 +00:00,1557.00,true,876
3071,2014-11-13 04:11:39.759355 +00:00,2014-11-13 04:15:28.759355 +00:00,695.00,true,877
3072,2020-07-27 22:45:10.797078 +00:00,2020-08-01 16:01:31.797078 +00:00,1500.00,true,877
3073,2024-12-21 11:29:40.746236 +00:00,2024-12-26 05:51:34.746236 +00:00,1341.00,true,877
3074,2024-11-24 17:20:31.482496 +00:00,2024-11-29 04:11:27.482496 +00:00,312.00,true,877
3075,2015-05-05 09:23:56.321764 +00:00,2015-05-07 03:22:48.321764 +00:00,115.00,true,877
3076,2015-08-24 08:48:23.288296 +00:00,2015-09-02 17:39:54.288296 +00:00,2207.00,true,877
3077,2011-01-07 06:32:51.653318 +00:00,2011-01-07 06:33:00.653318 +00:00,3997.00,true,878
3078,2014-07-04 20:42:11.321049 +00:00,2014-07-05 00:07:33.321049 +00:00,1017.00,true,878
3079,2011-12-02 11:23:34.132725 +00:00,2011-12-07 15:50:22.132725 +00:00,11115.00,true,878
3080,2020-01-30 07:38:10.664353 +00:00,2020-01-31 14:13:02.664353 +00:00,16236.00,true,878
3081,2021-08-24 17:51:43.295829 +00:00,2021-09-04 00:20:39.295829 +00:00,6993.00,true,878
3082,2011-08-03 20:22:12.631801 +00:00,2011-08-03 20:27:51.631801 +00:00,10773.00,true,879
3083,2012-02-20 16:58:46.087083 +00:00,2012-02-21 15:55:01.087083 +00:00,554.00,true,879
3084,2025-07-18 07:25:38.485136 +00:00,2025-07-23 12:50:16.485136 +00:00,6278.00,true,879
3085,2018-07-31 13:27:08.329103 +00:00,2018-08-10 02:28:42.329103 +00:00,9458.00,true,879
3086,2016-03-26 17:02:08.946884 +00:00,2016-03-29 18:26:41.946884 +00:00,6314.00,true,879
3087,2011-02-21 12:38:08.667372 +00:00,2011-02-21 12:54:10.667372 +00:00,42499.00,true,880
3088,2016-06-05 21:18:21.773089 +00:00,2016-06-05 21:31:42.773089 +00:00,4069.00,true,881
3089,2018-06-09 11:11:04.038909 +00:00,2018-06-20 22:25:14.038909 +00:00,1396.00,true,881
3090,2024-10-15 19:26:12.342010 +00:00,2024-10-25 07:17:28.342010 +00:00,3777.00,true,881
3091,2017-02-17 00:18:13.798598 +00:00,2017-02-20 16:23:11.798598 +00:00,2708.00,true,881
3092,2020-07-01 20:32:35.594700 +00:00,2020-07-03 06:32:25.594700 +00:00,785.00,true,881
3093,2018-12-31 04:08:01.678689 +00:00,2019-01-06 05:45:07.678689 +00:00,3589.00,true,881
3094,2025-09-26 02:05:54.518336 +00:00,2025-09-26 02:19:39.518336 +00:00,3446.00,true,882
3095,2025-10-01 13:49:17.651000 +00:00,2025-10-04 21:48:12.651000 +00:00,37530.00,true,882
3096,2017-07-21 21:53:59.341285 +00:00,2017-07-21 22:09:22.341285 +00:00,4402.00,true,883
3097,2019-03-28 08:01:03.494882 +00:00,2019-04-01 16:48:30.494882 +00:00,21314.00,true,883
3098,2024-06-26 03:33:07.397176 +00:00,2024-07-01 20:28:12.397176 +00:00,6475.00,true,883
3099,2022-09-29 23:48:41.072615 +00:00,2022-10-11 09:30:39.072615 +00:00,22170.00,true,883
3100,2020-05-06 13:39:44.091913 +00:00,2020-05-16 02:11:10.091913 +00:00,2320.00,true,883
3101,2025-07-12 01:20:47.608313 +00:00,2025-07-12 01:27:55.608313 +00:00,1928.00,true,884
3102,2025-07-25 02:31:58.867748 +00:00,2025-07-28 23:53:04.867748 +00:00,27039.00,true,884
3103,2025-10-02 14:22:06.065662 +00:00,2025-10-04 12:06:06.065662 +00:00,11849.00,true,884
3104,2025-09-02 04:53:41.286764 +00:00,2025-09-02 05:09:31.286764 +00:00,1430.00,true,885
3105,2025-09-24 14:16:31.899600 +00:00,2025-10-01 06:04:24.899600 +00:00,5249.00,true,885
3106,2025-09-29 08:49:09.408541 +00:00,2025-09-30 12:09:52.408541 +00:00,7627.00,true,885
3107,2025-09-02 07:40:56.665512 +00:00,2025-09-04 19:13:12.665512 +00:00,7897.00,true,885
3108,2018-03-27 09:53:39.907417 +00:00,2018-03-27 10:00:11.907417 +00:00,1445.00,true,886
3109,2025-06-23 08:59:18.136297 +00:00,2025-07-03 20:16:37.136297 +00:00,1214.00,true,886
3110,2022-10-14 16:52:11.270768 +00:00,2022-10-17 15:06:05.270768 +00:00,3041.00,true,886
3111,2021-07-20 10:21:24.106787 +00:00,2021-07-26 18:35:42.106787 +00:00,3214.00,true,886
3112,2021-04-07 02:56:04.781167 +00:00,2021-04-09 16:58:37.781167 +00:00,2695.00,true,886
3113,2025-09-20 15:11:47.486759 +00:00,2025-09-22 02:41:19.486759 +00:00,844.00,true,886
3114,2025-07-20 07:08:32.591508 +00:00,2025-07-20 07:15:25.591508 +00:00,4199.00,true,887
3115,2013-12-13 07:38:30.372453 +00:00,2013-12-13 07:49:17.372453 +00:00,2743.00,true,888
3116,2021-06-23 12:39:26.878698 +00:00,2021-07-03 02:12:38.878698 +00:00,3374.00,true,888
3117,2016-12-18 04:35:40.302252 +00:00,2016-12-18 10:11:13.302252 +00:00,1192.00,true,888
3118,2016-07-06 22:32:47.593117 +00:00,2016-07-11 08:58:20.593117 +00:00,3734.00,true,888
3119,2020-08-24 16:19:09.122709 +00:00,2020-08-24 16:25:39.122709 +00:00,2312.00,true,889
3120,2024-08-18 23:54:25.367811 +00:00,2024-08-21 14:24:40.367811 +00:00,23681.00,true,889
3121,2024-10-22 17:02:22.092137 +00:00,2024-10-26 10:47:06.092137 +00:00,1023.00,true,889
3122,2024-03-27 05:16:51.955318 +00:00,2024-03-28 16:35:09.955318 +00:00,8532.00,true,889
3123,2011-02-26 10:12:17.844278 +00:00,2011-02-26 10:25:56.844278 +00:00,29661.00,true,890
3124,2025-09-15 08:04:18.341033 +00:00,2025-09-25 13:21:21.341033 +00:00,14154.00,true,890
3125,2020-12-29 03:44:56.682910 +00:00,2021-01-02 18:16:36.682910 +00:00,10126.00,true,890
3126,2022-02-23 02:29:16.795974 +00:00,2022-02-23 02:41:13.795974 +00:00,5182.00,true,891
3127,2024-09-13 13:50:01.232741 +00:00,2024-09-23 06:48:00.232741 +00:00,39225.00,true,891
3128,2024-04-03 01:23:37.018719 +00:00,2024-04-10 04:26:02.018719 +00:00,5158.00,true,891
3129,2011-12-15 00:10:10.962779 +00:00,2011-12-15 00:11:47.962779 +00:00,7585.00,true,892
3130,2020-05-22 14:02:12.549738 +00:00,2020-05-23 04:45:00.549738 +00:00,12865.00,true,892
3131,2024-02-06 02:26:14.677066 +00:00,2024-02-14 17:50:41.677066 +00:00,17540.00,true,892
3132,2018-02-03 23:25:11.453453 +00:00,2018-02-03 23:38:17.453453 +00:00,1717.00,true,893
3133,2021-01-17 08:13:24.034656 +00:00,,18993.00,false,893
3134,2023-09-26 21:04:49.562481 +00:00,2023-09-26 21:11:59.562481 +00:00,8307.00,true,894
3135,2024-09-09 22:39:24.386167 +00:00,2024-09-10 00:07:37.386167 +00:00,28387.00,true,894
3136,2025-02-26 17:06:34.994573 +00:00,2025-03-03 22:05:27.994573 +00:00,5710.00,true,894
3137,2025-09-24 02:03:50.888554 +00:00,2025-09-24 02:04:48.888554 +00:00,2808.00,true,895
3138,2025-09-29 10:43:46.785502 +00:00,2025-09-30 02:26:48.785502 +00:00,17904.00,true,895
3139,2025-09-24 03:25:54.779873 +00:00,2025-09-26 05:58:50.779873 +00:00,576.00,true,895
3140,2025-08-09 20:28:00.533700 +00:00,2025-08-09 20:44:16.533700 +00:00,35932.00,true,896
3141,2025-08-25 22:53:36.430668 +00:00,2025-08-25 23:05:15.430668 +00:00,10404.00,true,897
3142,2025-09-28 01:52:04.284841 +00:00,2025-10-06 05:15:32.284841 +00:00,310.00,true,897
3143,2025-09-13 02:46:19.359104 +00:00,2025-09-23 06:39:51.359104 +00:00,2628.00,true,897
3144,2025-09-21 14:52:12.655347 +00:00,2025-09-22 08:12:31.655347 +00:00,1823.00,true,897
3145,2025-09-11 05:30:02.231664 +00:00,2025-09-18 14:37:10.231664 +00:00,4929.00,true,897
3146,2016-05-03 12:26:22.800915 +00:00,2016-05-03 12:31:05.800915 +00:00,5297.00,true,898
3147,2024-04-29 05:41:05.265198 +00:00,,7371.00,false,898
3148,2019-05-05 04:36:18.033775 +00:00,2019-05-07 04:13:54.033775 +00:00,507.00,true,898
3149,2019-08-03 22:39:09.946535 +00:00,2019-08-13 02:44:06.946535 +00:00,6544.00,true,898
3150,2025-07-15 21:49:35.680659 +00:00,2025-07-25 18:35:58.680659 +00:00,1502.00,true,898
3151,2022-02-05 07:33:53.593174 +00:00,2022-02-09 13:26:24.593174 +00:00,4711.00,true,898
3152,2025-07-14 02:55:32.705741 +00:00,2025-07-14 02:58:27.705741 +00:00,4557.00,true,899
3153,2025-09-25 08:43:37.873923 +00:00,2025-10-05 19:33:53.873923 +00:00,3855.00,true,899
3154,2025-09-14 20:48:51.569022 +00:00,2025-09-23 06:02:13.569022 +00:00,9996.00,true,899
3155,2025-10-01 15:44:52.758970 +00:00,2025-10-05 02:50:58.758970 +00:00,8607.00,true,899
3156,2025-07-24 19:26:02.914204 +00:00,2025-07-27 03:20:16.914204 +00:00,2170.00,true,899
3157,2025-09-27 09:26:21.902881 +00:00,2025-10-03 15:27:47.902881 +00:00,7463.00,true,899
3158,2019-04-15 03:42:24.879311 +00:00,2019-04-15 03:49:53.879311 +00:00,12423.00,true,900
3159,2025-07-21 15:46:18.611774 +00:00,2025-07-21 15:48:38.611774 +00:00,13708.00,true,901
3160,2025-09-20 23:11:09.446253 +00:00,2025-09-29 19:13:59.446253 +00:00,291.00,true,901
3161,2025-08-08 05:45:57.654282 +00:00,2025-08-14 02:27:31.654282 +00:00,2068.00,true,901
3162,2025-08-08 11:23:45.815798 +00:00,2025-08-09 13:51:24.815798 +00:00,9641.00,true,901
3163,2025-08-16 11:13:10.724331 +00:00,2025-08-17 11:12:27.724331 +00:00,2257.00,true,901
3164,2025-10-03 19:37:18.858837 +00:00,2025-10-03 19:44:22.858837 +00:00,12306.00,true,902
3165,2025-10-04 04:02:22.659847 +00:00,,6465.00,false,902
3166,2025-10-04 22:29:56.529305 +00:00,,13316.00,false,902
3167,2025-10-03 23:17:39.238194 +00:00,,10142.00,false,902
3168,2015-02-18 05:29:54.238085 +00:00,2015-02-18 05:32:49.238085 +00:00,42589.00,true,903
3169,2024-11-09 21:38:45.633367 +00:00,2024-11-14 09:52:19.633367 +00:00,12263.00,true,903
3170,2023-11-27 22:04:53.428140 +00:00,2023-11-27 22:11:16.428140 +00:00,10029.00,true,904
3171,2025-07-25 23:13:52.784566 +00:00,2025-08-02 06:55:50.784566 +00:00,3666.00,true,904
3172,2024-09-28 12:55:04.783775 +00:00,2024-10-03 05:50:36.783775 +00:00,13895.00,true,904
3173,2025-08-28 15:10:41.433962 +00:00,2025-08-30 11:08:01.433962 +00:00,10962.00,true,904
3174,2024-05-29 09:19:51.662350 +00:00,2024-05-29 18:44:24.662350 +00:00,1460.00,true,904
3175,2023-11-29 12:26:15.090727 +00:00,2023-12-06 06:55:10.090727 +00:00,24046.00,true,904
3176,2010-02-24 00:22:45.614780 +00:00,2010-02-24 00:36:41.614780 +00:00,18400.00,true,905
3177,2012-12-25 22:56:15.107240 +00:00,2012-12-25 23:01:57.107240 +00:00,10118.00,true,906
3178,2015-08-10 03:33:35.640406 +00:00,2015-08-13 05:20:18.640406 +00:00,6375.00,true,906
3179,2025-08-26 13:23:46.090917 +00:00,2025-08-26 13:34:16.090917 +00:00,4323.00,true,907
3180,2025-09-23 11:32:19.467534 +00:00,2025-09-29 22:20:13.467534 +00:00,19164.00,true,907
3181,2021-09-13 16:26:32.976318 +00:00,2021-09-13 16:36:51.976318 +00:00,10919.00,true,908
3182,2022-09-16 16:03:04.544309 +00:00,2022-09-27 03:07:51.544309 +00:00,20167.00,true,908
3183,2021-12-02 09:48:48.326611 +00:00,2021-12-09 03:27:03.326611 +00:00,4432.00,true,908
3184,2022-07-21 09:42:37.648537 +00:00,2022-07-26 05:42:15.648537 +00:00,7943.00,true,908
3185,2024-11-14 21:03:28.052234 +00:00,2024-11-25 01:09:00.052234 +00:00,26690.00,true,908
3186,2010-12-04 03:59:35.456105 +00:00,2010-12-04 04:15:52.456105 +00:00,26346.00,true,909
3187,2011-08-09 21:25:27.802626 +00:00,2011-08-20 15:51:35.802626 +00:00,4725.00,true,909
3188,2018-03-22 14:51:24.728034 +00:00,2018-03-22 14:52:55.728034 +00:00,11233.00,true,910
3189,2019-10-28 00:02:24.147781 +00:00,2019-11-01 06:13:29.147781 +00:00,4619.00,true,910
3190,2025-01-22 08:26:38.294251 +00:00,2025-01-28 13:27:22.294251 +00:00,5726.00,true,910
3191,2018-06-01 13:24:11.340023 +00:00,2018-06-06 16:23:29.340023 +00:00,10981.00,true,910
3192,2021-06-27 16:03:03.360431 +00:00,2021-07-07 02:58:10.360431 +00:00,2568.00,true,910
3193,2024-09-20 02:41:00.415796 +00:00,2024-09-22 09:03:13.415796 +00:00,1949.00,true,910
3194,2023-01-08 00:38:27.375183 +00:00,2023-01-08 00:53:27.375183 +00:00,21782.00,true,911
3195,2024-03-31 08:42:49.335982 +00:00,2024-04-10 12:30:01.335982 +00:00,42003.00,true,911
3196,2025-06-29 04:25:32.240868 +00:00,2025-06-29 04:29:11.240868 +00:00,1867.00,true,912
3197,2025-09-16 01:03:11.958734 +00:00,2025-09-16 08:15:30.958734 +00:00,290.00,true,912
3198,2025-07-20 14:58:35.808746 +00:00,2025-07-21 00:10:57.808746 +00:00,58.00,true,912
3199,2025-08-09 10:41:02.348756 +00:00,2025-08-19 05:20:26.348756 +00:00,83.00,true,912
3200,2025-10-02 02:30:45.366348 +00:00,,406.00,false,912
3201,2025-07-27 01:47:11.369349 +00:00,,108.00,false,912
3202,2025-09-26 16:07:43.603926 +00:00,2025-09-26 16:14:13.603926 +00:00,18327.00,true,913
3203,2018-04-06 17:03:11.749699 +00:00,2018-04-06 17:04:06.749699 +00:00,2595.00,true,914
3204,2024-11-25 05:20:29.674133 +00:00,2024-11-28 16:15:07.674133 +00:00,2003.00,true,914
3205,2020-04-06 12:27:09.755834 +00:00,2020-04-11 04:39:57.755834 +00:00,1102.00,true,914
3206,2010-01-14 18:13:09.057122 +00:00,2010-01-14 18:18:59.057122 +00:00,1424.00,true,915
3207,2018-06-30 08:10:03.095886 +00:00,2018-07-08 23:50:25.095886 +00:00,49167.00,true,915
3208,2025-09-10 11:44:52.787695 +00:00,2025-09-10 11:47:12.787695 +00:00,2487.00,true,916
3209,2025-09-17 00:51:56.699877 +00:00,2025-09-18 12:27:46.699877 +00:00,2504.00,true,916
3210,2025-09-21 08:12:17.678673 +00:00,2025-09-27 15:58:43.678673 +00:00,5018.00,true,916
3211,2025-09-13 16:24:03.077985 +00:00,,1020.00,false,916
3212,2025-09-20 09:58:50.663242 +00:00,2025-09-25 23:26:59.663242 +00:00,1061.00,true,916
3213,2025-10-04 07:49:14.810194 +00:00,,8719.00,false,916
3214,2025-02-13 04:35:00.416918 +00:00,2025-02-13 04:49:23.416918 +00:00,3977.00,true,917
3215,2025-07-27 19:13:49.280955 +00:00,2025-07-31 18:30:17.280955 +00:00,56374.00,true,917
3216,2013-07-11 08:08:04.089921 +00:00,2013-07-11 08:14:03.089921 +00:00,19058.00,true,918
3217,2018-04-01 01:21:29.230091 +00:00,2018-04-08 15:32:41.230091 +00:00,493.00,true,918
3218,2015-09-22 01:22:08.223995 +00:00,2015-09-22 04:21:29.223995 +00:00,2207.00,true,918
3219,2023-10-03 18:06:36.310119 +00:00,2023-10-12 21:23:01.310119 +00:00,18663.00,true,918
3220,2014-08-27 10:47:27.869508 +00:00,2014-09-01 15:32:00.869508 +00:00,8928.00,true,918
3221,2025-05-24 00:10:16.429733 +00:00,2025-06-04 01:15:27.429733 +00:00,15156.00,true,918
3222,2011-04-05 03:52:44.807356 +00:00,2011-04-05 03:58:23.807356 +00:00,22972.00,true,919
3223,2020-09-16 06:10:08.567518 +00:00,2020-09-27 00:17:05.567518 +00:00,685.00,true,919
3224,2025-09-11 06:59:40.352112 +00:00,2025-09-11 07:01:02.352112 +00:00,218.00,true,920
3225,2025-09-11 09:44:44.046676 +00:00,2025-09-20 18:45:23.046676 +00:00,7178.00,true,920
3226,2025-09-17 06:54:54.396018 +00:00,2025-09-17 18:45:12.396018 +00:00,1724.00,true,920
3227,2025-08-10 11:48:14.824710 +00:00,2025-08-10 11:49:42.824710 +00:00,27.00,true,921
3228,2025-09-02 20:53:21.492930 +00:00,2025-09-07 01:19:13.492930 +00:00,9.00,true,921
3229,2025-09-14 07:47:13.237496 +00:00,2025-09-18 12:15:27.237496 +00:00,429.00,true,921
3230,2025-09-07 17:11:56.280346 +00:00,2025-09-18 04:17:49.280346 +00:00,147.00,true,921
3231,2025-08-17 03:54:13.560372 +00:00,2025-08-17 04:08:49.560372 +00:00,730.00,true,922
3232,2025-09-09 05:40:56.564685 +00:00,2025-09-20 18:04:41.564685 +00:00,940.00,true,922
3233,2025-08-26 01:58:37.851975 +00:00,2025-09-04 00:21:27.851975 +00:00,7.00,true,922
3234,2025-09-03 21:42:47.850214 +00:00,2025-09-05 10:25:30.850214 +00:00,4120.00,true,922
3235,2024-05-31 19:13:01.077612 +00:00,2024-05-31 19:23:30.077612 +00:00,3837.00,true,923
3236,2024-11-03 02:37:53.295643 +00:00,2024-11-04 05:06:26.295643 +00:00,4044.00,true,923
3237,2025-09-26 15:53:17.756720 +00:00,,137.00,false,923
3238,2024-08-03 20:29:16.589549 +00:00,2024-08-13 17:52:34.589549 +00:00,134.00,true,923
3239,2025-03-23 01:43:24.958585 +00:00,2025-04-02 09:54:13.958585 +00:00,308.00,true,923
3240,2023-01-14 10:51:37.066967 +00:00,2023-01-14 10:57:47.066967 +00:00,9452.00,true,924
3241,2024-02-15 21:53:02.562894 +00:00,2024-02-22 22:23:39.562894 +00:00,9283.00,true,924
3242,2025-08-19 21:42:29.771298 +00:00,2025-08-19 21:44:45.771298 +00:00,6676.00,true,925
3243,2025-08-23 04:11:23.448187 +00:00,2025-08-30 15:19:21.448187 +00:00,13417.00,true,925
3244,2025-08-20 05:30:17.674392 +00:00,2025-08-21 22:43:02.674392 +00:00,17360.00,true,925
3245,2010-01-20 20:56:51.291017 +00:00,2010-01-20 20:59:30.291017 +00:00,528.00,true,926
3246,2023-11-27 16:34:51.342906 +00:00,2023-12-04 21:16:33.342906 +00:00,159.00,true,926
3247,2015-07-30 01:02:45.282740 +00:00,,145.00,false,926
3248,2020-10-29 23:35:06.161331 +00:00,,49.00,false,926
3249,2016-12-31 22:08:16.663523 +00:00,2017-01-04 07:41:44.663523 +00:00,212.00,true,926
3250,2012-04-25 03:44:11.959881 +00:00,2012-05-02 06:04:02.959881 +00:00,563.00,true,926
3251,2025-10-03 08:59:22.203815 +00:00,2025-10-03 09:07:24.203815 +00:00,1261.00,true,927
3252,2013-05-16 04:58:14.310618 +00:00,2013-05-16 05:00:03.310618 +00:00,69037.00,true,928
3253,2025-07-05 13:34:56.934055 +00:00,2025-07-05 13:48:23.934055 +00:00,10368.00,true,929
3254,2025-09-08 04:19:30.775234 +00:00,2025-09-16 01:51:14.775234 +00:00,27339.00,true,929
3255,2025-09-01 20:50:16.206390 +00:00,2025-09-11 00:24:46.206390 +00:00,10282.00,true,929
3256,2025-08-03 04:22:13.195337 +00:00,2025-08-03 04:24:09.195337 +00:00,1004.00,true,930
3257,2025-10-02 16:19:22.903789 +00:00,,394.00,false,930
3258,2025-09-29 19:14:54.842291 +00:00,2025-10-05 11:55:43.842291 +00:00,595.00,true,930
3259,2025-08-08 16:03:20.996440 +00:00,2025-08-08 19:13:41.996440 +00:00,61.00,true,930
3260,2025-09-08 17:48:03.558172 +00:00,2025-09-11 15:17:45.558172 +00:00,246.00,true,930
3261,2012-12-22 18:50:13.553555 +00:00,2012-12-22 18:58:51.553555 +00:00,43904.00,true,931
3262,2025-07-18 14:15:31.958868 +00:00,2025-07-18 14:30:39.958868 +00:00,2230.00,true,932
3263,2025-08-17 21:46:17.259381 +00:00,2025-08-20 18:24:27.259381 +00:00,1724.00,true,932
3264,2024-03-20 00:01:13.839458 +00:00,2024-03-20 00:16:07.839458 +00:00,5529.00,true,933
3265,2024-07-18 02:09:34.392504 +00:00,2024-07-24 21:48:46.392504 +00:00,4286.00,true,933
3266,2024-11-09 17:53:26.831306 +00:00,2024-11-13 06:40:15.831306 +00:00,17128.00,true,933
3267,2025-08-04 18:49:33.097466 +00:00,2025-08-04 18:54:47.097466 +00:00,16720.00,true,934
3268,2025-09-08 12:34:26.308034 +00:00,2025-09-14 19:42:33.308034 +00:00,9703.00,true,934
3269,2019-05-19 18:07:35.627944 +00:00,2019-05-19 18:11:30.627944 +00:00,25440.00,true,935
3270,2020-02-01 11:01:40.010163 +00:00,2020-02-01 22:53:50.010163 +00:00,3956.00,true,935
3271,2021-03-05 02:09:29.059606 +00:00,2021-03-05 07:11:27.059606 +00:00,6968.00,true,935
3272,2018-07-02 12:18:28.112795 +00:00,2018-07-02 12:27:32.112795 +00:00,14052.00,true,936
3273,2021-03-04 19:39:54.233926 +00:00,2021-03-04 19:55:51.233926 +00:00,9974.00,true,937
3274,2022-07-26 06:06:04.871180 +00:00,2022-07-30 11:58:55.871180 +00:00,5912.00,true,937
3275,2021-08-23 06:40:49.409588 +00:00,,18649.00,false,937
3276,2024-04-10 19:56:17.792188 +00:00,2024-04-19 05:35:22.792188 +00:00,9745.00,true,937
3277,2012-11-16 11:08:31.367440 +00:00,2012-11-16 11:19:06.367440 +00:00,681.00,true,938
3278,2020-11-12 16:01:18.450411 +00:00,2020-11-20 14:30:42.450411 +00:00,3857.00,true,938
3279,2015-11-07 04:47:45.791249 +00:00,2015-11-16 20:30:30.791249 +00:00,122.00,true,938
3280,2024-01-13 03:22:49.439213 +00:00,2024-01-20 22:28:49.439213 +00:00,420.00,true,938
3281,2013-03-16 17:31:22.627149 +00:00,2013-03-22 06:03:33.627149 +00:00,506.00,true,938
3282,2013-04-28 04:27:59.394001 +00:00,2013-05-05 03:04:46.394001 +00:00,406.00,true,938
3283,2010-08-26 14:54:25.880180 +00:00,2010-08-26 15:04:47.880180 +00:00,4905.00,true,939
3284,2013-09-05 11:43:40.047133 +00:00,2013-09-07 13:51:21.047133 +00:00,4166.00,true,939
3285,2020-08-08 07:53:01.089876 +00:00,2020-08-13 01:08:47.089876 +00:00,8609.00,true,939
3286,2013-02-17 18:19:24.468385 +00:00,2013-02-21 13:28:39.468385 +00:00,3127.00,true,939
3287,2015-08-06 10:23:16.778326 +00:00,2015-08-15 14:00:27.778326 +00:00,2738.00,true,939
3288,2023-09-02 12:04:44.006607 +00:00,2023-09-02 12:12:25.006607 +00:00,18323.00,true,940
3289,2025-05-18 22:48:52.549145 +00:00,2025-05-29 15:09:35.549145 +00:00,16908.00,true,940
3290,2025-02-23 02:55:56.348906 +00:00,2025-02-27 20:13:09.348906 +00:00,4670.00,true,940
3291,2023-12-29 22:29:48.641687 +00:00,2024-01-03 17:31:54.641687 +00:00,1981.00,true,940
3292,2025-09-07 13:08:58.203362 +00:00,2025-09-07 13:24:22.203362 +00:00,523.00,true,941
3293,2025-09-16 19:19:14.039274 +00:00,2025-09-19 17:32:07.039274 +00:00,743.00,true,941
3294,2025-09-18 02:45:27.345143 +00:00,2025-09-19 03:06:01.345143 +00:00,2221.00,true,941
3295,2025-09-29 15:25:28.867889 +00:00,,12383.00,false,941
3296,2025-09-28 21:11:59.424014 +00:00,,588.00,false,941
3297,2025-08-09 16:08:20.754941 +00:00,2025-08-09 16:12:53.754941 +00:00,1926.00,true,942
3298,2025-09-11 17:20:19.303482 +00:00,2025-09-14 10:18:20.303482 +00:00,2755.00,true,942
3299,2025-08-29 02:03:41.993222 +00:00,2025-09-04 08:44:03.993222 +00:00,863.00,true,942
3300,2025-08-12 12:18:33.910192 +00:00,2025-08-15 09:45:45.910192 +00:00,1228.00,true,942
3301,2025-09-13 21:37:42.100728 +00:00,,3205.00,false,942
3302,2025-08-25 18:07:14.399825 +00:00,2025-09-02 04:36:25.399825 +00:00,4863.00,true,942
3303,2022-08-11 07:55:05.629109 +00:00,2022-08-11 07:56:22.629109 +00:00,52122.00,true,943
3304,2011-05-04 23:22:31.747517 +00:00,2011-05-04 23:31:31.747517 +00:00,798.00,true,944
3305,2019-07-02 23:32:17.532302 +00:00,2019-07-08 17:55:37.532302 +00:00,2627.00,true,944
3306,2010-01-22 01:44:57.330252 +00:00,2010-01-22 01:49:00.330252 +00:00,2184.00,true,945
3307,2014-03-04 06:37:00.485582 +00:00,2014-03-10 16:52:52.485582 +00:00,26741.00,true,945
3308,2014-08-26 05:07:48.489258 +00:00,2014-09-05 10:30:55.489258 +00:00,863.00,true,945
3309,2024-06-17 00:03:43.416491 +00:00,2024-06-17 00:08:19.416491 +00:00,7197.00,true,946
3310,2024-11-09 21:26:40.868427 +00:00,2024-11-10 20:34:39.868427 +00:00,3604.00,true,946
3311,2025-08-20 16:41:58.102313 +00:00,2025-08-26 06:49:34.102313 +00:00,2894.00,true,946
3312,2025-03-18 07:05:49.102917 +00:00,2025-03-22 15:04:31.102917 +00:00,16621.00,true,946
3313,2025-01-12 07:49:10.327992 +00:00,2025-01-23 12:15:53.327992 +00:00,1875.00,true,946
3314,2025-09-05 22:37:35.789587 +00:00,2025-09-08 18:17:31.789587 +00:00,832.00,true,946
3315,2019-09-11 19:20:06.501486 +00:00,2019-09-11 19:27:33.501486 +00:00,875.00,true,947
3316,2020-10-17 01:50:10.213753 +00:00,,1571.00,false,947
3317,2024-11-26 05:34:29.895331 +00:00,,300.00,false,947
3318,2021-11-06 15:55:38.470067 +00:00,2021-11-12 23:55:13.470067 +00:00,1033.00,true,947
3319,2025-04-29 13:05:42.841811 +00:00,2025-05-10 10:18:55.841811 +00:00,205.00,true,947
3320,2024-06-14 01:23:42.360772 +00:00,2024-06-16 09:18:10.360772 +00:00,1262.00,true,947
3321,2013-07-20 04:23:32.184391 +00:00,2013-07-20 04:32:22.184391 +00:00,3897.00,true,948
3322,2016-08-26 19:04:01.789801 +00:00,2016-09-02 22:14:23.789801 +00:00,3793.00,true,948
3323,2017-05-12 18:42:16.409878 +00:00,2017-05-20 20:34:26.409878 +00:00,4787.00,true,948
3324,2015-02-19 23:07:27.508329 +00:00,2015-03-01 22:26:14.508329 +00:00,12695.00,true,948
3325,2016-07-17 11:12:16.388163 +00:00,2016-07-27 19:07:48.388163 +00:00,1889.00,true,948
3326,2025-08-05 21:13:30.339224 +00:00,2025-08-12 20:57:31.339224 +00:00,3876.00,true,948
3327,2015-02-07 18:30:09.328809 +00:00,2015-02-07 18:46:28.328809 +00:00,5618.00,true,949
3328,2017-12-14 12:35:06.430576 +00:00,2017-12-18 23:50:11.430576 +00:00,18376.00,true,949
3329,2021-04-16 16:01:15.711667 +00:00,2021-04-16 16:17:23.711667 +00:00,15080.00,true,950
3330,2024-12-08 04:57:59.761466 +00:00,2024-12-09 06:44:16.761466 +00:00,1222.00,true,950
3331,2016-01-28 14:14:33.166013 +00:00,2016-01-28 14:26:23.166013 +00:00,37585.00,true,951
3332,2023-01-27 15:33:57.171504 +00:00,2023-02-05 19:27:42.171504 +00:00,10829.00,true,951
3333,2016-01-05 19:44:25.519135 +00:00,2016-01-05 19:57:54.519135 +00:00,287.00,true,952
3334,2017-08-23 01:01:11.870764 +00:00,2017-08-23 21:13:32.870764 +00:00,3703.00,true,952
3335,2021-10-13 02:40:22.460262 +00:00,2021-10-17 07:18:55.460262 +00:00,53.00,true,952
3336,2021-08-13 02:59:36.927625 +00:00,2021-08-18 11:30:11.927625 +00:00,1.00,true,952
3337,2018-03-19 20:37:07.424583 +00:00,2018-03-25 07:29:20.424583 +00:00,6254.00,true,952
3338,2024-01-16 18:11:44.616561 +00:00,,373.00,false,952
3339,2025-08-16 17:43:19.389896 +00:00,2025-08-16 17:56:47.389896 +00:00,1422.00,true,953
3340,2025-09-24 22:11:28.729774 +00:00,2025-10-05 19:12:18.729774 +00:00,3072.00,true,953
3341,2025-10-02 10:04:17.603989 +00:00,,846.00,false,953
3342,2025-08-29 20:34:57.441544 +00:00,2025-09-02 21:12:21.441544 +00:00,2248.00,true,953
3343,2025-09-17 03:18:25.785707 +00:00,2025-09-26 04:35:31.785707 +00:00,410.00,true,953
3344,2025-09-25 03:18:42.761188 +00:00,2025-09-25 03:28:33.761188 +00:00,1687.00,true,954
3345,2025-09-28 18:06:14.692186 +00:00,2025-10-04 20:48:59.692186 +00:00,2859.00,true,954
3346,2015-03-01 22:22:41.192894 +00:00,2015-03-01 22:26:47.192894 +00:00,3189.00,true,955
3347,2018-04-18 04:45:23.183623 +00:00,2018-04-18 15:07:22.183623 +00:00,2575.00,true,955
3348,2024-11-30 04:40:31.075016 +00:00,2024-12-10 21:59:30.075016 +00:00,7438.00,true,955
3349,2016-11-02 12:32:49.719600 +00:00,2016-11-09 20:40:05.719600 +00:00,6896.00,true,955
3350,2025-07-12 12:18:50.120220 +00:00,2025-07-12 12:27:32.120220 +00:00,4771.00,true,956
3351,2025-08-26 03:13:54.465823 +00:00,2025-09-02 18:59:41.465823 +00:00,15999.00,true,956
3352,2025-08-16 22:32:02.530834 +00:00,2025-08-23 05:11:50.530834 +00:00,27222.00,true,956
3353,2025-09-16 22:56:42.856333 +00:00,2025-09-17 19:58:45.856333 +00:00,10226.00,true,956
3354,2025-08-18 06:44:11.162669 +00:00,2025-08-26 11:58:07.162669 +00:00,8649.00,true,956
3355,2025-07-14 23:23:11.909533 +00:00,2025-07-14 23:25:05.909533 +00:00,37317.00,true,957
3356,2024-10-18 11:10:59.040478 +00:00,2024-10-18 11:16:30.040478 +00:00,851.00,true,958
3357,2025-01-17 10:06:56.251410 +00:00,2025-01-17 16:53:13.251410 +00:00,8189.00,true,958
3358,2025-09-08 16:10:08.238089 +00:00,2025-09-10 10:16:46.238089 +00:00,3746.00,true,958
3359,2025-09-16 05:55:52.390688 +00:00,2025-09-26 20:41:29.390688 +00:00,1540.00,true,958
3360,2025-02-15 23:10:23.211626 +00:00,2025-02-26 03:40:22.211626 +00:00,3752.00,true,958
3361,2025-07-01 12:35:04.965910 +00:00,2025-07-12 18:41:07.965910 +00:00,2569.00,true,958
3362,2025-07-24 11:02:09.519536 +00:00,2025-07-24 11:03:40.519536 +00:00,71.00,true,959
3363,2025-09-21 12:27:57.858239 +00:00,2025-09-26 20:32:51.858239 +00:00,1203.00,true,959
3364,2025-09-15 10:39:20.064190 +00:00,2025-09-17 18:43:21.064190 +00:00,8337.00,true,959
3365,2025-09-09 03:39:58.578017 +00:00,2025-09-14 21:24:07.578017 +00:00,4150.00,true,959
3366,2025-08-15 06:53:39.734910 +00:00,2025-08-19 01:50:16.734910 +00:00,1201.00,true,959
3367,2025-10-02 10:36:28.363398 +00:00,,2284.00,false,959
3368,2020-02-11 18:32:35.233642 +00:00,2020-02-11 18:33:16.233642 +00:00,389.00,true,960
3369,2021-11-08 11:53:13.683168 +00:00,2021-11-17 19:54:55.683168 +00:00,27012.00,true,960
3370,2024-12-29 05:49:26.034569 +00:00,2024-12-29 23:48:22.034569 +00:00,1034.00,true,960
3371,2023-04-13 15:49:50.560988 +00:00,2023-04-22 07:19:11.560988 +00:00,4809.00,true,960
3372,2022-11-17 03:19:19.529065 +00:00,2022-11-19 11:50:41.529065 +00:00,3636.00,true,960
3373,2025-04-29 21:32:20.007388 +00:00,,7930.00,false,960
3374,2018-07-20 19:00:37.838781 +00:00,2018-07-20 19:15:52.838781 +00:00,18464.00,true,961
3375,2019-12-20 06:27:40.083078 +00:00,2019-12-20 06:39:34.083078 +00:00,5670.00,true,962
3376,2023-05-20 06:03:38.941314 +00:00,2023-05-20 06:08:30.941314 +00:00,52790.00,true,963
3377,2025-10-02 18:42:30.819186 +00:00,2025-10-02 18:53:33.819186 +00:00,2032.00,true,964
3378,2025-10-04 08:44:03.866829 +00:00,,10244.00,false,964
3379,2025-10-04 04:17:12.118113 +00:00,,13887.00,false,964
3380,2025-10-03 11:43:31.764457 +00:00,,767.00,false,964
3381,2025-10-04 08:04:41.642415 +00:00,2025-10-05 17:23:15.642415 +00:00,34028.00,true,964
3382,2025-09-13 17:57:12.952812 +00:00,2025-09-13 18:02:33.952812 +00:00,57433.00,true,965
3383,2025-09-29 21:21:02.708421 +00:00,2025-09-30 10:45:30.708421 +00:00,9833.00,true,965
3384,2020-12-29 13:37:48.037806 +00:00,2020-12-29 13:48:25.037806 +00:00,3370.00,true,966
3385,2021-08-19 07:21:21.035084 +00:00,2021-08-27 22:33:00.035084 +00:00,9594.00,true,966
3386,2017-02-18 02:43:10.198618 +00:00,2017-02-18 02:44:02.198618 +00:00,12704.00,true,967
3387,2019-01-06 12:15:43.581580 +00:00,2019-01-07 02:51:34.581580 +00:00,1000.00,true,967
3388,2022-10-09 06:45:37.501630 +00:00,2022-10-19 02:49:45.501630 +00:00,34513.00,true,967
3389,2025-06-13 07:01:32.986973 +00:00,2025-06-13 10:12:06.986973 +00:00,2602.00,true,967
3390,2021-05-26 06:17:00.919497 +00:00,2021-05-26 06:18:05.919497 +00:00,6132.00,true,968
3391,2025-03-26 23:00:49.450753 +00:00,2025-04-05 17:00:19.450753 +00:00,30134.00,true,968
3392,2021-08-03 07:38:12.343178 +00:00,2021-08-03 07:47:04.343178 +00:00,19206.00,true,969
3393,2025-01-19 20:06:34.028216 +00:00,2025-01-25 13:31:16.028216 +00:00,9834.00,true,969
3394,2012-08-08 00:18:20.493148 +00:00,2012-08-08 00:33:03.493148 +00:00,892.00,true,970
3395,2020-08-27 11:50:12.546777 +00:00,2020-09-01 10:48:31.546777 +00:00,15274.00,true,970
3396,2025-04-01 19:51:55.257434 +00:00,2025-04-03 21:02:11.257434 +00:00,4445.00,true,970
3397,2018-05-25 22:50:54.533909 +00:00,2018-05-29 14:30:37.533909 +00:00,2335.00,true,970
3398,2025-08-23 05:14:51.034539 +00:00,2025-08-23 05:19:52.034539 +00:00,740.00,true,971
3399,2025-08-24 07:08:01.334047 +00:00,2025-09-03 04:11:18.334047 +00:00,3760.00,true,971
3400,2020-06-12 10:50:45.927505 +00:00,2020-06-12 11:02:52.927505 +00:00,3065.00,true,972
3401,2023-12-03 03:36:08.145077 +00:00,2023-12-10 18:34:17.145077 +00:00,3495.00,true,972
3402,2022-08-17 18:06:48.236722 +00:00,2022-08-20 12:31:25.236722 +00:00,1799.00,true,972
3403,2022-11-08 11:17:30.254846 +00:00,2022-11-11 12:48:17.254846 +00:00,6250.00,true,972
3404,2022-12-27 01:19:40.863405 +00:00,2022-12-28 06:27:22.863405 +00:00,8867.00,true,972
3405,2025-03-03 07:06:48.176046 +00:00,2025-03-07 15:15:55.176046 +00:00,4027.00,true,972
3406,2014-07-23 02:27:52.211145 +00:00,2014-07-23 02:34:36.211145 +00:00,1094.00,true,973
3407,2022-01-15 16:06:11.165476 +00:00,2022-01-20 14:12:47.165476 +00:00,8660.00,true,973
3408,2015-02-02 20:05:24.093533 +00:00,2015-02-02 20:09:27.093533 +00:00,28159.00,true,974
3409,2021-02-20 00:01:03.035265 +00:00,2021-02-28 18:48:51.035265 +00:00,4192.00,true,974
3410,2016-03-12 17:45:36.246148 +00:00,2016-03-18 03:35:16.246148 +00:00,72.00,true,974
3411,2025-08-29 19:24:02.241014 +00:00,2025-08-29 19:31:24.241014 +00:00,1535.00,true,975
3412,2025-09-04 11:09:34.970603 +00:00,2025-09-14 10:37:43.970603 +00:00,1171.00,true,975
3413,2025-10-04 06:47:39.045470 +00:00,,1086.00,false,975
3414,2025-09-30 12:38:31.315432 +00:00,,2037.00,false,975
3415,2025-09-12 16:31:21.034166 +00:00,2025-09-24 00:09:00.034166 +00:00,1547.00,true,975
3416,2025-09-18 01:59:48.495889 +00:00,2025-09-24 04:52:25.495889 +00:00,749.00,true,975
3417,2020-12-24 13:42:47.420751 +00:00,2020-12-24 13:51:15.420751 +00:00,14234.00,true,976
3418,2016-06-21 11:08:00.870967 +00:00,2016-06-21 11:15:47.870967 +00:00,220.00,true,977
3419,2024-02-22 07:11:41.473524 +00:00,2024-02-29 13:51:00.473524 +00:00,8391.00,true,977
3420,2016-09-21 09:51:41.237194 +00:00,2016-09-30 05:40:18.237194 +00:00,1280.00,true,977
3421,2017-08-07 02:54:18.252344 +00:00,2017-08-11 10:31:10.252344 +00:00,2925.00,true,977
3422,2022-05-15 04:21:04.614897 +00:00,2022-05-22 21:34:22.614897 +00:00,247.00,true,977
3423,2012-04-13 09:18:29.798640 +00:00,2012-04-13 09:28:08.798640 +00:00,15302.00,true,978
3424,2015-05-08 15:04:10.666391 +00:00,2015-05-08 15:17:34.666391 +00:00,24543.00,true,979
3425,2025-07-04 21:45:28.541435 +00:00,2025-07-04 21:53:47.541435 +00:00,2726.00,true,980
3426,2025-09-05 20:39:56.777191 +00:00,2025-09-12 01:35:29.777191 +00:00,631.00,true,980
3427,2025-09-23 01:38:31.097275 +00:00,2025-10-04 11:35:27.097275 +00:00,4069.00,true,980
3428,2025-08-26 04:47:04.511404 +00:00,2025-08-28 09:04:33.511404 +00:00,5192.00,true,980
3429,2025-08-10 22:47:18.413626 +00:00,2025-08-15 16:15:32.413626 +00:00,4938.00,true,980
3430,2017-08-02 09:38:44.749061 +00:00,2017-08-02 09:53:47.749061 +00:00,14584.00,true,981
3431,2019-06-24 09:59:48.167914 +00:00,2019-07-01 23:33:38.167914 +00:00,30248.00,true,981
3432,2025-07-30 19:39:18.999551 +00:00,2025-08-10 03:10:01.999551 +00:00,2772.00,true,981
3433,2018-11-28 12:31:39.507701 +00:00,2018-11-28 12:41:31.507701 +00:00,4467.00,true,982
3434,2024-03-05 06:32:36.296346 +00:00,2024-03-10 15:18:38.296346 +00:00,3260.00,true,982
3435,2019-11-13 20:32:53.667667 +00:00,2019-11-24 05:09:17.667667 +00:00,1190.00,true,982
3436,2024-04-07 16:00:13.532624 +00:00,2024-04-17 12:29:31.532624 +00:00,4937.00,true,982
3437,2019-02-24 04:33:04.583768 +00:00,,24674.00,false,982
3438,2023-01-26 02:15:56.690261 +00:00,2023-01-26 22:53:17.690261 +00:00,3184.00,true,982
3439,2025-09-21 01:12:11.165414 +00:00,2025-09-21 01:17:18.165414 +00:00,476.00,true,983
3440,2025-09-22 02:16:07.493647 +00:00,2025-09-27 08:54:04.493647 +00:00,7871.00,true,983
3441,2025-09-29 10:59:08.547288 +00:00,,1791.00,false,983
3442,2025-09-24 14:57:17.588101 +00:00,2025-10-05 07:57:13.588101 +00:00,12508.00,true,983
3443,2025-09-29 06:21:40.689878 +00:00,2025-09-29 06:23:47.689878 +00:00,30978.00,true,984
3444,2022-02-23 17:13:50.582535 +00:00,2022-02-23 17:21:21.582535 +00:00,6377.00,true,985
3445,2022-05-04 05:56:29.072364 +00:00,2022-05-14 02:34:48.072364 +00:00,68502.00,true,985
3446,2014-04-29 01:32:31.679464 +00:00,2014-04-29 01:33:50.679464 +00:00,22508.00,true,986
3447,2018-06-11 16:33:03.225868 +00:00,2018-06-11 16:38:08.225868 +00:00,41391.00,true,987
3448,2018-06-16 16:18:13.532392 +00:00,2018-06-16 16:32:36.532392 +00:00,4689.00,true,988
3449,2025-05-14 13:46:19.119549 +00:00,2025-05-23 10:13:57.119549 +00:00,5193.00,true,988
3450,2022-08-26 13:17:15.062309 +00:00,2022-08-26 14:08:46.062309 +00:00,56.00,true,988
3451,2025-05-05 13:26:40.035648 +00:00,2025-05-06 07:17:18.035648 +00:00,6644.00,true,988
3452,2019-07-18 07:25:24.920604 +00:00,2019-07-24 07:36:01.920604 +00:00,1057.00,true,988
3453,2023-11-28 04:05:48.662156 +00:00,2023-12-09 06:29:54.662156 +00:00,1874.00,true,988
3454,2025-09-11 12:15:05.783281 +00:00,2025-09-11 12:25:55.783281 +00:00,11967.00,true,989
3455,2025-09-20 13:32:01.372121 +00:00,2025-09-27 06:51:05.372121 +00:00,12084.00,true,989
3456,2025-08-05 16:17:52.133302 +00:00,2025-08-05 16:18:30.133302 +00:00,5432.00,true,990
3457,2025-09-27 14:00:36.766708 +00:00,2025-10-04 00:17:32.766708 +00:00,1551.00,true,990
3458,2025-08-11 16:10:21.544458 +00:00,2025-08-17 08:54:19.544458 +00:00,2498.00,true,990
3459,2025-08-11 13:31:41.630802 +00:00,2025-08-14 14:37:12.630802 +00:00,1142.00,true,990
3460,2011-08-11 21:47:54.517956 +00:00,2011-08-11 21:48:25.517956 +00:00,4188.00,true,991
3461,2020-12-18 05:16:19.823992 +00:00,2020-12-20 21:07:48.823992 +00:00,3094.00,true,991
3462,2025-01-17 02:14:47.924773 +00:00,2025-01-22 01:42:50.924773 +00:00,8841.00,true,991
3463,2017-02-19 20:44:00.488124 +00:00,,20023.00,false,991
3464,2016-02-20 16:21:27.818373 +00:00,2016-02-21 07:16:25.818373 +00:00,11591.00,true,991
3465,2023-03-21 14:24:00.823586 +00:00,2023-03-29 13:34:36.823586 +00:00,7172.00,true,991
3466,2025-07-15 22:22:47.331702 +00:00,2025-07-15 22:28:04.331702 +00:00,7020.00,true,992
3467,2025-08-06 04:28:13.255784 +00:00,2025-08-12 15:35:14.255784 +00:00,58040.00,true,992
3468,2025-10-03 16:51:49.502461 +00:00,2025-10-03 17:06:17.502461 +00:00,7448.00,true,993
3469,2025-10-04 03:25:29.977133 +00:00,,4581.00,false,993
3470,2025-10-03 21:06:33.452106 +00:00,2025-10-05 09:27:39.452106 +00:00,11525.00,true,993
3471,2025-07-12 23:21:54.049943 +00:00,2025-07-12 23:37:01.049943 +00:00,7598.00,true,994
3472,2025-08-11 14:03:05.313222 +00:00,2025-08-17 23:42:23.313222 +00:00,6091.00,true,994
3473,2025-09-20 15:49:25.093584 +00:00,2025-09-24 08:26:43.093584 +00:00,3220.00,true,994
3474,2020-11-13 07:17:16.107583 +00:00,2020-11-13 07:30:03.107583 +00:00,60807.00,true,995
3475,2011-09-08 16:15:20.087826 +00:00,2011-09-08 16:28:48.087826 +00:00,50585.00,true,996
3476,2012-06-17 08:16:21.478888 +00:00,2012-06-17 08:17:19.478888 +00:00,9098.00,true,997
3477,2024-02-22 00:37:46.919776 +00:00,2024-02-25 22:11:20.919776 +00:00,492.00,true,997
3478,2018-02-05 18:45:34.651425 +00:00,2018-02-12 13:55:53.651425 +00:00,3707.00,true,997
3479,2021-02-01 11:45:24.442610 +00:00,2021-02-08 07:05:25.442610 +00:00,1041.00,true,997
3480,2021-03-10 21:43:57.459412 +00:00,2021-03-15 00:20:38.459412 +00:00,6522.00,true,997
3481,2013-12-01 01:59:51.072260 +00:00,2013-12-01 02:12:00.072260 +00:00,3609.00,true,998
3482,2025-03-12 00:41:29.388572 +00:00,2025-03-14 17:18:08.388572 +00:00,7811.00,true,998
3483,2019-06-26 21:17:27.409672 +00:00,2019-07-07 18:55:52.409672 +00:00,13775.00,true,998
3484,2018-02-20 13:25:49.251127 +00:00,2018-02-27 20:18:12.251127 +00:00,9968.00,true,998
3485,2017-05-24 22:44:26.531964 +00:00,2017-05-28 17:01:56.531964 +00:00,7471.00,true,998
3486,2022-10-07 14:29:40.247514 +00:00,2022-10-18 00:24:42.247514 +00:00,10653.00,true,998
3487,2025-09-07 19:48:40.938583 +00:00,2025-09-07 19:58:52.938583 +00:00,7006.00,true,999
3488,2025-09-23 04:13:59.972317 +00:00,2025-09-27 18:42:39.972317 +00:00,39053.00,true,999
3489,2025-09-27 07:01:26.286684 +00:00,2025-10-03 13:06:13.286684 +00:00,3127.00,true,999
3490,2025-09-15 23:08:53.596210 +00:00,2025-09-15 23:24:33.596210 +00:00,42891.00,true,1000
3491,2018-10-22 01:38:27.718117 +00:00,2018-10-22 01:45:04.718117 +00:00,7739.00,true,1001
3492,2022-08-16 22:19:45.754115 +00:00,2022-08-26 06:16:22.754115 +00:00,10874.00,true,1001
3493,2019-02-25 05:39:52.514847 +00:00,2019-03-02 15:12:29.514847 +00:00,23305.00,true,1001
3494,2025-08-06 23:39:02.433911 +00:00,2025-08-06 23:41:27.433911 +00:00,24974.00,true,1002
3495,2013-11-01 14:14:10.893297 +00:00,2013-11-01 14:22:08.893297 +00:00,23159.00,true,1003
3496,2019-04-01 13:42:29.167446 +00:00,2019-04-04 13:32:44.167446 +00:00,2688.00,true,1003
3497,2025-04-01 00:38:36.329451 +00:00,,4931.00,false,1003
3498,2023-03-30 06:58:40.752955 +00:00,2023-04-07 07:47:05.752955 +00:00,3443.00,true,1003
3499,2014-01-24 16:11:49.940881 +00:00,2014-01-29 03:24:03.940881 +00:00,21040.00,true,1003
3500,2025-08-04 17:53:39.095217 +00:00,2025-08-04 17:59:00.095217 +00:00,4551.00,true,1004
3501,2025-10-03 07:22:17.220820 +00:00,,4036.00,false,1004
3502,2025-08-15 08:50:00.694174 +00:00,2025-08-23 04:12:15.694174 +00:00,3663.00,true,1004
3503,2010-11-12 15:03:38.110147 +00:00,2010-11-12 15:16:55.110147 +00:00,1918.00,true,1005
3504,2020-10-16 14:26:00.939314 +00:00,,19821.00,false,1005
3505,2014-09-12 03:42:11.425012 +00:00,2014-09-12 03:44:59.425012 +00:00,1916.00,true,1006
3506,2022-01-03 23:00:34.214870 +00:00,2022-01-04 22:57:26.214870 +00:00,16178.00,true,1006
3507,2011-06-24 00:17:53.224368 +00:00,2011-06-24 00:32:59.224368 +00:00,5018.00,true,1007
3508,2012-08-15 05:51:43.269811 +00:00,2012-08-18 03:37:19.269811 +00:00,5040.00,true,1007
3509,2016-03-07 13:21:47.188825 +00:00,2016-03-15 23:27:46.188825 +00:00,5552.00,true,1007
3510,2021-12-03 18:25:28.890102 +00:00,2021-12-10 19:18:55.890102 +00:00,804.00,true,1007
3511,2014-05-22 00:53:13.877896 +00:00,2014-05-29 18:57:12.877896 +00:00,1499.00,true,1007
3512,2022-10-09 08:15:00.154695 +00:00,2022-10-09 08:15:26.154695 +00:00,1517.00,true,1008
3513,2023-06-22 21:02:22.285473 +00:00,2023-07-01 03:52:38.285473 +00:00,6237.00,true,1008
3514,2025-08-18 06:54:20.793683 +00:00,2025-08-28 22:13:12.793683 +00:00,2950.00,true,1008
3515,2025-09-03 07:58:28.524274 +00:00,2025-09-03 08:08:12.524274 +00:00,903.00,true,1009
3516,2025-09-24 07:44:24.315989 +00:00,2025-09-26 08:19:33.315989 +00:00,6558.00,true,1009
3517,2025-09-23 04:03:41.866830 +00:00,2025-09-24 01:58:45.866830 +00:00,2188.00,true,1009
3518,2025-09-16 12:41:12.628737 +00:00,2025-09-18 22:58:31.628737 +00:00,9610.00,true,1009
3519,2025-09-12 22:57:11.695437 +00:00,2025-09-23 17:07:34.695437 +00:00,5938.00,true,1009
3520,2025-09-25 20:46:43.140127 +00:00,2025-10-05 17:43:26.140127 +00:00,5354.00,true,1009
3521,2025-07-09 04:34:15.516983 +00:00,2025-07-09 04:41:24.516983 +00:00,43720.00,true,1010
3522,2013-03-09 07:16:59.644056 +00:00,2013-03-09 07:18:16.644056 +00:00,48637.00,true,1011
3523,2025-09-11 17:12:30.202642 +00:00,2025-09-11 17:25:22.202642 +00:00,16230.00,true,1012
3524,2025-09-23 06:18:35.167534 +00:00,2025-10-04 05:11:13.167534 +00:00,16058.00,true,1012
3525,2023-05-13 21:32:03.056489 +00:00,2023-05-13 21:36:59.056489 +00:00,36476.00,true,1013
3526,2012-10-23 11:54:10.463351 +00:00,2012-10-23 11:54:54.463351 +00:00,685.00,true,1014
3527,2024-04-05 19:58:32.863453 +00:00,2024-04-12 05:43:03.863453 +00:00,9637.00,true,1014
3528,2023-09-09 08:40:13.126388 +00:00,2023-09-13 01:18:07.126388 +00:00,5406.00,true,1014
3529,2016-09-25 19:02:25.413081 +00:00,2016-09-25 19:05:12.413081 +00:00,25020.00,true,1015
3530,2018-10-28 06:21:29.571843 +00:00,2018-11-01 23:36:45.571843 +00:00,13024.00,true,1015
3531,2019-03-30 23:46:41.746318 +00:00,2019-04-08 18:35:46.746318 +00:00,7484.00,true,1015
3532,2020-06-03 18:48:29.447307 +00:00,2020-06-06 13:26:19.447307 +00:00,9408.00,true,1015
3533,2019-06-09 22:47:16.484291 +00:00,2019-06-19 15:58:28.484291 +00:00,4302.00,true,1015
3534,2017-08-22 05:04:04.745122 +00:00,2017-08-22 19:35:08.745122 +00:00,13820.00,true,1015
3535,2020-09-12 13:28:59.690724 +00:00,2020-09-12 13:31:00.690724 +00:00,5813.00,true,1016
3536,2022-01-07 15:45:54.987826 +00:00,2022-01-12 16:26:49.987826 +00:00,12625.00,true,1016
3537,2025-08-03 05:42:45.625825 +00:00,2025-08-03 09:29:50.625825 +00:00,7722.00,true,1016
3538,2020-11-29 22:28:51.392593 +00:00,2020-12-01 18:46:39.392593 +00:00,15700.00,true,1016
3539,2022-08-18 10:41:33.558602 +00:00,2022-08-24 17:50:54.558602 +00:00,6076.00,true,1016
3540,2010-10-03 13:15:25.953980 +00:00,2010-10-03 13:20:17.953980 +00:00,190.00,true,1017
3541,2016-05-19 06:11:43.125707 +00:00,2016-05-20 16:13:53.125707 +00:00,905.00,true,1017
3542,2015-06-26 15:49:16.000324 +00:00,,285.00,false,1017
3543,2019-10-31 03:17:54.119612 +00:00,2019-11-04 05:52:33.119612 +00:00,95.00,true,1017
3544,2016-07-27 02:31:28.182627 +00:00,2016-07-29 13:28:23.182627 +00:00,313.00,true,1017
3545,2021-06-24 00:32:48.444130 +00:00,2021-06-27 19:19:35.444130 +00:00,375.00,true,1017
3546,2022-03-20 01:00:15.739015 +00:00,2022-03-20 01:15:40.739015 +00:00,9140.00,true,1018
3547,2023-06-13 04:07:27.035968 +00:00,,15053.00,false,1018
3548,2022-08-14 02:14:30.574325 +00:00,2022-08-20 14:19:46.574325 +00:00,10248.00,true,1018
3549,2022-03-20 18:17:11.432574 +00:00,,7685.00,false,1018
3550,2025-10-02 11:05:04.991836 +00:00,,17787.00,false,1018
3551,2012-02-01 12:08:41.067841 +00:00,2012-02-01 12:25:07.067841 +00:00,2887.00,true,1019
3552,2013-01-21 02:01:55.185718 +00:00,2013-01-26 13:55:54.185718 +00:00,756.00,true,1019
3553,2022-07-01 08:59:48.162290 +00:00,2022-07-02 19:51:39.162290 +00:00,1200.00,true,1019
3554,2016-04-02 03:48:50.809879 +00:00,2016-04-08 17:20:35.809879 +00:00,441.00,true,1019
3555,2024-09-10 15:59:51.368308 +00:00,2024-09-10 16:05:56.368308 +00:00,186.00,true,1020
3556,2025-08-12 11:30:48.543701 +00:00,2025-08-14 04:17:42.543701 +00:00,52.00,true,1020
3557,2025-02-08 16:28:53.464082 +00:00,2025-02-19 19:50:08.464082 +00:00,334.00,true,1020
3558,2025-02-20 07:40:38.213697 +00:00,2025-02-28 08:25:00.213697 +00:00,101.00,true,1020
3559,2025-05-05 20:15:10.506883 +00:00,2025-05-10 19:08:16.506883 +00:00,103.00,true,1020
3560,2025-08-20 03:38:38.334678 +00:00,2025-08-20 03:41:43.334678 +00:00,1631.00,true,1021
3561,2025-09-30 23:21:29.440231 +00:00,,2275.00,false,1021
3562,2025-10-03 11:56:46.659581 +00:00,,5948.00,false,1021
3563,2025-08-15 23:15:12.706368 +00:00,2025-08-15 23:16:28.706368 +00:00,2953.00,true,1022
3564,2025-09-12 06:24:41.914533 +00:00,2025-09-22 16:41:30.914533 +00:00,358.00,true,1022
3565,2025-10-04 13:58:07.294510 +00:00,,1262.00,false,1022
3566,2025-09-21 12:02:05.392764 +00:00,2025-09-29 06:19:38.392764 +00:00,4394.00,true,1022
3567,2025-09-20 20:54:13.349004 +00:00,2025-09-23 11:12:34.349004 +00:00,3802.00,true,1022
3568,2025-10-03 10:01:51.348313 +00:00,,1929.00,false,1022
3569,2013-02-04 06:19:07.161892 +00:00,2013-02-04 06:27:53.161892 +00:00,37.00,true,1023
3570,2017-02-21 14:16:09.881340 +00:00,2017-02-27 02:58:37.881340 +00:00,2459.00,true,1023
3571,2023-05-22 10:27:46.990848 +00:00,2023-05-27 10:20:38.990848 +00:00,437.00,true,1023
3572,2014-06-05 00:52:48.237365 +00:00,2014-06-10 00:12:59.237365 +00:00,143.00,true,1023
3573,2019-09-13 05:43:40.465662 +00:00,2019-09-22 14:21:13.465662 +00:00,121.00,true,1023
3574,2016-08-10 16:44:53.722163 +00:00,2016-08-16 09:43:35.722163 +00:00,1738.00,true,1023
3575,2021-04-14 05:26:03.748486 +00:00,2021-04-14 05:26:49.748486 +00:00,28073.00,true,1024
3576,2023-10-17 12:41:16.022726 +00:00,2023-10-25 23:44:07.022726 +00:00,3729.00,true,1024
3577,2022-09-11 20:30:34.626442 +00:00,2022-09-13 13:15:31.626442 +00:00,420.00,true,1024
3578,2015-04-13 08:27:24.186601 +00:00,2015-04-13 08:33:44.186601 +00:00,10356.00,true,1025
3579,2017-02-07 01:08:39.327616 +00:00,2017-02-11 05:18:56.327616 +00:00,11946.00,true,1025
3580,2018-12-28 02:17:37.266335 +00:00,2019-01-01 21:39:08.266335 +00:00,6530.00,true,1025
3581,2025-01-20 03:46:58.848434 +00:00,2025-01-29 15:22:10.848434 +00:00,286.00,true,1025
3582,2019-11-12 02:58:47.378337 +00:00,2019-11-22 15:59:43.378337 +00:00,13774.00,true,1025
3583,2016-07-30 11:28:40.687939 +00:00,2016-07-31 23:42:00.687939 +00:00,18459.00,true,1025
3584,2025-08-05 20:04:16.808298 +00:00,2025-08-05 20:07:32.808298 +00:00,887.00,true,1026
3585,2025-08-19 07:26:13.750841 +00:00,2025-08-30 10:43:30.750841 +00:00,69.00,true,1026
3586,2025-10-03 17:01:46.523284 +00:00,,619.00,false,1026
3587,2025-09-30 21:42:33.377691 +00:00,,294.00,false,1026
3588,2025-08-07 23:29:49.382392 +00:00,2025-08-07 23:32:24.382392 +00:00,10403.00,true,1027
3589,2025-09-18 06:13:27.555248 +00:00,2025-09-28 04:22:56.555248 +00:00,17703.00,true,1027
3590,2025-08-16 23:08:16.918961 +00:00,2025-08-21 07:23:55.918961 +00:00,864.00,true,1027
3591,2012-04-27 07:12:33.511989 +00:00,2012-04-27 07:17:27.511989 +00:00,3801.00,true,1028
3592,2017-02-20 08:09:09.838495 +00:00,2017-02-22 17:13:34.838495 +00:00,7384.00,true,1028
3593,2015-11-22 07:31:13.840973 +00:00,2015-11-25 03:33:30.840973 +00:00,4610.00,true,1028
3594,2012-10-08 14:16:47.179404 +00:00,2012-10-15 16:16:09.179404 +00:00,3439.00,true,1028
3595,2022-11-04 23:22:13.703276 +00:00,2022-11-07 21:54:22.703276 +00:00,2656.00,true,1028
3596,2019-10-24 00:04:42.528954 +00:00,2019-10-24 02:55:53.528954 +00:00,5995.00,true,1028
3597,2025-07-30 19:40:29.056092 +00:00,2025-07-30 19:47:37.056092 +00:00,262.00,true,1029
3598,2025-09-17 17:04:59.270503 +00:00,2025-09-20 18:39:48.270503 +00:00,1983.00,true,1029
3599,2025-08-20 18:19:36.408735 +00:00,2025-08-27 14:41:51.408735 +00:00,3803.00,true,1029
3600,2025-09-19 21:52:29.154274 +00:00,2025-09-29 04:38:15.154274 +00:00,1189.00,true,1029
3601,2025-08-30 05:16:19.736125 +00:00,2025-09-04 19:51:37.736125 +00:00,370.00,true,1029
3602,2025-02-02 22:15:43.939165 +00:00,2025-02-02 22:27:31.939165 +00:00,3675.00,true,1030
3603,2025-04-10 01:07:13.336390 +00:00,2025-04-17 10:12:51.336390 +00:00,19060.00,true,1030
3604,2025-03-25 10:47:28.752678 +00:00,2025-04-01 21:15:59.752678 +00:00,20791.00,true,1030
3605,2025-08-30 22:01:48.850524 +00:00,2025-08-30 22:16:20.850524 +00:00,44936.00,true,1031
3606,2025-09-06 14:11:22.928258 +00:00,2025-09-09 05:14:26.928258 +00:00,19582.00,true,1031
3607,2013-10-10 05:16:20.623058 +00:00,2013-10-10 05:25:04.623058 +00:00,2630.00,true,1032
3608,2017-09-20 22:49:19.887281 +00:00,,934.00,false,1032
3609,2024-11-04 06:49:26.119934 +00:00,2024-11-05 21:20:45.119934 +00:00,1135.00,true,1032
3610,2022-01-08 22:19:29.877708 +00:00,2022-01-09 16:40:22.877708 +00:00,894.00,true,1032
3611,2021-07-20 09:02:17.568329 +00:00,2021-07-21 09:29:19.568329 +00:00,111.00,true,1032
3612,2024-10-29 09:35:33.513653 +00:00,2024-11-01 00:42:21.513653 +00:00,2359.00,true,1032
3613,2020-08-06 18:07:29.367943 +00:00,2020-08-06 18:13:13.367943 +00:00,1603.00,true,1033
3614,2025-07-17 20:51:56.510883 +00:00,2025-07-22 10:33:23.510883 +00:00,4200.00,true,1033
3615,2023-02-25 12:06:04.752928 +00:00,2023-02-28 13:21:06.752928 +00:00,92.00,true,1033
3616,2022-08-29 22:18:45.881799 +00:00,2022-09-02 09:21:18.881799 +00:00,4933.00,true,1033
3617,2024-07-22 01:57:24.867836 +00:00,2024-07-31 03:49:41.867836 +00:00,2830.00,true,1033
3618,2010-10-28 14:39:53.791366 +00:00,2010-10-28 14:49:17.791366 +00:00,9319.00,true,1034
3619,2022-12-08 07:30:47.694098 +00:00,2022-12-08 13:25:53.694098 +00:00,3279.00,true,1034
3620,2011-05-31 02:40:19.935630 +00:00,2011-06-08 16:15:31.935630 +00:00,1614.00,true,1034
3621,2014-07-14 15:12:05.847544 +00:00,,2063.00,false,1034
3622,2023-07-14 11:08:39.094611 +00:00,2023-07-14 11:22:16.094611 +00:00,3060.00,true,1035
3623,2025-01-02 06:12:55.654899 +00:00,2025-01-07 06:09:30.654899 +00:00,2995.00,true,1035
3624,2023-12-27 13:27:48.481578 +00:00,,4126.00,false,1035
3625,2023-12-11 17:49:48.757189 +00:00,2023-12-21 19:04:51.757189 +00:00,6959.00,true,1035
3626,2023-12-31 00:43:21.791606 +00:00,2024-01-08 17:17:54.791606 +00:00,994.00,true,1035
3627,2010-01-19 09:37:52.940950 +00:00,2010-01-19 09:51:31.940950 +00:00,3170.00,true,1036
3628,2024-12-01 08:48:12.610341 +00:00,2024-12-07 14:07:13.610341 +00:00,1829.00,true,1036
3629,2010-06-17 01:01:01.782672 +00:00,2010-06-24 14:42:08.782672 +00:00,1194.00,true,1036
3630,2017-09-27 16:13:35.479194 +00:00,2017-09-27 16:22:45.479194 +00:00,24261.00,true,1037
3631,2024-07-26 08:32:29.758247 +00:00,2024-08-02 16:19:47.758247 +00:00,3060.00,true,1037
3632,2019-09-08 00:05:35.138770 +00:00,2019-09-10 08:42:58.138770 +00:00,1627.00,true,1037
3633,2025-08-10 11:14:07.002065 +00:00,2025-08-10 11:23:59.002065 +00:00,4927.00,true,1038
3634,2025-10-03 13:34:58.157470 +00:00,,351.00,false,1038
3635,2025-08-14 22:34:41.855818 +00:00,2025-08-21 19:56:13.855818 +00:00,10738.00,true,1038
3636,2025-10-03 00:42:42.269964 +00:00,,3995.00,false,1038
3637,2025-09-16 18:15:51.211385 +00:00,2025-09-27 16:14:08.211385 +00:00,107.00,true,1038
3638,2025-08-16 20:55:14.706648 +00:00,2025-08-22 15:11:22.706648 +00:00,8524.00,true,1038
3639,2013-07-21 02:44:00.772871 +00:00,2013-07-21 02:44:42.772871 +00:00,6750.00,true,1039
3640,2016-04-09 05:49:02.704106 +00:00,,8237.00,false,1039
3641,2015-06-03 13:28:24.442301 +00:00,2015-06-14 12:35:08.442301 +00:00,7043.00,true,1039
3642,2017-02-22 17:58:48.963496 +00:00,2017-02-28 14:23:26.963496 +00:00,29596.00,true,1039
3643,2016-12-20 17:04:29.246213 +00:00,2016-12-30 13:08:45.246213 +00:00,8724.00,true,1039
3644,2020-03-21 08:22:02.106062 +00:00,2020-03-24 07:01:33.106062 +00:00,3846.00,true,1039
3645,2025-08-19 12:45:55.273566 +00:00,2025-08-19 12:51:13.273566 +00:00,4444.00,true,1040
3646,2025-09-14 12:11:50.292761 +00:00,2025-09-25 15:21:55.292761 +00:00,3124.00,true,1040
3647,2025-08-20 10:22:19.021112 +00:00,2025-08-25 03:54:40.021112 +00:00,4078.00,true,1040
3648,2025-10-03 21:32:59.299932 +00:00,2025-10-04 05:03:46.299932 +00:00,18829.00,true,1040
3649,2025-09-05 00:27:59.925144 +00:00,2025-09-15 09:30:36.925144 +00:00,3548.00,true,1040
3650,2023-08-26 07:56:45.334218 +00:00,2023-08-26 08:04:02.334218 +00:00,1270.00,true,1041
3651,2025-06-16 23:08:04.312079 +00:00,2025-06-18 03:52:48.312079 +00:00,12230.00,true,1041
3652,2024-08-28 05:57:47.598534 +00:00,2024-08-31 16:39:05.598534 +00:00,157.00,true,1041
3653,2025-08-24 06:57:09.146847 +00:00,2025-08-24 07:03:10.146847 +00:00,1843.00,true,1042
3654,2025-09-18 08:38:23.536241 +00:00,2025-09-24 08:48:03.536241 +00:00,197.00,true,1042
3655,2025-09-08 23:31:46.581989 +00:00,2025-09-15 19:24:37.581989 +00:00,823.00,true,1042
3656,2025-10-02 20:22:48.768232 +00:00,,3460.00,false,1042
3657,2015-01-06 00:08:20.126618 +00:00,2015-01-06 00:18:20.126618 +00:00,2400.00,true,1043
3658,2017-11-14 17:20:27.691684 +00:00,2017-11-26 03:24:29.691684 +00:00,25363.00,true,1043
3659,2019-05-21 05:42:48.792475 +00:00,2019-05-21 05:52:18.792475 +00:00,29007.00,true,1044
3660,2014-11-25 07:42:39.960490 +00:00,2014-11-25 07:49:51.960490 +00:00,3507.00,true,1045
3661,2023-03-15 11:46:03.630695 +00:00,,4332.00,false,1045
3662,2016-12-03 20:02:51.704656 +00:00,2016-12-06 19:57:13.704656 +00:00,7594.00,true,1045
3663,2022-09-23 21:18:13.461981 +00:00,2022-09-26 19:07:29.461981 +00:00,2216.00,true,1045
3664,2015-10-25 21:14:14.330447 +00:00,2015-10-30 16:17:36.330447 +00:00,25020.00,true,1045
3665,2018-08-03 05:28:33.377388 +00:00,2018-08-03 14:12:08.377388 +00:00,15345.00,true,1045
3666,2019-01-05 22:24:02.444839 +00:00,2019-01-05 22:37:44.444839 +00:00,442.00,true,1046
3667,2021-10-16 06:29:35.725754 +00:00,2021-10-23 13:16:45.725754 +00:00,9898.00,true,1046
3668,2019-02-14 06:33:19.523644 +00:00,2019-02-22 12:33:16.523644 +00:00,644.00,true,1046
3669,2018-04-25 06:25:09.339008 +00:00,2018-04-25 06:33:06.339008 +00:00,8630.00,true,1047
3670,2022-08-28 17:33:46.090072 +00:00,2022-08-30 11:06:20.090072 +00:00,9991.00,true,1047
3671,2012-04-11 03:28:49.666592 +00:00,2012-04-11 03:30:08.666592 +00:00,11388.00,true,1048
3672,2015-01-22 01:15:41.378716 +00:00,2015-01-28 04:18:48.378716 +00:00,26477.00,true,1048
3673,2021-07-03 21:28:20.481512 +00:00,2021-07-07 10:38:45.481512 +00:00,20104.00,true,1048
3674,2015-02-28 21:42:52.660238 +00:00,2015-02-28 21:44:43.660238 +00:00,1160.00,true,1049
3675,2021-08-08 00:28:18.769387 +00:00,2021-08-13 07:25:09.769387 +00:00,1289.00,true,1049
3676,2018-01-19 09:36:14.689900 +00:00,2018-01-24 18:45:02.689900 +00:00,140.00,true,1049
3677,2015-03-14 07:27:38.409833 +00:00,2015-03-23 06:01:06.409833 +00:00,2616.00,true,1049
3678,2023-09-19 14:53:13.837897 +00:00,2023-09-19 17:15:33.837897 +00:00,558.00,true,1049
3679,2024-08-01 12:33:54.369699 +00:00,2024-08-11 14:24:08.369699 +00:00,808.00,true,1049
3680,2025-07-05 09:12:32.993011 +00:00,2025-07-05 09:28:39.993011 +00:00,2896.00,true,1050
3681,2025-08-04 06:16:16.815640 +00:00,2025-08-09 18:40:23.815640 +00:00,18772.00,true,1050
3682,2025-09-02 10:23:32.841693 +00:00,,16006.00,false,1050
3683,2022-09-10 17:06:10.524626 +00:00,2022-09-10 17:10:48.524626 +00:00,12264.00,true,1051
3684,2023-03-01 13:15:37.303373 +00:00,2023-03-11 22:11:49.303373 +00:00,6239.00,true,1051
3685,2025-07-13 00:58:57.619348 +00:00,2025-07-24 05:11:59.619348 +00:00,48434.00,true,1051
3686,2012-09-05 08:42:53.187651 +00:00,2012-09-05 08:50:51.187651 +00:00,19376.00,true,1052
3687,2025-03-16 05:58:14.946556 +00:00,2025-03-16 06:09:28.946556 +00:00,9301.00,true,1053
3688,2025-04-21 18:05:13.361166 +00:00,,15497.00,false,1053
3689,2025-05-20 10:55:37.974298 +00:00,2025-05-28 14:43:50.974298 +00:00,345.00,true,1053
3690,2015-05-20 18:49:00.031307 +00:00,2015-05-20 19:05:10.031307 +00:00,2572.00,true,1054
3691,2018-04-19 09:44:22.897311 +00:00,2018-04-29 06:37:23.897311 +00:00,21326.00,true,1054
3692,2025-07-06 03:06:58.758147 +00:00,2025-07-06 03:21:00.758147 +00:00,24228.00,true,1055
3693,2014-09-07 23:22:45.577585 +00:00,2014-09-07 23:31:03.577585 +00:00,38818.00,true,1056
3694,2017-02-04 08:02:23.468678 +00:00,2017-02-04 08:06:19.468678 +00:00,8694.00,true,1057
3695,2019-07-21 07:28:49.670372 +00:00,2019-07-23 17:44:58.670372 +00:00,1826.00,true,1057
3696,2019-08-24 22:24:11.201909 +00:00,2019-08-27 06:12:54.201909 +00:00,3060.00,true,1057
3697,2020-04-23 17:44:05.635724 +00:00,2020-04-25 06:23:40.635724 +00:00,11560.00,true,1057
3698,2011-02-20 21:07:38.294116 +00:00,2011-02-20 21:13:57.294116 +00:00,8928.00,true,1058
3699,2015-12-29 18:53:37.082640 +00:00,2015-12-31 20:54:07.082640 +00:00,1199.00,true,1058
3700,2016-08-04 20:39:04.995758 +00:00,2016-08-11 14:13:56.995758 +00:00,39863.00,true,1058
3701,2025-08-21 10:40:44.225361 +00:00,2025-08-21 10:55:55.225361 +00:00,37800.00,true,1059
3702,2019-02-07 10:41:10.136719 +00:00,2019-02-07 10:55:05.136719 +00:00,5866.00,true,1060
3703,2020-05-29 19:29:24.505846 +00:00,2020-06-04 22:17:00.505846 +00:00,1526.00,true,1060
3704,2025-09-14 22:00:32.348946 +00:00,2025-09-18 03:21:36.348946 +00:00,808.00,true,1060
3705,2022-11-19 06:16:17.554374 +00:00,2022-11-28 13:10:22.554374 +00:00,209.00,true,1060
3706,2023-08-22 17:58:03.959488 +00:00,2023-08-24 09:17:23.959488 +00:00,120.00,true,1060
3707,2024-12-26 11:10:54.104331 +00:00,2024-12-30 23:05:20.104331 +00:00,2010.00,true,1060
3708,2025-06-28 11:14:56.192031 +00:00,2025-06-28 11:16:07.192031 +00:00,22686.00,true,1061
3709,2025-08-11 23:04:14.407303 +00:00,2025-08-21 07:55:58.407303 +00:00,14781.00,true,1061
3710,2025-07-11 20:34:25.879846 +00:00,2025-07-22 06:24:40.879846 +00:00,11739.00,true,1061
3711,2015-03-31 05:42:10.851264 +00:00,2015-03-31 05:50:31.851264 +00:00,248.00,true,1062
3712,2020-02-29 12:36:40.442021 +00:00,2020-03-11 04:26:24.442021 +00:00,2179.00,true,1062
3713,2018-12-10 12:12:04.390543 +00:00,2018-12-16 16:43:57.390543 +00:00,6759.00,true,1062
3714,2024-12-29 09:02:34.611449 +00:00,2025-01-07 00:06:34.611449 +00:00,11937.00,true,1062
3715,2017-11-04 10:13:22.870862 +00:00,2017-11-13 00:50:23.870862 +00:00,25983.00,true,1062
3716,2025-10-01 06:48:32.137894 +00:00,2025-10-01 06:51:34.137894 +00:00,3431.00,true,1063
3717,2025-10-03 21:02:11.785053 +00:00,,1533.00,false,1063
3718,2025-10-01 07:30:22.969381 +00:00,2025-10-03 06:19:22.969381 +00:00,988.00,true,1063
3719,2025-10-02 09:15:14.200997 +00:00,,1565.00,false,1063
3720,2025-10-04 15:36:05.286738 +00:00,,2971.00,false,1063
3721,2025-10-04 11:04:17.535658 +00:00,,4225.00,false,1063
3722,2012-08-21 15:46:25.670166 +00:00,2012-08-21 15:59:22.670166 +00:00,937.00,true,1064
3723,2022-04-08 05:28:49.501106 +00:00,2022-04-14 05:54:34.501106 +00:00,766.00,true,1064
3724,2021-09-24 13:07:32.420913 +00:00,2021-09-25 08:40:58.420913 +00:00,2196.00,true,1064
3725,2020-12-29 19:14:38.080010 +00:00,2020-12-31 08:22:39.080010 +00:00,8747.00,true,1064
3726,2016-02-22 11:53:18.231326 +00:00,2016-02-25 17:59:23.231326 +00:00,779.00,true,1064
3727,2016-07-20 02:07:34.780279 +00:00,2016-07-29 10:56:17.780279 +00:00,3057.00,true,1064
3728,2025-08-09 04:07:10.367208 +00:00,2025-08-09 04:22:14.367208 +00:00,10003.00,true,1065
3729,2025-08-10 15:49:30.803065 +00:00,2025-08-11 03:26:11.803065 +00:00,4185.00,true,1065
3730,2025-08-19 04:08:16.109144 +00:00,2025-08-19 12:21:14.109144 +00:00,1452.00,true,1065
3731,2025-08-28 02:57:37.669603 +00:00,2025-08-30 17:58:20.669603 +00:00,8156.00,true,1065
3732,2020-09-24 21:14:44.165833 +00:00,2020-09-24 21:27:16.165833 +00:00,55.00,true,1066
3733,2024-12-20 09:20:19.116304 +00:00,2024-12-24 11:22:35.116304 +00:00,95.00,true,1066
3734,2023-06-30 09:25:54.025474 +00:00,2023-07-08 19:25:29.025474 +00:00,111.00,true,1066
3735,2020-12-16 08:29:39.427978 +00:00,2020-12-26 21:58:57.427978 +00:00,66.00,true,1066
3736,2025-07-30 12:45:22.374738 +00:00,2025-07-30 12:51:12.374738 +00:00,18151.00,true,1067
3737,2025-09-27 11:55:00.774405 +00:00,2025-09-29 01:37:08.774405 +00:00,26199.00,true,1067
3738,2013-02-14 06:03:33.203337 +00:00,2013-02-14 06:11:13.203337 +00:00,346.00,true,1068
3739,2018-05-08 19:25:37.316288 +00:00,2018-05-08 19:26:15.316288 +00:00,3807.00,true,1069
3740,2020-04-12 05:10:27.104753 +00:00,2020-04-17 05:52:17.104753 +00:00,1433.00,true,1069
3741,2021-06-03 14:41:41.147867 +00:00,2021-06-11 12:58:27.147867 +00:00,1168.00,true,1069
3742,2019-09-08 20:37:28.606563 +00:00,2019-09-09 04:45:30.606563 +00:00,1031.00,true,1069
3743,2020-09-02 08:39:22.169818 +00:00,2020-09-03 14:56:12.169818 +00:00,5041.00,true,1069
3744,2011-02-08 10:10:47.354462 +00:00,2011-02-08 10:24:07.354462 +00:00,1699.00,true,1070
3745,2011-06-22 00:35:08.301095 +00:00,2011-06-27 12:33:56.301095 +00:00,973.00,true,1070
3746,2013-01-12 12:56:38.905572 +00:00,2013-01-19 14:44:56.905572 +00:00,3180.00,true,1070
3747,2023-09-06 19:41:44.474690 +00:00,2023-09-12 13:23:57.474690 +00:00,1054.00,true,1070
3748,2011-03-24 05:38:26.463251 +00:00,2011-03-30 12:50:36.463251 +00:00,1577.00,true,1070
3749,2022-12-15 01:32:40.293216 +00:00,2022-12-15 01:43:06.293216 +00:00,17344.00,true,1071
3750,2018-02-06 01:44:29.826672 +00:00,2018-02-06 01:46:33.826672 +00:00,1865.00,true,1072
3751,2020-08-10 00:02:32.200143 +00:00,2020-08-13 04:49:09.200143 +00:00,533.00,true,1072
3752,2021-05-18 06:09:04.752934 +00:00,2021-05-22 07:27:56.752934 +00:00,2215.00,true,1072
3753,2019-09-02 05:44:29.207480 +00:00,2019-09-08 20:10:50.207480 +00:00,2158.00,true,1072
3754,2022-11-15 17:07:23.825491 +00:00,2022-11-22 20:57:22.825491 +00:00,2731.00,true,1072
3755,2016-11-20 00:37:06.972311 +00:00,2016-11-20 00:41:24.972311 +00:00,2835.00,true,1073
3756,2025-01-02 09:59:52.831125 +00:00,2025-01-04 18:38:08.831125 +00:00,1786.00,true,1073
3757,2018-03-17 14:16:42.099363 +00:00,2018-03-19 09:07:18.099363 +00:00,1763.00,true,1073
3758,2014-08-12 07:37:56.444152 +00:00,2014-08-12 07:39:53.444152 +00:00,50289.00,true,1074
3759,2011-10-25 17:06:13.445552 +00:00,2011-10-25 17:12:08.445552 +00:00,784.00,true,1075
3760,2021-03-22 04:35:30.717128 +00:00,2021-03-23 16:47:12.717128 +00:00,21486.00,true,1075
3761,2014-06-29 11:49:27.853497 +00:00,2014-07-07 22:01:00.853497 +00:00,2712.00,true,1075
3762,2020-10-17 22:31:00.910204 +00:00,2020-10-17 22:35:40.910204 +00:00,4119.00,true,1076
3763,2022-08-30 09:08:05.242537 +00:00,2022-09-03 08:22:34.242537 +00:00,753.00,true,1076
3764,2022-10-08 06:28:38.127085 +00:00,2022-10-14 12:23:00.127085 +00:00,7963.00,true,1076
3765,2023-09-04 23:16:30.237802 +00:00,2023-09-06 19:27:15.237802 +00:00,2195.00,true,1076
3766,2025-09-24 07:23:35.310039 +00:00,2025-09-24 07:24:37.310039 +00:00,5803.00,true,1077
3767,2025-10-01 20:17:33.456962 +00:00,,513.00,false,1077
3768,2025-09-29 21:50:55.209522 +00:00,,782.00,false,1077
3769,2025-10-04 06:05:32.378566 +00:00,,11970.00,false,1077
3770,2025-09-28 03:56:22.126662 +00:00,2025-10-05 11:41:53.126662 +00:00,277.00,true,1077
3771,2018-07-15 13:18:12.727553 +00:00,2018-07-15 13:18:38.727553 +00:00,4394.00,true,1078
3772,2024-08-29 23:10:42.297906 +00:00,2024-09-01 18:37:38.297906 +00:00,10035.00,true,1078
3773,2021-06-03 17:07:36.860171 +00:00,2021-06-13 07:13:01.860171 +00:00,1134.00,true,1078
3774,2025-03-10 04:50:43.509188 +00:00,2025-03-15 13:10:25.509188 +00:00,13508.00,true,1078
3775,2022-12-11 13:54:55.227143 +00:00,2022-12-12 17:19:43.227143 +00:00,600.00,true,1078
3776,2024-02-06 08:09:07.162444 +00:00,,11076.00,false,1078
3777,2025-09-30 00:41:36.062315 +00:00,2025-09-30 00:42:17.062315 +00:00,14639.00,true,1079
3778,2025-10-03 01:45:07.129111 +00:00,,606.00,false,1079
3779,2025-10-03 23:08:37.456045 +00:00,2025-10-05 22:46:32.456045 +00:00,2094.00,true,1079
3780,2025-09-30 03:39:55.831280 +00:00,,5797.00,false,1079
3781,2025-10-02 10:49:24.052858 +00:00,2025-10-04 15:32:29.052858 +00:00,2951.00,true,1079
3782,2022-01-06 16:37:31.874586 +00:00,2022-01-06 16:47:26.874586 +00:00,1609.00,true,1080
3783,2022-01-10 17:17:06.663176 +00:00,2022-01-18 19:44:55.663176 +00:00,5955.00,true,1080
3784,2024-11-20 03:38:34.429440 +00:00,2024-11-26 17:25:19.429440 +00:00,5774.00,true,1080
3785,2024-04-24 07:55:42.225713 +00:00,2024-04-25 05:16:07.225713 +00:00,415.00,true,1080
3786,2023-02-23 06:14:37.697850 +00:00,2023-02-24 11:11:38.697850 +00:00,6517.00,true,1080
3787,2022-10-31 05:37:36.015454 +00:00,2022-10-31 05:40:15.015454 +00:00,7986.00,true,1081
3788,2025-03-31 02:20:58.662507 +00:00,2025-04-05 19:02:11.662507 +00:00,24689.00,true,1081
3789,2024-07-11 13:28:38.374707 +00:00,2024-07-19 22:01:28.374707 +00:00,3101.00,true,1081
3790,2024-05-24 11:58:31.865241 +00:00,2024-06-02 01:53:17.865241 +00:00,8473.00,true,1081
3791,2024-04-28 12:04:48.599605 +00:00,2024-04-29 20:28:07.599605 +00:00,11468.00,true,1081
3792,2022-09-18 07:34:20.037981 +00:00,2022-09-18 07:38:14.037981 +00:00,5355.00,true,1082
3793,2023-10-26 11:45:31.280300 +00:00,2023-10-31 05:32:38.280300 +00:00,4884.00,true,1082
3794,2024-06-06 03:28:32.166829 +00:00,2024-06-08 21:37:39.166829 +00:00,5060.00,true,1082
3795,2025-05-27 06:50:14.479088 +00:00,2025-06-02 01:04:46.479088 +00:00,392.00,true,1082
3796,2023-07-23 21:00:37.672498 +00:00,2023-07-29 06:58:13.672498 +00:00,3939.00,true,1082
3797,2016-04-19 11:32:06.501753 +00:00,2016-04-19 11:38:48.501753 +00:00,2949.00,true,1083
3798,2021-11-24 21:38:29.488644 +00:00,2021-11-25 19:06:54.488644 +00:00,15552.00,true,1083
3799,2022-12-25 17:08:48.151901 +00:00,2022-12-29 21:25:27.151901 +00:00,7029.00,true,1083
3800,2023-07-13 00:40:41.257407 +00:00,2023-07-15 11:53:47.257407 +00:00,2236.00,true,1083
3801,2017-10-06 02:35:40.680358 +00:00,2017-10-12 12:33:53.680358 +00:00,4832.00,true,1083
3802,2020-01-02 01:20:26.466925 +00:00,2020-01-11 06:17:37.466925 +00:00,2518.00,true,1083
3803,2017-02-26 19:57:29.566178 +00:00,2017-02-26 20:12:34.566178 +00:00,493.00,true,1084
3804,2017-06-16 13:46:13.949785 +00:00,2017-06-23 19:17:45.949785 +00:00,38248.00,true,1084
3805,2024-07-25 00:57:45.159199 +00:00,2024-07-25 01:11:53.159199 +00:00,9064.00,true,1085
3806,2025-03-24 04:18:57.715782 +00:00,2025-04-03 11:02:30.715782 +00:00,2695.00,true,1085
3807,2025-04-27 00:03:21.016985 +00:00,2025-05-07 02:28:13.016985 +00:00,882.00,true,1085
3808,2024-11-07 10:59:23.058090 +00:00,2024-11-16 10:17:42.058090 +00:00,12509.00,true,1085
3809,2013-09-03 08:09:17.229167 +00:00,2013-09-03 08:18:03.229167 +00:00,20359.00,true,1086
3810,2024-02-27 09:56:17.879383 +00:00,2024-02-28 19:55:23.879383 +00:00,8904.00,true,1086
3811,2021-10-01 16:56:01.120975 +00:00,2021-10-08 18:17:48.120975 +00:00,167.00,true,1086
3812,2024-04-28 09:23:30.905262 +00:00,2024-04-28 09:32:46.905262 +00:00,1024.00,true,1087
3813,2024-11-10 05:52:13.991508 +00:00,2024-11-13 20:12:53.991508 +00:00,99.00,true,1087
3814,2025-05-11 21:42:57.259529 +00:00,2025-05-14 01:39:57.259529 +00:00,122.00,true,1087
3815,2025-05-28 12:56:43.937150 +00:00,2025-06-01 00:40:42.937150 +00:00,40.00,true,1087
3816,2025-09-23 22:21:12.869773 +00:00,2025-09-24 12:39:06.869773 +00:00,356.00,true,1087
3817,2025-06-22 13:20:16.858126 +00:00,2025-06-27 09:25:24.858126 +00:00,247.00,true,1087
3818,2011-03-05 14:13:10.410344 +00:00,2011-03-05 14:26:28.410344 +00:00,23393.00,true,1088
3819,2020-03-29 20:01:57.625438 +00:00,2020-04-07 12:06:16.625438 +00:00,1320.00,true,1088
3820,2016-01-28 06:23:55.063431 +00:00,2016-01-31 00:09:56.063431 +00:00,48146.00,true,1088
3821,2018-10-16 22:18:03.272058 +00:00,2018-10-28 10:40:52.272058 +00:00,1252.00,true,1088
3822,2019-01-14 14:50:54.449998 +00:00,2019-01-17 11:27:34.449998 +00:00,250.00,true,1088
3823,2015-09-02 14:33:39.360365 +00:00,2015-09-02 14:42:12.360365 +00:00,4080.00,true,1089
3824,2022-06-06 05:47:38.476676 +00:00,2022-06-17 08:38:35.476676 +00:00,6595.00,true,1089
3825,2018-01-06 13:00:19.636795 +00:00,2018-01-16 12:07:52.636795 +00:00,1353.00,true,1089
3826,2020-12-05 04:38:01.723343 +00:00,2020-12-07 23:00:38.723343 +00:00,1627.00,true,1089
3827,2019-04-28 03:38:54.495850 +00:00,2019-04-29 15:17:13.495850 +00:00,6850.00,true,1089
3828,2018-10-13 09:28:48.413577 +00:00,2018-10-13 09:42:35.413577 +00:00,528.00,true,1090
3829,2020-11-26 15:41:46.942910 +00:00,2020-12-05 19:17:15.942910 +00:00,810.00,true,1090
3830,2021-03-25 10:52:30.599393 +00:00,2021-03-29 10:19:52.599393 +00:00,5936.00,true,1090
3831,2024-04-17 10:08:40.446503 +00:00,2024-04-18 03:43:26.446503 +00:00,1158.00,true,1090
3832,2025-07-12 23:33:29.186638 +00:00,2025-07-12 23:34:35.186638 +00:00,212.00,true,1091
3833,2025-09-19 22:16:39.236182 +00:00,2025-09-20 18:45:43.236182 +00:00,15846.00,true,1091
3834,2025-08-27 23:40:04.431495 +00:00,2025-09-04 11:51:48.431495 +00:00,9181.00,true,1091
3835,2025-08-26 02:05:28.492820 +00:00,2025-09-02 12:27:44.492820 +00:00,34002.00,true,1091
3836,2025-07-17 00:07:23.571005 +00:00,2025-07-25 14:27:59.571005 +00:00,2310.00,true,1091
3837,2025-06-08 11:14:41.831418 +00:00,2025-06-08 11:15:25.831418 +00:00,7536.00,true,1092
3838,2025-07-29 09:45:47.018830 +00:00,2025-07-29 18:10:56.018830 +00:00,5353.00,true,1092
3839,2025-07-01 10:06:24.389500 +00:00,2025-07-11 14:32:09.389500 +00:00,1844.00,true,1092
3840,2025-10-03 14:08:11.105522 +00:00,,16749.00,false,1092
3841,2013-05-05 21:47:28.311350 +00:00,2013-05-05 21:54:40.311350 +00:00,3694.00,true,1093
3842,2020-11-01 02:00:59.043133 +00:00,2020-11-02 17:53:10.043133 +00:00,7379.00,true,1093
3843,2024-06-29 00:47:26.150018 +00:00,2024-06-30 15:18:39.150018 +00:00,3554.00,true,1093
3844,2020-09-04 02:18:47.996927 +00:00,2020-09-06 20:13:49.996927 +00:00,7293.00,true,1093
3845,2023-09-16 13:53:27.683262 +00:00,2023-09-27 21:20:20.683262 +00:00,9098.00,true,1093
3846,2019-02-17 08:57:43.418393 +00:00,2019-02-17 09:12:38.418393 +00:00,10021.00,true,1094
3847,2021-03-25 02:06:06.611363 +00:00,2021-03-29 11:26:49.611363 +00:00,5691.00,true,1094
3848,2020-12-12 01:05:14.577025 +00:00,2020-12-15 03:47:07.577025 +00:00,8151.00,true,1094
3849,2021-06-27 19:06:48.217499 +00:00,2021-07-04 12:01:33.217499 +00:00,10511.00,true,1094
3850,2023-08-12 07:12:17.971805 +00:00,2023-08-13 23:49:18.971805 +00:00,1836.00,true,1094
3851,2025-07-23 03:55:41.828060 +00:00,2025-07-23 04:05:27.828060 +00:00,7595.00,true,1095
3852,2025-09-20 04:35:04.660048 +00:00,2025-10-01 03:05:55.660048 +00:00,6618.00,true,1095
3853,2025-08-07 00:41:17.305493 +00:00,2025-08-10 11:12:32.305493 +00:00,28795.00,true,1095
3854,2025-09-06 12:46:15.664696 +00:00,2025-09-13 15:17:40.664696 +00:00,5023.00,true,1095
3855,2025-09-05 02:27:23.898002 +00:00,2025-09-14 08:30:55.898002 +00:00,14248.00,true,1095
3856,2025-07-30 17:03:31.004786 +00:00,2025-08-08 02:34:18.004786 +00:00,2830.00,true,1095
3857,2016-11-06 01:22:39.879697 +00:00,2016-11-06 01:38:51.879697 +00:00,3219.00,true,1096
3858,2013-06-16 21:59:35.339891 +00:00,2013-06-16 22:05:05.339891 +00:00,9431.00,true,1097
3859,2015-10-10 09:49:36.111241 +00:00,2015-10-15 04:16:38.111241 +00:00,9840.00,true,1097
3860,2016-09-02 09:22:16.874345 +00:00,2016-09-07 17:31:59.874345 +00:00,12175.00,true,1097
3861,2025-05-30 00:32:56.319279 +00:00,2025-05-30 00:40:51.319279 +00:00,23.00,true,1098
3862,2025-06-30 07:57:35.237737 +00:00,2025-06-30 17:37:30.237737 +00:00,88.00,true,1098
3863,2025-09-27 18:10:34.067618 +00:00,2025-10-05 16:30:08.067618 +00:00,42.00,true,1098
3864,2025-09-14 05:21:26.382025 +00:00,2025-09-18 12:04:06.382025 +00:00,180.00,true,1098
3865,2025-06-27 00:05:10.392338 +00:00,2025-07-04 02:07:23.392338 +00:00,152.00,true,1098
3866,2025-09-06 03:33:18.531570 +00:00,2025-09-11 20:08:37.531570 +00:00,196.00,true,1098
3867,2025-07-15 20:52:08.313677 +00:00,2025-07-15 21:08:00.313677 +00:00,11649.00,true,1099
3868,2025-09-22 11:22:32.777923 +00:00,2025-10-01 23:53:57.777923 +00:00,13222.00,true,1099
3869,2025-09-13 01:52:31.482338 +00:00,2025-09-22 01:53:40.482338 +00:00,7975.00,true,1099
3870,2025-09-21 14:58:39.069832 +00:00,2025-10-03 02:39:44.069832 +00:00,3287.00,true,1099
3871,2010-08-17 04:14:18.194860 +00:00,2010-08-17 04:14:23.194860 +00:00,16525.00,true,1100
3872,2016-10-05 03:34:20.389371 +00:00,2016-10-10 03:25:45.389371 +00:00,6584.00,true,1100
3873,2022-03-01 05:04:39.471982 +00:00,2022-03-02 22:04:10.471982 +00:00,5534.00,true,1100
3874,2012-06-25 17:34:25.878399 +00:00,2012-06-25 17:38:41.878399 +00:00,5230.00,true,1101
3875,2014-10-17 16:41:35.859933 +00:00,2014-10-23 08:02:21.859933 +00:00,864.00,true,1101
3876,2016-09-15 18:10:11.147244 +00:00,2016-09-15 23:07:09.147244 +00:00,9743.00,true,1101
3877,2019-02-12 14:41:01.560898 +00:00,2019-02-12 23:32:29.560898 +00:00,14380.00,true,1101
3878,2023-12-31 18:31:58.138497 +00:00,2024-01-03 18:37:31.138497 +00:00,6275.00,true,1101
3879,2013-03-21 02:47:43.193313 +00:00,2013-03-28 06:05:56.193313 +00:00,1616.00,true,1101
3880,2015-07-20 17:36:38.315330 +00:00,2015-07-20 17:51:06.315330 +00:00,3439.00,true,1102
3881,2021-06-27 02:48:39.061020 +00:00,2021-07-06 12:11:39.061020 +00:00,10551.00,true,1102
3882,2025-02-12 10:31:45.904426 +00:00,2025-02-16 00:07:40.904426 +00:00,424.00,true,1102
3883,2019-10-17 01:09:24.954548 +00:00,2019-10-22 02:45:29.954548 +00:00,1720.00,true,1102
3884,2022-09-14 22:49:52.911498 +00:00,2022-09-16 13:15:01.911498 +00:00,5774.00,true,1102
3885,2025-02-07 23:00:38.032382 +00:00,2025-02-07 23:03:55.032382 +00:00,38967.00,true,1103
3886,2025-09-19 06:50:52.998353 +00:00,2025-09-19 07:03:51.998353 +00:00,99341.00,true,1104
3887,2014-08-25 10:20:20.062860 +00:00,2014-08-25 10:24:26.062860 +00:00,2485.00,true,1105
3888,2016-07-01 22:17:59.768064 +00:00,2016-07-06 23:33:25.768064 +00:00,1322.00,true,1105
3889,2023-04-23 20:58:13.326197 +00:00,2023-04-30 15:12:31.326197 +00:00,11185.00,true,1105
3890,2020-08-04 14:41:00.010870 +00:00,2020-08-07 04:45:06.010870 +00:00,7463.00,true,1105
3891,2017-05-11 23:53:59.162679 +00:00,2017-05-15 16:46:31.162679 +00:00,28028.00,true,1105
3892,2023-04-30 12:12:09.036554 +00:00,2023-05-07 09:41:58.036554 +00:00,20703.00,true,1105
3893,2012-11-27 11:44:03.643048 +00:00,2012-11-27 11:51:18.643048 +00:00,225.00,true,1106
3894,2014-03-28 13:40:13.773918 +00:00,2014-04-02 02:01:16.773918 +00:00,683.00,true,1106
3895,2020-11-09 00:09:54.202408 +00:00,2020-11-15 01:18:26.202408 +00:00,531.00,true,1106
3896,2013-12-09 01:11:31.608467 +00:00,2013-12-11 02:09:30.608467 +00:00,207.00,true,1106
3897,2022-05-08 22:05:13.388914 +00:00,2022-05-20 05:41:09.388914 +00:00,247.00,true,1106
3898,2025-07-22 23:49:39.322554 +00:00,2025-07-22 23:50:03.322554 +00:00,15543.00,true,1107
3899,2025-09-03 17:03:56.946628 +00:00,2025-09-09 17:35:17.946628 +00:00,8513.00,true,1107
3900,2025-08-11 01:27:42.148323 +00:00,2025-08-16 05:48:34.148323 +00:00,2977.00,true,1107
3901,2025-07-10 23:06:36.711462 +00:00,2025-07-10 23:19:00.711462 +00:00,2339.00,true,1108
3902,2025-08-10 10:12:02.632003 +00:00,2025-08-20 20:13:18.632003 +00:00,7324.00,true,1108
3903,2025-08-05 19:52:06.426431 +00:00,2025-08-11 11:32:37.426431 +00:00,4833.00,true,1108
3904,2016-08-04 09:56:45.511170 +00:00,2016-08-04 10:00:04.511170 +00:00,8256.00,true,1109
3905,2022-08-28 10:06:43.657761 +00:00,2022-09-08 15:46:15.657761 +00:00,18023.00,true,1109
3906,2024-07-21 01:01:14.349506 +00:00,2024-07-25 16:09:06.349506 +00:00,12152.00,true,1109
3907,2022-08-01 11:22:34.860574 +00:00,2022-08-01 21:25:44.860574 +00:00,4966.00,true,1109
3908,2025-04-26 04:27:00.193319 +00:00,2025-05-02 06:13:36.193319 +00:00,319.00,true,1109
3909,2025-10-01 14:10:01.647835 +00:00,2025-10-01 14:25:30.647835 +00:00,14320.00,true,1110
3910,2025-10-04 09:58:09.513903 +00:00,2025-10-05 01:14:27.513903 +00:00,16686.00,true,1110
3911,2010-01-24 19:30:57.402153 +00:00,2010-01-24 19:31:10.402153 +00:00,18804.00,true,1111
3912,2011-06-28 06:28:15.152318 +00:00,2011-07-05 09:31:35.152318 +00:00,4429.00,true,1111
3913,2014-06-20 09:50:46.884434 +00:00,2014-06-26 01:31:16.884434 +00:00,9582.00,true,1111
3914,2025-07-23 01:09:33.803425 +00:00,2025-07-23 01:23:55.803425 +00:00,40055.00,true,1112
3915,2010-10-01 14:20:30.322364 +00:00,2010-10-01 14:20:58.322364 +00:00,34010.00,true,1113
3916,2025-09-13 06:22:25.225570 +00:00,2025-09-13 06:27:26.225570 +00:00,1204.00,true,1114
3917,2025-10-03 13:15:08.956532 +00:00,,1258.00,false,1114
3918,2025-09-15 09:56:36.731751 +00:00,2025-09-23 23:02:47.731751 +00:00,896.00,true,1114
3919,2025-09-22 13:57:53.117746 +00:00,2025-10-01 13:55:57.117746 +00:00,222.00,true,1114
3920,2015-03-21 12:59:58.724082 +00:00,2015-03-21 13:09:09.724082 +00:00,3611.00,true,1115
3921,2023-11-13 00:04:40.200550 +00:00,2023-11-18 12:43:32.200550 +00:00,1604.00,true,1115
3922,2018-01-23 20:17:32.123822 +00:00,2018-02-02 06:04:50.123822 +00:00,2530.00,true,1115
3923,2025-02-23 18:07:06.887149 +00:00,2025-02-28 20:00:00.887149 +00:00,2550.00,true,1115
3924,2019-11-10 21:02:08.212904 +00:00,2019-11-10 21:15:43.212904 +00:00,10281.00,true,1116
3925,2025-09-05 07:43:42.046743 +00:00,2025-09-16 17:00:19.046743 +00:00,721.00,true,1116
3926,2022-11-16 08:49:21.806883 +00:00,2022-11-20 21:14:50.806883 +00:00,4670.00,true,1116
3927,2024-12-09 06:04:30.728234 +00:00,2024-12-15 12:00:37.728234 +00:00,19747.00,true,1116
3928,2020-05-15 06:47:53.003504 +00:00,2020-05-21 19:45:29.003504 +00:00,1348.00,true,1116
3929,2025-09-02 09:31:10.664288 +00:00,2025-09-02 09:45:48.664288 +00:00,4573.00,true,1117
3930,2025-09-27 06:46:28.525596 +00:00,2025-10-05 19:59:11.525596 +00:00,18207.00,true,1117
3931,2025-09-04 12:15:12.182337 +00:00,2025-09-08 20:10:30.182337 +00:00,1619.00,true,1117
3932,2025-09-27 02:11:44.647474 +00:00,2025-10-03 15:19:47.647474 +00:00,12480.00,true,1117
3933,2025-09-28 14:44:49.371243 +00:00,2025-09-28 21:57:16.371243 +00:00,11817.00,true,1117
3934,2025-07-06 13:22:55.047814 +00:00,2025-07-06 13:31:18.047814 +00:00,4779.00,true,1118
3935,2025-08-16 03:05:03.482445 +00:00,2025-08-17 07:22:01.482445 +00:00,9881.00,true,1118
3936,2025-08-24 03:43:42.356119 +00:00,2025-09-01 18:26:05.356119 +00:00,1072.00,true,1118
3937,2025-07-20 06:04:34.472781 +00:00,2025-07-21 16:28:36.472781 +00:00,5512.00,true,1118
3938,2025-07-20 18:48:55.709535 +00:00,2025-07-31 13:38:11.709535 +00:00,6159.00,true,1118
3939,2020-08-25 04:33:17.795389 +00:00,2020-08-25 04:48:41.795389 +00:00,57771.00,true,1119
3940,2025-02-09 07:55:39.153446 +00:00,2025-02-14 07:01:26.153446 +00:00,3722.00,true,1119
3941,2022-01-18 23:27:29.387757 +00:00,2022-01-26 19:37:51.387757 +00:00,1788.00,true,1119
3942,2023-11-01 23:17:34.333626 +00:00,2023-11-08 11:14:13.333626 +00:00,9896.00,true,1119
3943,2024-11-27 03:15:09.583081 +00:00,2024-12-04 13:51:53.583081 +00:00,1626.00,true,1119
3944,2011-03-09 06:36:30.804376 +00:00,2011-03-09 06:51:02.804376 +00:00,9441.00,true,1120
3945,2014-12-11 18:00:29.819640 +00:00,2014-12-18 03:18:13.819640 +00:00,25266.00,true,1120
3946,2025-07-13 10:30:10.744220 +00:00,2025-07-13 10:35:34.744220 +00:00,730.00,true,1121
3947,2025-08-31 01:27:40.895895 +00:00,2025-09-08 13:29:44.895895 +00:00,19279.00,true,1121
3948,2017-11-06 00:05:39.349270 +00:00,2017-11-06 00:22:09.349270 +00:00,644.00,true,1122
3949,2018-03-17 12:47:48.221070 +00:00,2018-03-23 11:08:18.221070 +00:00,6221.00,true,1122
3950,2023-02-18 03:15:45.279718 +00:00,2023-02-26 11:52:47.279718 +00:00,494.00,true,1122
3951,2019-10-31 01:32:41.233338 +00:00,2019-11-01 01:32:38.233338 +00:00,423.00,true,1122
3952,2021-07-08 06:59:02.157572 +00:00,2021-07-08 07:13:33.157572 +00:00,4325.00,true,1123
3953,2025-07-01 07:15:50.626154 +00:00,2025-07-01 07:17:15.626154 +00:00,19409.00,true,1124
3954,2018-03-02 06:22:40.254657 +00:00,2018-03-02 06:36:53.254657 +00:00,14788.00,true,1125
3955,2020-05-05 11:42:21.774172 +00:00,2020-05-05 11:55:19.774172 +00:00,742.00,true,1126
3956,2025-06-07 19:00:43.291289 +00:00,2025-06-09 13:06:09.291289 +00:00,517.00,true,1126
3957,2021-05-12 19:25:07.355568 +00:00,2021-05-14 18:05:16.355568 +00:00,4759.00,true,1126
3958,2021-05-17 22:57:21.918932 +00:00,2021-05-23 17:55:23.918932 +00:00,1226.00,true,1126
3959,2021-10-31 12:05:45.034212 +00:00,2021-11-07 08:34:31.034212 +00:00,2103.00,true,1126
3960,2020-05-22 02:48:47.261272 +00:00,2020-05-22 03:19:43.261272 +00:00,4392.00,true,1126
3961,2014-06-30 04:35:36.121176 +00:00,2014-06-30 04:47:23.121176 +00:00,16559.00,true,1127
3962,2020-03-05 22:48:16.733946 +00:00,,1214.00,false,1127
3963,2017-07-27 17:50:50.614017 +00:00,2017-07-29 07:45:08.614017 +00:00,1857.00,true,1127
3964,2019-01-26 01:35:11.789650 +00:00,2019-02-03 17:47:13.789650 +00:00,1403.00,true,1127
3965,2018-12-13 18:41:46.169308 +00:00,2018-12-21 10:06:51.169308 +00:00,8896.00,true,1127
3966,2018-02-19 00:07:35.163487 +00:00,2018-02-19 00:14:18.163487 +00:00,3174.00,true,1128
3967,2023-05-17 07:55:16.104604 +00:00,2023-05-27 15:14:56.104604 +00:00,5403.00,true,1128
3968,2020-01-26 04:17:59.348794 +00:00,2020-02-03 20:55:27.348794 +00:00,12380.00,true,1128
3969,2025-08-27 01:58:45.890559 +00:00,2025-08-29 14:44:44.890559 +00:00,21387.00,true,1128
3970,2025-06-29 22:50:42.757245 +00:00,,431.00,false,1128
3971,2022-04-09 07:36:55.130850 +00:00,2022-04-09 07:51:52.130850 +00:00,53453.00,true,1129
3972,2016-12-16 11:59:06.589718 +00:00,2016-12-16 12:09:48.589718 +00:00,1757.00,true,1130
3973,2025-05-18 02:28:24.387330 +00:00,2025-05-24 03:23:39.387330 +00:00,3756.00,true,1130
3974,2017-08-04 08:03:55.715215 +00:00,2017-08-06 12:08:34.715215 +00:00,5156.00,true,1130
3975,2023-05-21 06:25:55.703236 +00:00,2023-05-27 11:43:35.703236 +00:00,6214.00,true,1130
3976,2020-09-02 06:48:51.096048 +00:00,2020-09-12 23:22:42.096048 +00:00,326.00,true,1130
3977,2025-09-06 15:33:55.300212 +00:00,2025-09-06 15:42:51.300212 +00:00,18578.00,true,1131
3978,2025-08-13 12:41:25.541629 +00:00,2025-08-13 12:44:58.541629 +00:00,10465.00,true,1132
3979,2025-09-29 22:13:17.733818 +00:00,2025-10-02 10:09:10.733818 +00:00,2505.00,true,1132
3980,2025-08-31 03:32:31.202435 +00:00,2025-09-03 07:38:33.202435 +00:00,3503.00,true,1132
3981,2025-09-03 05:31:42.013114 +00:00,2025-09-07 11:43:40.013114 +00:00,6452.00,true,1132
3982,2024-06-26 20:28:41.813281 +00:00,2024-06-26 20:44:08.813281 +00:00,24053.00,true,1133
3983,2012-09-01 02:38:03.875593 +00:00,2012-09-01 02:54:00.875593 +00:00,3975.00,true,1134
3984,2013-11-30 17:14:38.111637 +00:00,2013-12-03 02:11:00.111637 +00:00,2237.00,true,1134
3985,2014-01-17 03:56:27.627438 +00:00,2014-01-27 06:28:32.627438 +00:00,3025.00,true,1134
3986,2018-01-06 07:31:02.067588 +00:00,2018-01-06 07:33:35.067588 +00:00,244.00,true,1135
3987,2025-05-06 05:49:00.353166 +00:00,,247.00,false,1135
3988,2020-01-07 18:33:02.216360 +00:00,2020-01-15 05:32:47.216360 +00:00,2089.00,true,1135
3989,2020-02-18 17:36:30.010354 +00:00,2020-02-23 09:27:59.010354 +00:00,988.00,true,1135
3990,2020-06-02 07:08:07.422590 +00:00,2020-06-12 00:13:44.422590 +00:00,2605.00,true,1135
3991,2017-08-23 18:15:55.172785 +00:00,2017-08-23 18:23:01.172785 +00:00,53036.00,true,1136
3992,2017-04-21 01:36:47.395120 +00:00,2017-04-21 01:39:45.395120 +00:00,26063.00,true,1137
3993,2020-03-04 22:37:10.839207 +00:00,2020-03-12 17:16:19.839207 +00:00,4891.00,true,1137
3994,2019-03-25 01:44:13.458354 +00:00,2019-03-29 05:16:32.458354 +00:00,32852.00,true,1137
3995,2021-04-23 10:52:47.648749 +00:00,2021-05-04 18:12:52.648749 +00:00,9258.00,true,1137
3996,2018-04-22 18:20:49.315399 +00:00,2018-04-23 16:17:58.315399 +00:00,8754.00,true,1137
3997,2011-05-01 20:10:10.067113 +00:00,2011-05-01 20:13:04.067113 +00:00,3561.00,true,1138
3998,2022-04-02 12:00:15.310323 +00:00,2022-04-10 19:05:04.310323 +00:00,504.00,true,1138
3999,2024-11-04 02:00:30.844792 +00:00,2024-11-08 20:27:12.844792 +00:00,3075.00,true,1138
4000,2019-05-13 08:58:39.800113 +00:00,2019-05-22 01:24:47.800113 +00:00,4021.00,true,1138
4001,2021-12-25 23:48:22.315482 +00:00,2021-12-29 19:52:50.315482 +00:00,35487.00,true,1138
4002,2025-09-13 15:12:52.783122 +00:00,2025-09-13 15:14:50.783122 +00:00,46149.00,true,1139
4003,2025-10-03 17:35:16.101967 +00:00,2025-10-03 17:43:40.101967 +00:00,1837.00,true,1140
4004,2025-10-04 21:26:27.164384 +00:00,,17998.00,false,1140
4005,2025-10-04 08:15:59.703313 +00:00,,20823.00,false,1140
4006,2025-10-04 03:10:52.898464 +00:00,,14659.00,false,1140
4007,2014-09-28 05:07:41.269022 +00:00,2014-09-28 05:18:02.269022 +00:00,11103.00,true,1141
4008,2016-06-06 02:07:40.842642 +00:00,2016-06-15 11:27:07.842642 +00:00,34239.00,true,1141
4009,2022-09-16 07:48:26.870521 +00:00,2022-09-23 13:22:22.870521 +00:00,2047.00,true,1141
4010,2020-12-17 12:28:41.314614 +00:00,2020-12-24 05:36:56.314614 +00:00,8003.00,true,1141
4011,2010-11-27 15:28:26.109051 +00:00,2010-11-27 15:41:28.109051 +00:00,309.00,true,1142
4012,2024-10-11 20:55:13.583543 +00:00,2024-10-16 16:54:09.583543 +00:00,2409.00,true,1142
4013,2024-11-17 21:48:28.141901 +00:00,2024-11-21 06:18:10.141901 +00:00,84.00,true,1142
4014,2018-02-27 07:41:33.451307 +00:00,2018-03-05 20:34:33.451307 +00:00,594.00,true,1142
4015,2013-08-05 20:13:02.587857 +00:00,2013-08-16 19:49:26.587857 +00:00,349.00,true,1142
4016,2024-06-06 15:30:43.405845 +00:00,2024-06-06 15:41:01.405845 +00:00,7559.00,true,1143
4017,2024-05-17 23:39:55.230544 +00:00,2024-05-17 23:47:31.230544 +00:00,784.00,true,1144
4018,2025-05-31 09:34:31.907347 +00:00,2025-06-11 08:31:41.907347 +00:00,666.00,true,1144
4019,2025-03-31 18:21:40.801159 +00:00,2025-04-12 04:15:40.801159 +00:00,4080.00,true,1144
4020,2024-12-22 20:05:39.225149 +00:00,2025-01-02 04:02:22.225149 +00:00,4504.00,true,1144
4021,2024-09-16 08:11:22.352882 +00:00,2024-09-25 02:40:15.352882 +00:00,26093.00,true,1144
4022,2025-07-24 18:01:13.610183 +00:00,2025-07-29 11:11:06.610183 +00:00,8813.00,true,1144
4023,2025-09-21 00:06:17.943172 +00:00,2025-09-21 00:18:56.943172 +00:00,21040.00,true,1145
4024,2011-05-03 05:04:36.035519 +00:00,2011-05-03 05:14:04.035519 +00:00,36492.00,true,1146
4025,2020-11-15 11:39:02.427090 +00:00,2020-11-26 07:23:44.427090 +00:00,3902.00,true,1146
4026,2018-03-03 04:38:21.956369 +00:00,2018-03-07 16:17:52.956369 +00:00,1023.00,true,1146
4027,2024-12-26 19:00:21.262978 +00:00,2024-12-26 19:14:13.262978 +00:00,45378.00,true,1147
4028,2014-06-13 08:29:21.838428 +00:00,2014-06-13 08:43:58.838428 +00:00,11759.00,true,1148
4029,2021-01-27 10:58:29.824823 +00:00,2021-02-06 01:49:50.824823 +00:00,21051.00,true,1148
4030,2019-11-19 00:56:28.196774 +00:00,2019-11-21 12:18:37.196774 +00:00,1967.00,true,1148
4031,2021-04-28 07:22:30.243459 +00:00,2021-05-03 21:21:02.243459 +00:00,5370.00,true,1148
4032,2010-09-08 12:01:31.900027 +00:00,2010-09-08 12:03:07.900027 +00:00,10223.00,true,1149
4033,2020-11-01 18:11:42.558237 +00:00,2020-11-05 08:24:31.558237 +00:00,19055.00,true,1149
4034,2022-07-30 13:44:11.026465 +00:00,2022-08-05 03:45:02.026465 +00:00,13545.00,true,1149
4035,2021-06-18 22:29:07.052046 +00:00,2021-06-24 03:33:16.052046 +00:00,5097.00,true,1149
4036,2011-08-31 01:26:38.668679 +00:00,2011-08-31 01:37:13.668679 +00:00,20849.00,true,1150
4037,2018-03-01 03:46:49.631725 +00:00,,1354.00,false,1150
4038,2020-11-07 15:33:22.042605 +00:00,2020-11-10 07:38:05.042605 +00:00,1527.00,true,1150
4039,2025-09-26 23:45:02.487949 +00:00,2025-09-26 23:51:01.487949 +00:00,27632.00,true,1151
4040,2020-07-29 13:46:56.057346 +00:00,2020-07-29 13:54:02.057346 +00:00,8824.00,true,1152
4041,2020-09-27 19:07:55.954083 +00:00,2020-10-02 11:58:58.954083 +00:00,28014.00,true,1152
4042,2025-08-26 07:04:59.519579 +00:00,2025-08-26 07:06:05.519579 +00:00,10007.00,true,1153
4043,2025-09-14 08:29:16.628616 +00:00,2025-09-16 21:50:25.628616 +00:00,849.00,true,1153
4044,2025-09-12 19:37:47.571525 +00:00,,19479.00,false,1153
4045,2025-09-01 00:03:18.200949 +00:00,2025-09-05 19:12:52.200949 +00:00,324.00,true,1153
4046,2025-09-03 04:14:47.718920 +00:00,2025-09-08 19:56:53.718920 +00:00,1218.00,true,1153
4047,2012-08-15 21:43:17.901811 +00:00,2012-08-15 21:58:51.901811 +00:00,9583.00,true,1154
4048,2020-04-03 02:19:15.112381 +00:00,2020-04-13 06:18:20.112381 +00:00,849.00,true,1154
4049,2025-01-05 16:13:02.343756 +00:00,2025-01-13 14:01:31.343756 +00:00,13084.00,true,1154
4050,2015-02-17 07:45:42.964945 +00:00,2015-02-23 11:42:15.964945 +00:00,20542.00,true,1154
4051,2013-08-25 07:24:38.950290 +00:00,2013-08-30 14:01:08.950290 +00:00,7892.00,true,1154
4052,2022-03-31 12:51:42.189403 +00:00,2022-03-31 12:58:34.189403 +00:00,75819.00,true,1155
4053,2012-02-04 22:33:54.999051 +00:00,2012-02-04 22:35:04.999051 +00:00,9181.00,true,1156
4054,2021-01-25 16:37:31.839083 +00:00,2021-02-04 03:33:41.839083 +00:00,1088.00,true,1156
4055,2018-11-29 01:36:23.263850 +00:00,2018-12-06 07:11:42.263850 +00:00,1482.00,true,1156
4056,2016-03-27 06:55:35.149526 +00:00,2016-04-05 22:44:12.149526 +00:00,5447.00,true,1156
4057,2012-05-27 07:20:32.239279 +00:00,2012-05-28 00:54:20.239279 +00:00,210.00,true,1156
4058,2019-12-24 00:04:36.881554 +00:00,2019-12-24 00:06:10.881554 +00:00,1206.00,true,1157
4059,2018-08-12 19:16:57.972611 +00:00,2018-08-12 19:19:30.972611 +00:00,7502.00,true,1158
4060,2013-05-03 05:43:44.810905 +00:00,2013-05-03 05:51:45.810905 +00:00,2066.00,true,1159
4061,2022-09-24 21:29:21.081410 +00:00,2022-09-27 16:11:49.081410 +00:00,4224.00,true,1159
4062,2024-01-13 15:19:26.770789 +00:00,2024-01-20 03:40:34.770789 +00:00,2715.00,true,1159
4063,2020-12-17 18:56:28.914311 +00:00,2020-12-27 03:57:19.914311 +00:00,3066.00,true,1159
4064,2016-10-31 16:08:15.727782 +00:00,2016-11-03 22:07:41.727782 +00:00,1789.00,true,1159
4065,2023-12-16 06:20:40.141285 +00:00,2023-12-18 03:37:42.141285 +00:00,1080.00,true,1159
4066,2025-09-23 16:42:54.563039 +00:00,2025-09-23 16:44:57.563039 +00:00,1686.00,true,1160
4067,2025-09-26 20:41:55.224375 +00:00,2025-09-27 21:55:08.224375 +00:00,144.00,true,1160
4068,2025-09-29 23:47:35.896936 +00:00,2025-10-03 16:14:34.896936 +00:00,399.00,true,1160
4069,2025-10-03 22:30:29.141974 +00:00,,4277.00,false,1160
4070,2025-09-25 00:51:12.641892 +00:00,2025-09-29 05:22:59.641892 +00:00,3162.00,true,1160
4071,2025-10-02 23:15:41.765334 +00:00,2025-10-04 22:03:35.765334 +00:00,42205.00,true,1160
4072,2017-12-29 03:57:03.482121 +00:00,2017-12-29 04:02:54.482121 +00:00,6250.00,true,1161
4073,2021-11-27 05:44:28.662752 +00:00,2021-11-30 01:32:37.662752 +00:00,38720.00,true,1161
4074,2013-02-14 12:05:14.825556 +00:00,2013-02-14 12:09:49.825556 +00:00,1956.00,true,1162
4075,2020-06-26 20:29:02.038692 +00:00,2020-07-01 13:32:33.038692 +00:00,285.00,true,1162
4076,2021-02-19 21:19:16.649714 +00:00,2021-02-25 08:42:43.649714 +00:00,63.00,true,1162
4077,2021-02-03 12:41:22.031497 +00:00,2021-02-03 12:47:22.031497 +00:00,2372.00,true,1163
4078,2021-09-27 01:09:13.147100 +00:00,2021-10-02 08:15:17.147100 +00:00,18646.00,true,1163
4079,2025-04-16 20:20:23.882864 +00:00,2025-04-17 23:39:06.882864 +00:00,1177.00,true,1163
4080,2019-08-26 03:42:47.797288 +00:00,2019-08-26 03:48:26.797288 +00:00,15872.00,true,1164
4081,2025-08-10 01:37:05.743720 +00:00,2025-08-10 01:45:23.743720 +00:00,41480.00,true,1165
4082,2025-10-04 15:56:03.299159 +00:00,2025-10-04 16:00:59.299159 +00:00,7582.00,true,1166
4083,2025-10-04 16:25:33.049053 +00:00,,848.00,false,1166
4084,2025-10-04 23:08:28.818216 +00:00,,8693.00,false,1166
4085,2025-10-04 16:13:45.190591 +00:00,,2260.00,false,1166
4086,2025-10-04 16:09:26.902305 +00:00,,3954.00,false,1166
4087,2017-01-25 12:33:20.146988 +00:00,2017-01-25 12:46:35.146988 +00:00,17511.00,true,1167
4088,2017-10-11 18:35:54.398418 +00:00,2017-10-23 06:34:02.398418 +00:00,38563.00,true,1167
4089,2020-12-24 13:57:06.811412 +00:00,2021-01-01 03:06:53.811412 +00:00,3502.00,true,1167
4090,2025-05-09 01:37:24.382456 +00:00,2025-05-18 05:00:24.382456 +00:00,8688.00,true,1167
4091,2023-11-17 13:13:34.209205 +00:00,2023-11-17 13:20:17.209205 +00:00,13572.00,true,1168
4092,2025-01-24 12:21:12.168914 +00:00,2025-02-01 04:06:06.168914 +00:00,3109.00,true,1168
4093,2024-12-19 01:50:15.603660 +00:00,2024-12-27 00:13:51.603660 +00:00,11919.00,true,1168
4094,2018-06-30 10:15:26.512055 +00:00,2018-06-30 10:27:50.512055 +00:00,28319.00,true,1169
4095,2011-01-20 05:29:46.221178 +00:00,2011-01-20 05:30:50.221178 +00:00,15771.00,true,1170
4096,2017-11-11 04:49:50.750840 +00:00,,43359.00,false,1170
4097,2025-04-07 05:02:24.248337 +00:00,2025-04-14 19:05:58.248337 +00:00,18620.00,true,1170
4098,2016-05-12 23:29:16.347589 +00:00,,768.00,false,1170
4099,2019-05-17 13:34:41.386046 +00:00,2019-05-17 13:49:30.386046 +00:00,401.00,true,1171
4100,2024-07-01 09:57:09.698280 +00:00,2024-07-04 14:58:43.698280 +00:00,1583.00,true,1171
4101,2022-03-23 07:40:54.591238 +00:00,2022-03-26 18:24:56.591238 +00:00,249.00,true,1171
4102,2024-04-21 19:36:20.438791 +00:00,2024-04-26 12:52:08.438791 +00:00,1185.00,true,1171
4103,2025-02-20 10:01:56.370270 +00:00,2025-02-24 01:30:54.370270 +00:00,914.00,true,1171
4104,2024-11-03 05:43:44.062131 +00:00,2024-11-05 13:44:05.062131 +00:00,483.00,true,1171
4105,2019-07-28 06:33:07.005759 +00:00,2019-07-28 06:48:05.005759 +00:00,2826.00,true,1172
4106,2023-02-10 18:12:27.444805 +00:00,2023-02-15 22:41:45.444805 +00:00,19189.00,true,1172
4107,2021-01-15 17:34:55.267198 +00:00,2021-01-19 04:49:00.267198 +00:00,3851.00,true,1172
4108,2021-07-10 17:16:09.567983 +00:00,2021-07-16 10:52:10.567983 +00:00,1453.00,true,1172
4109,2024-03-28 09:51:29.037320 +00:00,2024-03-31 17:05:28.037320 +00:00,1580.00,true,1172
4110,2021-07-29 12:52:06.485737 +00:00,2021-08-01 06:51:03.485737 +00:00,24520.00,true,1172
4111,2024-08-20 10:31:48.196366 +00:00,2024-08-20 10:32:23.196366 +00:00,3311.00,true,1173
4112,2025-07-13 07:32:34.014837 +00:00,2025-07-19 03:07:01.014837 +00:00,9402.00,true,1173
4113,2024-10-06 10:44:59.749346 +00:00,2024-10-08 04:57:19.749346 +00:00,12366.00,true,1173
4114,2024-12-21 05:40:15.617354 +00:00,2024-12-24 07:13:08.617354 +00:00,9132.00,true,1173
4115,2014-07-02 18:28:30.401574 +00:00,2014-07-02 18:43:06.401574 +00:00,16708.00,true,1174
4116,2016-07-04 07:46:35.171005 +00:00,2016-07-09 05:31:33.171005 +00:00,19179.00,true,1174
4117,2011-08-06 06:45:33.562814 +00:00,2011-08-06 06:48:37.562814 +00:00,9230.00,true,1175
4118,2021-01-25 01:33:53.204304 +00:00,2021-01-31 14:16:15.204304 +00:00,2780.00,true,1175
4119,2021-01-17 11:56:57.316116 +00:00,2021-01-27 06:09:48.316116 +00:00,3882.00,true,1175
4120,2015-03-24 03:24:57.629942 +00:00,2015-03-24 13:57:27.629942 +00:00,4517.00,true,1175
4121,2021-01-04 23:01:43.849807 +00:00,2021-01-13 08:43:40.849807 +00:00,20419.00,true,1175
4122,2021-11-10 13:15:27.608480 +00:00,2021-11-15 15:35:04.608480 +00:00,6130.00,true,1175
4123,2022-01-14 00:15:52.552669 +00:00,2022-01-14 00:16:21.552669 +00:00,374.00,true,1176
4124,2023-07-25 09:48:12.973167 +00:00,2023-07-30 14:58:02.973167 +00:00,4421.00,true,1176
4125,2024-04-10 21:13:03.190646 +00:00,2024-04-17 15:16:46.190646 +00:00,6791.00,true,1176
4126,2023-01-29 08:22:24.628260 +00:00,2023-01-29 17:31:27.628260 +00:00,14613.00,true,1176
4127,2022-10-05 02:34:15.130152 +00:00,2022-10-14 15:03:25.130152 +00:00,10295.00,true,1176
4128,2024-03-14 17:31:31.593219 +00:00,2024-03-14 17:32:29.593219 +00:00,5654.00,true,1177
4129,2024-04-08 08:15:20.824336 +00:00,2024-04-14 03:13:10.824336 +00:00,10764.00,true,1177
4130,2025-03-16 14:11:25.757737 +00:00,2025-03-19 09:28:42.757737 +00:00,242.00,true,1177
4131,2025-07-06 04:13:45.550688 +00:00,2025-07-12 00:34:01.550688 +00:00,3741.00,true,1177
4132,2024-05-19 10:33:59.903981 +00:00,,9192.00,false,1177
4133,2017-09-01 15:00:22.585129 +00:00,2017-09-01 15:04:24.585129 +00:00,2113.00,true,1178
4134,2024-11-21 20:33:14.197665 +00:00,2024-11-23 06:16:35.197665 +00:00,1282.00,true,1178
4135,2020-12-07 03:37:45.374662 +00:00,2020-12-17 01:57:30.374662 +00:00,16936.00,true,1178
4136,2020-09-09 01:01:29.828747 +00:00,2020-09-09 09:26:10.828747 +00:00,2718.00,true,1178
4137,2020-10-18 04:26:03.697871 +00:00,2020-10-20 01:07:19.697871 +00:00,1747.00,true,1178
4138,2017-09-10 12:00:56.597173 +00:00,2017-09-17 03:37:14.597173 +00:00,2266.00,true,1178
4139,2025-08-07 15:53:45.619128 +00:00,2025-08-07 16:07:58.619128 +00:00,10642.00,true,1179
4140,2025-09-10 13:00:52.390921 +00:00,2025-09-21 10:32:17.390921 +00:00,14204.00,true,1179
4141,2025-09-25 03:04:53.244099 +00:00,2025-09-28 17:56:27.244099 +00:00,4294.00,true,1179
4142,2025-08-13 00:30:00.827458 +00:00,2025-08-20 16:23:52.827458 +00:00,15949.00,true,1179
4143,2025-09-07 12:21:45.214993 +00:00,2025-09-14 02:22:07.214993 +00:00,15249.00,true,1179
4144,2025-08-26 10:47:25.349180 +00:00,2025-09-04 09:44:06.349180 +00:00,789.00,true,1179
4145,2023-04-19 19:15:33.700680 +00:00,2023-04-19 19:18:52.700680 +00:00,413.00,true,1180
4146,2023-11-09 15:24:23.388564 +00:00,2023-11-17 19:49:25.388564 +00:00,3186.00,true,1180
4147,2024-02-09 09:58:57.392340 +00:00,2024-02-12 16:38:05.392340 +00:00,305.00,true,1180
4148,2025-07-16 23:47:51.873303 +00:00,2025-07-20 13:26:42.873303 +00:00,769.00,true,1180
4149,2025-07-01 13:06:50.153674 +00:00,2025-07-03 20:14:21.153674 +00:00,242.00,true,1180
4150,2024-04-05 02:38:48.784116 +00:00,2024-04-06 12:03:29.784116 +00:00,1168.00,true,1180
4151,2022-07-10 20:45:17.286213 +00:00,2022-07-10 20:55:45.286213 +00:00,6317.00,true,1181
4152,2023-02-28 08:17:17.197986 +00:00,2023-03-05 09:21:09.197986 +00:00,4821.00,true,1181
4153,2024-09-19 11:00:22.188014 +00:00,2024-09-28 04:01:29.188014 +00:00,13764.00,true,1181
4154,2023-01-17 13:21:36.754217 +00:00,2023-01-21 18:20:19.754217 +00:00,28777.00,true,1181
4155,2015-03-10 23:21:29.821122 +00:00,2015-03-10 23:27:24.821122 +00:00,13563.00,true,1182
4156,2017-10-19 12:37:19.678998 +00:00,2017-10-30 04:50:50.678998 +00:00,198.00,true,1182
4157,2016-01-18 15:53:03.658391 +00:00,2016-01-19 16:56:23.658391 +00:00,8950.00,true,1182
4158,2018-11-12 21:49:09.909705 +00:00,2018-11-14 05:52:21.909705 +00:00,8433.00,true,1182
4159,2017-05-04 14:37:03.793691 +00:00,,2677.00,false,1182
4160,2013-04-09 16:08:45.996801 +00:00,2013-04-09 16:09:57.996801 +00:00,1633.00,true,1183
4161,2013-04-13 12:54:50.390411 +00:00,2013-04-22 23:14:56.390411 +00:00,5578.00,true,1183
4162,2015-02-05 23:56:54.183314 +00:00,2015-02-06 17:30:45.183314 +00:00,2302.00,true,1183
4163,2025-02-17 08:11:41.098364 +00:00,2025-02-17 12:05:36.098364 +00:00,4420.00,true,1183
4164,2016-07-09 03:11:19.389934 +00:00,2016-07-12 06:28:27.389934 +00:00,10279.00,true,1183
4165,2012-09-07 07:51:00.153471 +00:00,2012-09-07 08:01:09.153471 +00:00,12982.00,true,1184
4166,2015-07-06 02:28:00.773443 +00:00,2015-07-07 04:18:13.773443 +00:00,7135.00,true,1184
4167,2020-06-29 15:25:28.683877 +00:00,2020-07-08 03:32:38.683877 +00:00,7009.00,true,1184
4168,2014-09-29 03:23:41.535266 +00:00,,11913.00,false,1184
4169,2015-11-20 23:33:16.908999 +00:00,2015-11-22 13:56:34.908999 +00:00,22511.00,true,1184
4170,2023-04-17 04:29:10.216748 +00:00,2023-04-17 04:34:56.216748 +00:00,1797.00,true,1185
4171,2025-01-18 18:23:34.087277 +00:00,2025-01-27 02:44:27.087277 +00:00,1159.00,true,1185
4172,2024-08-13 01:08:05.430970 +00:00,2024-08-13 07:09:01.430970 +00:00,3324.00,true,1185
4173,2023-09-02 01:34:09.996285 +00:00,2023-09-09 07:01:19.996285 +00:00,3837.00,true,1185
4174,2024-09-28 13:55:21.611880 +00:00,2024-10-07 19:37:05.611880 +00:00,2091.00,true,1185
4175,2015-01-15 02:01:40.782639 +00:00,2015-01-15 02:05:43.782639 +00:00,2131.00,true,1186
4176,2021-07-20 20:17:27.199328 +00:00,2021-07-31 23:29:28.199328 +00:00,3798.00,true,1186
4177,2020-08-24 04:20:03.808097 +00:00,2020-08-28 16:17:46.808097 +00:00,1085.00,true,1186
4178,2021-07-26 19:44:51.948776 +00:00,2021-07-30 21:21:41.948776 +00:00,6367.00,true,1186
4179,2017-10-30 17:06:44.049337 +00:00,2017-11-03 10:35:15.049337 +00:00,12826.00,true,1186
4180,2023-08-07 19:27:55.463953 +00:00,2023-08-18 01:10:38.463953 +00:00,5997.00,true,1186
4181,2013-03-30 15:52:00.319067 +00:00,2013-03-30 15:56:04.319067 +00:00,55141.00,true,1187
4182,2025-08-10 01:45:40.911661 +00:00,2025-08-10 01:57:16.911661 +00:00,10477.00,true,1188
4183,2025-09-18 21:33:22.732716 +00:00,2025-09-26 03:13:22.732716 +00:00,22628.00,true,1188
4184,2025-09-26 09:06:49.802168 +00:00,2025-09-26 09:20:25.802168 +00:00,18193.00,true,1189
4185,2025-09-30 08:11:37.681171 +00:00,,39217.00,false,1189
4186,2025-10-04 23:06:51.802042 +00:00,,12011.00,false,1189
4187,2025-10-03 01:06:00.334376 +00:00,,12.00,false,1189
4188,2022-05-23 02:43:15.893842 +00:00,2022-05-23 02:46:59.893842 +00:00,31672.00,true,1190
4189,2025-08-12 04:38:29.302965 +00:00,2025-08-23 16:17:15.302965 +00:00,10678.00,true,1190
4190,2024-08-07 20:36:42.545682 +00:00,2024-08-07 20:42:20.545682 +00:00,26225.00,true,1191
4191,2025-08-24 09:33:20.752702 +00:00,2025-08-24 09:39:50.752702 +00:00,3345.00,true,1192
4192,2025-07-14 03:43:28.326311 +00:00,2025-07-14 03:46:31.326311 +00:00,166.00,true,1193
4193,2025-09-18 08:35:26.751169 +00:00,2025-09-29 20:14:10.751169 +00:00,160.00,true,1193
4194,2025-08-17 06:29:49.213682 +00:00,2025-08-21 02:58:14.213682 +00:00,135.00,true,1193
4195,2025-09-28 01:07:19.866566 +00:00,2025-09-29 18:22:47.866566 +00:00,945.00,true,1193
4196,2018-03-25 13:29:08.192424 +00:00,2018-03-25 13:31:45.192424 +00:00,4467.00,true,1194
4197,2024-12-13 12:46:44.361378 +00:00,2024-12-18 20:36:47.361378 +00:00,5381.00,true,1194
4198,2020-06-20 02:02:45.465070 +00:00,2020-06-30 22:25:45.465070 +00:00,6484.00,true,1194
4199,2020-09-28 01:38:24.976354 +00:00,2020-09-28 15:52:04.976354 +00:00,9866.00,true,1194
4200,2025-09-21 17:09:06.733028 +00:00,2025-10-02 03:20:15.733028 +00:00,13342.00,true,1194
4201,2025-07-07 12:31:19.844337 +00:00,2025-07-07 12:36:11.844337 +00:00,8521.00,true,1195
4202,2025-07-21 11:11:22.592637 +00:00,2025-07-31 23:19:57.592637 +00:00,1480.00,true,1195
4203,2025-09-23 13:12:59.395593 +00:00,2025-10-04 13:44:14.395593 +00:00,1732.00,true,1195
4204,2025-09-17 15:53:04.780094 +00:00,2025-09-25 14:45:45.780094 +00:00,426.00,true,1195
4205,2025-08-04 19:00:27.926049 +00:00,2025-08-04 19:07:26.926049 +00:00,33692.00,true,1196
4206,2025-08-08 04:49:53.260239 +00:00,2025-08-16 01:58:39.260239 +00:00,333.00,true,1196
4207,2025-09-19 03:16:54.454997 +00:00,2025-09-19 21:47:09.454997 +00:00,901.00,true,1196
4208,2025-08-28 02:15:19.115717 +00:00,2025-08-28 03:57:15.115717 +00:00,9884.00,true,1196
4209,2019-11-29 12:55:56.868847 +00:00,2019-11-29 12:59:21.868847 +00:00,6107.00,true,1197
4210,2025-07-04 03:59:08.964875 +00:00,2025-07-05 15:40:31.964875 +00:00,1188.00,true,1197
4211,2020-07-22 14:36:53.833839 +00:00,2020-07-25 02:25:33.833839 +00:00,2315.00,true,1197
4212,2022-01-22 02:40:57.365064 +00:00,2022-02-02 00:47:17.365064 +00:00,179.00,true,1197
4213,2024-10-17 15:25:14.916701 +00:00,2024-10-25 15:48:34.916701 +00:00,5821.00,true,1197
4214,2022-04-19 19:36:24.195689 +00:00,,4553.00,false,1197
4215,2020-03-17 07:35:58.461614 +00:00,2020-03-17 07:43:41.461614 +00:00,22029.00,true,1198
4216,2016-02-29 09:21:05.190649 +00:00,2016-02-29 09:26:28.190649 +00:00,2385.00,true,1199
4217,2020-02-04 00:13:29.822725 +00:00,2020-02-08 23:04:12.822725 +00:00,16810.00,true,1199
4218,2021-04-19 11:41:29.141942 +00:00,2021-04-29 20:27:18.141942 +00:00,1482.00,true,1199
4219,2022-05-27 23:16:31.861744 +00:00,2022-05-27 23:20:29.861744 +00:00,2355.00,true,1200
4220,2023-05-25 12:11:23.715279 +00:00,,1191.00,false,1200
4221,2025-08-31 09:29:29.937749 +00:00,2025-09-02 12:26:56.937749 +00:00,24069.00,true,1200
4222,2016-04-22 01:46:54.652013 +00:00,2016-04-22 01:51:44.652013 +00:00,21233.00,true,1201
4223,2025-06-27 05:47:42.025187 +00:00,2025-07-01 16:44:54.025187 +00:00,7936.00,true,1201
4224,2020-04-05 20:09:21.983585 +00:00,2020-04-16 12:14:05.983585 +00:00,4125.00,true,1201
4225,2021-06-08 21:00:16.333242 +00:00,2021-06-08 21:13:11.333242 +00:00,275.00,true,1202
4226,2022-12-21 03:36:03.410480 +00:00,,582.00,false,1202
4227,2022-05-25 19:40:12.796273 +00:00,,3994.00,false,1202
4228,2023-09-01 04:26:46.071427 +00:00,2023-09-12 15:24:34.071427 +00:00,9001.00,true,1202
4229,2022-08-08 11:18:34.732439 +00:00,2022-08-19 02:05:44.732439 +00:00,5431.00,true,1202
4230,2010-10-26 13:28:57.062418 +00:00,2010-10-26 13:44:30.062418 +00:00,3934.00,true,1203
4231,2021-07-07 07:56:05.987851 +00:00,2021-07-15 10:48:31.987851 +00:00,4452.00,true,1203
4232,2016-06-19 21:30:53.382242 +00:00,2016-06-25 18:58:32.382242 +00:00,17933.00,true,1203
4233,2016-03-28 11:11:01.315935 +00:00,2016-03-28 11:19:05.315935 +00:00,4057.00,true,1204
4234,2021-07-23 15:03:00.048007 +00:00,2021-07-25 19:24:58.048007 +00:00,13408.00,true,1204
4235,2021-07-15 11:33:27.820374 +00:00,,6721.00,false,1204
4236,2015-04-24 23:23:01.146824 +00:00,2015-04-24 23:32:20.146824 +00:00,22503.00,true,1205
4237,2015-04-29 03:47:01.894280 +00:00,2015-05-02 16:13:55.894280 +00:00,7699.00,true,1205
4238,2015-08-26 08:28:41.592045 +00:00,2015-08-29 06:00:38.592045 +00:00,19744.00,true,1205
4239,2019-01-06 20:52:27.845889 +00:00,2019-01-14 03:36:50.845889 +00:00,32717.00,true,1205
4240,2025-02-19 14:04:31.643220 +00:00,2025-02-19 14:10:29.643220 +00:00,2328.00,true,1206
4241,2025-09-01 10:31:21.989200 +00:00,2025-09-04 17:41:30.989200 +00:00,77482.00,true,1206
4242,2018-09-03 08:39:49.378850 +00:00,2018-09-03 08:50:42.378850 +00:00,25899.00,true,1207
4243,2021-11-05 06:51:16.037810 +00:00,2021-11-10 03:51:20.037810 +00:00,2329.00,true,1207
4244,2011-09-15 06:29:33.106435 +00:00,2011-09-15 06:33:53.106435 +00:00,9005.00,true,1208
4245,2013-06-01 08:34:38.927875 +00:00,2013-06-02 06:30:09.927875 +00:00,5057.00,true,1208
4246,2025-03-12 20:52:00.714115 +00:00,2025-03-21 20:50:36.714115 +00:00,3906.00,true,1208
4247,2022-02-22 14:33:39.501028 +00:00,2022-02-25 10:33:32.501028 +00:00,15342.00,true,1208
4248,2015-03-30 15:25:05.633672 +00:00,2015-04-08 07:20:55.633672 +00:00,21165.00,true,1208
4249,2025-09-04 11:18:34.776940 +00:00,2025-09-04 11:29:51.776940 +00:00,124.00,true,1209
4250,2025-09-13 05:13:51.738312 +00:00,2025-09-16 13:00:12.738312 +00:00,16392.00,true,1209
4251,2025-09-12 22:18:10.888400 +00:00,2025-09-21 10:49:20.888400 +00:00,19014.00,true,1209
4252,2025-09-17 23:11:47.948121 +00:00,2025-09-29 05:28:15.948121 +00:00,6646.00,true,1209
4253,2025-10-04 04:05:31.175241 +00:00,,6972.00,false,1209
4254,2025-07-16 07:22:08.468436 +00:00,2025-07-16 07:34:54.468436 +00:00,554.00,true,1210
4255,2025-08-19 01:27:47.266516 +00:00,2025-08-26 14:22:31.266516 +00:00,7280.00,true,1210
4256,2025-09-07 17:54:48.798345 +00:00,2025-09-15 18:55:59.798345 +00:00,4071.00,true,1210
4257,2013-10-05 23:04:33.634764 +00:00,2013-10-05 23:19:25.634764 +00:00,413.00,true,1211
4258,2016-04-24 22:03:43.571711 +00:00,2016-04-29 05:57:00.571711 +00:00,1414.00,true,1211
4259,2024-06-17 03:21:28.282329 +00:00,2024-06-26 13:31:27.282329 +00:00,3076.00,true,1211
4260,2025-02-22 11:39:19.622602 +00:00,,3342.00,false,1211
4261,2025-05-16 04:31:24.058953 +00:00,2025-05-16 04:42:28.058953 +00:00,4636.00,true,1212
4262,2025-06-24 04:52:03.901627 +00:00,2025-07-04 08:49:57.901627 +00:00,6284.00,true,1212
4263,2025-08-18 01:49:53.217314 +00:00,2025-08-19 19:38:47.217314 +00:00,99.00,true,1212
4264,2018-08-02 03:23:09.201044 +00:00,2018-08-02 03:29:29.201044 +00:00,15755.00,true,1213
4265,2025-09-02 08:15:54.479674 +00:00,2025-09-02 08:28:06.479674 +00:00,3436.00,true,1214
4266,2025-09-11 10:04:38.775788 +00:00,2025-09-13 12:53:36.775788 +00:00,355.00,true,1214
4267,2025-09-29 13:47:55.166757 +00:00,2025-10-05 18:13:47.166757 +00:00,16006.00,true,1214
4268,2025-09-10 18:13:07.868872 +00:00,2025-09-11 01:31:49.868872 +00:00,12985.00,true,1214
4269,2025-09-03 09:45:30.922275 +00:00,2025-09-07 06:57:48.922275 +00:00,930.00,true,1214
4270,2012-07-22 22:21:16.983810 +00:00,2012-07-22 22:22:00.983810 +00:00,14186.00,true,1215
4271,2019-09-14 13:27:32.337446 +00:00,2019-09-22 05:50:01.337446 +00:00,24316.00,true,1215
4272,2015-07-04 10:13:00.602029 +00:00,2015-07-14 05:10:13.602029 +00:00,5228.00,true,1215
4273,2018-03-22 15:30:36.319612 +00:00,2018-03-25 12:19:37.319612 +00:00,11630.00,true,1215
4274,2018-01-12 17:48:11.425443 +00:00,2018-01-13 10:24:16.425443 +00:00,13568.00,true,1215
4275,2025-08-31 00:29:49.635005 +00:00,2025-08-31 00:36:11.635005 +00:00,3174.00,true,1216
4276,2025-08-31 05:14:42.894398 +00:00,2025-09-04 06:51:24.894398 +00:00,4789.00,true,1216
4277,2025-09-04 22:34:19.657346 +00:00,2025-09-15 12:39:09.657346 +00:00,223.00,true,1216
4278,2012-09-26 06:13:35.556785 +00:00,2012-09-26 06:27:01.556785 +00:00,3869.00,true,1217
4279,2016-05-17 23:01:14.939274 +00:00,2016-05-26 20:34:30.939274 +00:00,27444.00,true,1217
4280,2025-10-03 20:06:55.574391 +00:00,2025-10-03 20:13:00.574391 +00:00,1632.00,true,1218
4281,2025-10-04 05:30:23.004198 +00:00,,2702.00,false,1218
4282,2025-10-04 18:12:04.783373 +00:00,,1039.00,false,1218
4283,2025-10-04 00:11:21.876530 +00:00,2025-10-04 16:59:38.876530 +00:00,2329.00,true,1218
4284,2025-10-04 06:55:21.588121 +00:00,,1968.00,false,1218
4285,2025-10-04 14:23:22.021136 +00:00,,2665.00,false,1218
4286,2021-06-15 08:37:18.988774 +00:00,2021-06-15 08:49:13.988774 +00:00,1894.00,true,1219
4287,2023-08-06 16:23:15.803931 +00:00,2023-08-14 06:39:13.803931 +00:00,11338.00,true,1219
4288,2024-03-23 08:44:00.694110 +00:00,2024-03-25 02:32:29.694110 +00:00,1549.00,true,1219
4289,2023-12-14 04:32:38.081563 +00:00,2023-12-20 13:30:31.081563 +00:00,3636.00,true,1219
4290,2024-09-22 06:12:05.470773 +00:00,2024-10-03 17:53:04.470773 +00:00,2665.00,true,1219
4291,2022-07-10 09:03:38.659923 +00:00,2022-07-12 11:18:15.659923 +00:00,77.00,true,1219
4292,2010-06-23 11:11:36.925946 +00:00,2010-06-23 11:24:47.925946 +00:00,529.00,true,1220
4293,2012-12-06 19:21:58.052490 +00:00,2012-12-11 18:51:47.052490 +00:00,3943.00,true,1220
4294,2017-03-11 15:39:06.074662 +00:00,2017-03-14 13:02:30.074662 +00:00,6337.00,true,1220
4295,2025-03-08 04:45:44.684219 +00:00,2025-03-13 20:12:40.684219 +00:00,4103.00,true,1220
4296,2012-12-16 15:38:27.774993 +00:00,2012-12-24 21:41:33.774993 +00:00,2016.00,true,1220
4297,2013-10-07 04:55:55.730745 +00:00,2013-10-13 17:50:25.730745 +00:00,8527.00,true,1220
4298,2025-09-04 00:39:10.039102 +00:00,2025-09-04 00:53:41.039102 +00:00,3638.00,true,1221
4299,2025-10-04 02:31:03.812680 +00:00,2025-10-05 19:12:30.812680 +00:00,4407.00,true,1221
4300,2025-09-06 02:47:20.361008 +00:00,2025-09-09 03:15:04.361008 +00:00,4227.00,true,1221
4301,2025-09-30 11:57:47.347534 +00:00,,18663.00,false,1221
4302,2025-09-11 14:55:08.874595 +00:00,2025-09-17 00:55:01.874595 +00:00,26463.00,true,1221
4303,2017-04-03 23:35:43.963475 +00:00,2017-04-03 23:40:32.963475 +00:00,30861.00,true,1222
4304,2024-12-11 15:16:46.271130 +00:00,2024-12-22 17:19:35.271130 +00:00,3264.00,true,1222
4305,2020-10-14 04:44:06.147693 +00:00,2020-10-20 21:59:30.147693 +00:00,3625.00,true,1222
4306,2018-12-18 02:33:55.530977 +00:00,2018-12-18 02:38:25.530977 +00:00,24181.00,true,1223
4307,2021-12-25 08:33:27.599201 +00:00,2021-12-25 08:38:34.599201 +00:00,15755.00,true,1224
4308,2023-11-27 23:08:38.247989 +00:00,2023-12-02 14:29:00.247989 +00:00,14613.00,true,1224
4309,2021-01-02 23:50:08.960695 +00:00,2021-01-03 00:03:00.960695 +00:00,37163.00,true,1225
4310,2022-05-08 16:46:15.928895 +00:00,2022-05-16 23:08:15.928895 +00:00,1132.00,true,1225
4311,2022-10-07 00:21:43.070290 +00:00,2022-10-08 22:29:38.070290 +00:00,541.00,true,1225
4312,2021-04-22 18:24:38.691321 +00:00,2021-04-23 15:23:36.691321 +00:00,4051.00,true,1225
4313,2025-08-13 22:30:18.673772 +00:00,2025-08-13 22:44:53.673772 +00:00,296.00,true,1226
4314,2025-09-04 12:30:52.282714 +00:00,2025-09-15 19:45:57.282714 +00:00,358.00,true,1226
4315,2025-09-16 04:25:40.565562 +00:00,2025-09-20 08:01:42.565562 +00:00,588.00,true,1226
4316,2025-09-02 04:46:39.391919 +00:00,2025-09-02 08:15:20.391919 +00:00,313.00,true,1226
4317,2017-07-11 19:37:24.947664 +00:00,2017-07-11 19:43:02.947664 +00:00,3645.00,true,1227
4318,2025-05-28 10:57:52.570392 +00:00,2025-05-31 00:39:51.570392 +00:00,628.00,true,1227
4319,2019-08-18 03:43:04.907141 +00:00,2019-08-19 04:31:00.907141 +00:00,3368.00,true,1227
4320,2019-11-11 06:04:36.883770 +00:00,2019-11-20 15:20:30.883770 +00:00,71.00,true,1227
4321,2023-11-01 10:17:27.137445 +00:00,2023-11-01 10:18:41.137445 +00:00,836.00,true,1228
4322,2025-09-01 14:59:25.896891 +00:00,2025-09-01 17:01:01.896891 +00:00,3373.00,true,1228
4323,2024-09-18 08:33:10.592102 +00:00,2024-09-24 14:22:40.592102 +00:00,4740.00,true,1228
4324,2023-11-18 13:03:00.150287 +00:00,2023-11-28 15:41:12.150287 +00:00,1698.00,true,1228
4325,2025-02-20 00:15:11.461048 +00:00,2025-02-25 14:40:07.461048 +00:00,24165.00,true,1228
4326,2025-06-02 20:42:51.669995 +00:00,2025-06-05 21:28:10.669995 +00:00,14909.00,true,1228
4327,2025-08-29 14:53:14.887633 +00:00,2025-08-29 14:57:25.887633 +00:00,29074.00,true,1229
4328,2025-08-29 02:01:54.727452 +00:00,2025-08-29 02:16:34.727452 +00:00,10912.00,true,1230
4329,2025-09-01 05:35:02.927280 +00:00,2025-09-11 09:59:44.927280 +00:00,7993.00,true,1230
4330,2025-08-30 02:26:05.189711 +00:00,2025-09-03 15:16:04.189711 +00:00,5365.00,true,1230
4331,2025-09-25 06:49:50.895009 +00:00,,14365.00,false,1230
4332,2025-08-29 17:40:55.963943 +00:00,2025-08-30 09:14:04.963943 +00:00,7251.00,true,1230
4333,2017-08-15 04:03:06.224740 +00:00,2017-08-15 04:17:44.224740 +00:00,3069.00,true,1231
4334,2021-10-29 16:52:25.008288 +00:00,2021-11-05 17:38:04.008288 +00:00,440.00,true,1231
4335,2017-11-14 19:10:15.421580 +00:00,2017-11-20 00:49:51.421580 +00:00,260.00,true,1231
4336,2023-10-18 00:27:15.318219 +00:00,2023-10-20 19:06:02.318219 +00:00,5973.00,true,1231
4337,2017-09-15 17:09:07.332887 +00:00,2017-09-25 21:21:15.332887 +00:00,211.00,true,1231
4338,2018-01-07 23:36:42.856079 +00:00,2018-01-12 01:15:31.856079 +00:00,1084.00,true,1231
4339,2025-09-08 02:49:03.311452 +00:00,2025-09-08 02:59:27.311452 +00:00,430.00,true,1232
4340,2025-09-20 16:02:54.876687 +00:00,2025-09-30 11:41:00.876687 +00:00,4807.00,true,1232
4341,2025-10-01 02:42:48.873485 +00:00,,180.00,false,1232
4342,2025-10-04 05:56:11.144519 +00:00,,248.00,false,1232
4343,2025-10-01 21:58:36.055346 +00:00,,2791.00,false,1232
4344,2025-07-07 04:48:27.503468 +00:00,2025-07-07 04:52:13.503468 +00:00,1873.00,true,1233
4345,2025-07-26 21:06:23.198472 +00:00,2025-07-27 23:59:26.198472 +00:00,4753.00,true,1233
4346,2025-07-23 00:06:35.219354 +00:00,2025-07-25 07:09:16.219354 +00:00,2538.00,true,1233
4347,2015-03-20 11:36:00.511650 +00:00,2015-03-20 11:50:18.511650 +00:00,13142.00,true,1234
4348,2016-09-13 21:37:36.696831 +00:00,2016-09-15 12:19:32.696831 +00:00,273.00,true,1234
4349,2017-06-17 08:00:32.296525 +00:00,2017-06-22 12:06:00.296525 +00:00,12371.00,true,1234
4350,2017-11-08 18:30:14.153083 +00:00,2017-11-17 15:35:39.153083 +00:00,6378.00,true,1234
4351,2011-04-11 20:19:51.853057 +00:00,2011-04-11 20:20:29.853057 +00:00,6079.00,true,1235
4352,2011-11-20 20:33:49.513393 +00:00,2011-12-01 19:40:32.513393 +00:00,15237.00,true,1235
4353,2022-01-28 21:56:37.037097 +00:00,2022-02-06 09:35:38.037097 +00:00,11855.00,true,1235
4354,2013-05-13 17:54:33.659332 +00:00,2013-05-19 14:29:55.659332 +00:00,2286.00,true,1235
4355,2016-04-12 07:29:07.959392 +00:00,2016-04-18 07:18:48.959392 +00:00,1447.00,true,1235
4356,2025-10-04 06:59:44.382777 +00:00,2025-10-04 07:05:05.382777 +00:00,8722.00,true,1236
4357,2025-10-04 12:30:20.419540 +00:00,2025-10-04 13:34:37.419540 +00:00,7750.00,true,1236
4358,2025-10-04 22:33:58.221750 +00:00,,1878.00,false,1236
4359,2025-10-04 09:26:57.973877 +00:00,,9928.00,false,1236
4360,2014-07-23 20:04:03.053659 +00:00,2014-07-23 20:12:51.053659 +00:00,6951.00,true,1237
4361,2022-03-03 20:55:51.072277 +00:00,2022-03-08 19:25:56.072277 +00:00,25739.00,true,1237
4362,2023-07-09 07:46:55.275829 +00:00,2023-07-15 06:07:21.275829 +00:00,5891.00,true,1237
4363,2025-09-27 00:40:08.996747 +00:00,2025-09-27 00:55:22.996747 +00:00,846.00,true,1238
4364,2024-11-30 05:20:34.381212 +00:00,2024-11-30 05:35:26.381212 +00:00,216.00,true,1239
4365,2025-01-03 22:43:46.593916 +00:00,2025-01-05 07:19:34.593916 +00:00,19932.00,true,1239
4366,2025-09-19 11:17:13.445068 +00:00,2025-09-19 11:27:45.445068 +00:00,1958.00,true,1240
4367,2025-09-22 16:31:10.262820 +00:00,2025-09-23 00:03:04.262820 +00:00,528.00,true,1240
4368,2025-09-25 20:59:06.373949 +00:00,2025-10-03 07:32:40.373949 +00:00,2588.00,true,1240
4369,2025-10-02 10:39:35.428094 +00:00,2025-10-05 15:04:40.428094 +00:00,2912.00,true,1240
4370,2025-09-25 22:06:41.201707 +00:00,2025-10-04 16:15:40.201707 +00:00,3222.00,true,1240
4371,2014-06-24 04:05:37.837444 +00:00,2014-06-24 04:07:13.837444 +00:00,8012.00,true,1241
4372,2017-04-26 20:33:28.872380 +00:00,2017-05-08 06:22:32.872380 +00:00,40502.00,true,1241
4373,2015-10-06 14:04:51.829308 +00:00,2015-10-15 16:48:28.829308 +00:00,7856.00,true,1241
4374,2021-03-13 13:35:16.997370 +00:00,2021-03-24 07:51:50.997370 +00:00,7074.00,true,1241
4375,2015-07-13 04:08:40.332294 +00:00,2015-07-13 04:11:52.332294 +00:00,8234.00,true,1242
4376,2020-03-06 23:15:18.134432 +00:00,2020-03-09 17:14:51.134432 +00:00,13331.00,true,1242
4377,2020-06-23 18:17:25.738769 +00:00,2020-06-29 02:20:41.738769 +00:00,821.00,true,1242
4378,2016-04-13 01:22:50.081984 +00:00,2016-04-14 00:35:08.081984 +00:00,1187.00,true,1242
4379,2022-02-20 14:09:24.649818 +00:00,2022-02-28 05:49:01.649818 +00:00,15383.00,true,1242
4380,2017-01-25 04:47:48.353789 +00:00,2017-02-01 16:13:36.353789 +00:00,4986.00,true,1242
4381,2012-07-09 21:45:38.012869 +00:00,2012-07-09 21:54:17.012869 +00:00,959.00,true,1243
4382,2019-07-12 14:41:39.926401 +00:00,2019-07-24 03:18:22.926401 +00:00,1855.00,true,1243
4383,2023-03-27 08:49:03.588619 +00:00,2023-03-30 20:13:20.588619 +00:00,1024.00,true,1243
4384,2022-09-25 04:06:09.204718 +00:00,2022-09-29 13:31:13.204718 +00:00,465.00,true,1243
4385,2019-03-15 10:32:12.111121 +00:00,2019-03-18 11:00:13.111121 +00:00,6695.00,true,1243
4386,2022-08-04 11:25:49.914637 +00:00,2022-08-15 16:26:47.914637 +00:00,2854.00,true,1243
4387,2015-08-23 14:33:54.018722 +00:00,2015-08-23 14:42:56.018722 +00:00,5363.00,true,1244
4388,2017-02-16 10:05:02.456930 +00:00,2017-02-27 08:28:49.456930 +00:00,2074.00,true,1244
4389,2022-12-19 10:26:34.649273 +00:00,2022-12-22 08:27:59.649273 +00:00,355.00,true,1244
4390,2023-11-23 15:26:57.273876 +00:00,2023-11-23 15:37:46.273876 +00:00,320.00,true,1245
4391,2025-07-15 09:24:34.805884 +00:00,2025-07-16 14:28:59.805884 +00:00,6178.00,true,1245
4392,2024-06-28 05:36:48.088930 +00:00,2024-06-30 00:53:08.088930 +00:00,3831.00,true,1245
4393,2024-08-23 05:46:26.636458 +00:00,2024-08-24 02:37:48.636458 +00:00,1369.00,true,1245
4394,2024-10-26 09:17:37.296920 +00:00,2024-11-03 04:32:50.296920 +00:00,5481.00,true,1245
4395,2025-03-02 03:37:28.936586 +00:00,2025-03-06 02:38:45.936586 +00:00,5850.00,true,1245
4396,2025-09-12 23:41:47.909068 +00:00,2025-09-12 23:43:24.909068 +00:00,2249.00,true,1246
4397,2025-09-18 02:02:43.916640 +00:00,2025-09-28 03:17:32.916640 +00:00,729.00,true,1246
4398,2025-09-26 20:10:03.148931 +00:00,2025-09-30 11:49:02.148931 +00:00,1798.00,true,1246
4399,2025-10-03 15:05:43.174496 +00:00,,2968.00,false,1246
4400,2016-09-19 07:36:23.735142 +00:00,2016-09-19 07:46:27.735142 +00:00,23844.00,true,1247
4401,2019-05-02 20:04:24.177331 +00:00,2019-05-02 20:11:13.177331 +00:00,74.00,true,1248
4402,2020-07-08 15:12:45.119679 +00:00,2020-07-14 19:21:59.119679 +00:00,64.00,true,1248
4403,2022-09-20 12:56:06.572198 +00:00,2022-09-29 21:50:22.572198 +00:00,16.00,true,1248
4404,2024-09-24 13:02:34.122676 +00:00,2024-10-01 09:37:09.122676 +00:00,314.00,true,1248
4405,2023-08-08 22:11:41.986268 +00:00,2023-08-19 15:02:45.986268 +00:00,241.00,true,1248
4406,2023-03-22 19:07:46.637046 +00:00,2023-03-29 23:20:28.637046 +00:00,131.00,true,1248
4407,2019-11-06 04:54:29.896860 +00:00,2019-11-06 05:05:30.896860 +00:00,14723.00,true,1249
4408,2020-11-30 05:10:22.511586 +00:00,2020-12-09 06:49:18.511586 +00:00,105.00,true,1249
4409,2014-06-03 13:56:36.431072 +00:00,2014-06-03 14:11:54.431072 +00:00,623.00,true,1250
4410,2021-02-10 03:29:18.186836 +00:00,2021-02-18 19:45:26.186836 +00:00,1344.00,true,1250
4411,2022-09-15 00:50:56.062019 +00:00,2022-09-17 12:39:58.062019 +00:00,17601.00,true,1250
4412,2017-01-22 00:07:42.230531 +00:00,2017-01-22 19:47:02.230531 +00:00,915.00,true,1250
4413,2020-04-27 02:18:05.234528 +00:00,2020-05-07 08:15:49.234528 +00:00,12697.00,true,1250
4414,2013-11-28 21:58:02.684903 +00:00,2013-11-28 22:04:46.684903 +00:00,5970.00,true,1251
4415,2016-01-03 09:09:24.655127 +00:00,2016-01-12 16:10:20.655127 +00:00,5500.00,true,1251
4416,2014-07-08 23:11:25.870214 +00:00,2014-07-17 03:10:31.870214 +00:00,3984.00,true,1251
4417,2016-09-21 04:41:08.371067 +00:00,2016-09-21 04:49:27.371067 +00:00,6526.00,true,1252
4418,2020-03-15 20:18:47.227619 +00:00,2020-03-26 19:52:35.227619 +00:00,15701.00,true,1252
4419,2018-01-18 07:26:36.957462 +00:00,,5212.00,false,1252
4420,2024-05-01 11:05:45.638269 +00:00,2024-05-11 23:11:46.638269 +00:00,571.00,true,1252
4421,2023-07-08 18:29:16.260163 +00:00,2023-07-19 05:15:38.260163 +00:00,11668.00,true,1252
4422,2018-03-29 21:55:48.461253 +00:00,2018-04-06 07:05:39.461253 +00:00,17406.00,true,1252
4423,2020-08-29 13:17:24.522735 +00:00,2020-08-29 13:28:52.522735 +00:00,43148.00,true,1253
4424,2012-09-19 23:26:22.578206 +00:00,2012-09-19 23:40:43.578206 +00:00,72.00,true,1254
4425,2021-07-17 15:58:11.324192 +00:00,2021-07-28 10:28:10.324192 +00:00,2872.00,true,1254
4426,2016-09-24 12:50:01.876757 +00:00,2016-10-02 00:56:46.876757 +00:00,14762.00,true,1254
4427,2020-01-08 10:26:15.521133 +00:00,2020-01-08 10:35:05.521133 +00:00,9320.00,true,1255
4428,2024-07-01 06:55:17.514884 +00:00,2024-07-06 02:01:54.514884 +00:00,2215.00,true,1255
4429,2022-01-31 17:31:31.226799 +00:00,2022-02-07 04:27:27.226799 +00:00,32429.00,true,1255
4430,2019-01-23 01:46:46.802249 +00:00,2019-01-23 01:51:53.802249 +00:00,50143.00,true,1256
4431,2019-01-29 15:42:23.461102 +00:00,2019-02-07 18:35:58.461102 +00:00,10880.00,true,1256
4432,2010-11-24 02:59:12.565321 +00:00,2010-11-24 03:07:59.565321 +00:00,6061.00,true,1257
4433,2018-07-15 10:05:24.038943 +00:00,2018-07-18 00:38:02.038943 +00:00,1120.00,true,1257
4434,2023-05-21 07:56:44.721863 +00:00,2023-05-26 01:25:35.721863 +00:00,11146.00,true,1257
4435,2022-11-28 12:46:33.096411 +00:00,2022-11-28 12:57:28.096411 +00:00,5259.00,true,1258
4436,2024-05-04 17:05:16.831584 +00:00,2024-05-10 07:02:26.831584 +00:00,36204.00,true,1258
4437,2014-11-06 14:25:04.747297 +00:00,2014-11-06 14:39:01.747297 +00:00,495.00,true,1259
4438,2024-12-23 03:14:29.683459 +00:00,2024-12-25 02:18:34.683459 +00:00,136.00,true,1259
4439,2016-08-06 02:20:08.548314 +00:00,2016-08-13 19:20:19.548314 +00:00,246.00,true,1259
4440,2023-10-07 13:12:03.109316 +00:00,2023-10-08 08:11:52.109316 +00:00,316.00,true,1259
4441,2020-09-03 21:30:55.858440 +00:00,2020-09-06 00:18:41.858440 +00:00,153.00,true,1259
4442,2023-06-25 05:33:55.056096 +00:00,2023-06-30 22:59:36.056096 +00:00,550.00,true,1259
4443,2025-08-22 09:13:47.262174 +00:00,2025-08-22 09:16:48.262174 +00:00,12602.00,true,1260
4444,2025-09-04 02:43:33.102487 +00:00,2025-09-07 11:57:02.102487 +00:00,7810.00,true,1260
4445,2022-10-11 01:24:59.695733 +00:00,2022-10-11 01:26:00.695733 +00:00,20114.00,true,1261
4446,2023-11-20 07:54:58.943245 +00:00,2023-11-27 05:26:19.943245 +00:00,20776.00,true,1261
4447,2025-07-08 11:03:42.822611 +00:00,2025-07-08 11:10:50.822611 +00:00,3791.00,true,1262
4448,2025-08-13 01:02:32.902024 +00:00,2025-08-16 20:31:01.902024 +00:00,9628.00,true,1262
4449,2025-07-25 14:06:56.303723 +00:00,2025-07-30 13:54:10.303723 +00:00,4414.00,true,1262
4450,2025-07-13 04:02:07.801272 +00:00,,16469.00,false,1262
4451,2015-05-09 06:06:41.834274 +00:00,2015-05-09 06:12:00.834274 +00:00,8712.00,true,1263
4452,2025-01-01 19:24:38.921932 +00:00,2025-01-01 19:37:39.921932 +00:00,23001.00,true,1264
4453,2023-11-01 19:16:22.996165 +00:00,2023-11-01 19:31:53.996165 +00:00,1536.00,true,1265
4454,2025-02-02 13:56:22.631021 +00:00,2025-02-06 08:42:23.631021 +00:00,702.00,true,1265
4455,2024-03-03 08:45:44.063917 +00:00,2024-03-11 06:38:55.063917 +00:00,2988.00,true,1265
4456,2024-10-13 14:00:10.195239 +00:00,2024-10-21 04:15:01.195239 +00:00,956.00,true,1265
4457,2025-03-04 06:38:36.231083 +00:00,2025-03-15 17:47:57.231083 +00:00,1610.00,true,1265
4458,2015-04-19 16:48:08.291775 +00:00,2015-04-19 16:49:25.291775 +00:00,298.00,true,1266
4459,2019-11-06 08:33:53.728443 +00:00,2019-11-14 06:14:31.728443 +00:00,248.00,true,1266
4460,2015-09-12 22:13:03.192746 +00:00,2015-09-20 04:48:03.192746 +00:00,17.00,true,1266
4461,2021-06-22 10:49:10.329964 +00:00,2021-06-26 09:16:16.329964 +00:00,195.00,true,1266
4462,2025-04-15 13:24:07.746522 +00:00,2025-04-18 04:02:57.746522 +00:00,763.00,true,1266
4463,2025-09-07 06:34:24.289723 +00:00,2025-09-07 06:48:01.289723 +00:00,28893.00,true,1267
4464,2025-09-30 00:19:25.929329 +00:00,2025-10-04 13:48:10.929329 +00:00,18286.00,true,1267
4465,2014-11-18 11:28:56.610935 +00:00,2014-11-18 11:34:37.610935 +00:00,36637.00,true,1268
4466,2022-08-24 11:55:28.616557 +00:00,2022-08-24 11:56:25.616557 +00:00,19995.00,true,1269
4467,2014-01-22 00:49:25.882782 +00:00,2014-01-22 00:53:47.882782 +00:00,103.00,true,1270
4468,2023-02-19 23:51:20.353109 +00:00,2023-02-22 05:53:03.353109 +00:00,133.00,true,1270
4469,2017-12-31 04:53:27.380019 +00:00,2018-01-01 01:28:35.380019 +00:00,497.00,true,1270
4470,2015-05-20 02:22:53.218909 +00:00,2015-05-20 02:35:24.218909 +00:00,839.00,true,1271
4471,2020-03-07 18:14:45.115678 +00:00,2020-03-16 15:58:55.115678 +00:00,238.00,true,1271
4472,2024-04-26 18:02:23.935461 +00:00,2024-05-04 11:05:15.935461 +00:00,2657.00,true,1271
4473,2022-03-22 07:52:35.081321 +00:00,2022-03-31 16:31:32.081321 +00:00,954.00,true,1271
4474,2018-08-05 16:25:49.095653 +00:00,2018-08-11 00:11:41.095653 +00:00,2981.00,true,1271
4475,2025-09-20 22:52:59.936023 +00:00,2025-09-20 23:09:17.936023 +00:00,70108.00,true,1272
4476,2025-10-03 04:03:04.851541 +00:00,,9662.00,false,1272
4477,2021-10-11 02:26:30.959559 +00:00,2021-10-11 02:28:51.959559 +00:00,1811.00,true,1273
4478,2022-06-15 23:25:00.609869 +00:00,2022-06-24 10:00:28.609869 +00:00,54607.00,true,1273
4479,2025-09-14 22:55:19.826029 +00:00,2025-09-14 22:59:48.826029 +00:00,2014.00,true,1274
4480,2025-09-27 23:16:53.009138 +00:00,2025-09-28 18:08:27.009138 +00:00,8424.00,true,1274
4481,2025-09-27 04:25:42.609212 +00:00,2025-10-04 14:42:56.609212 +00:00,2809.00,true,1274
4482,2025-09-16 09:48:47.503479 +00:00,,3432.00,false,1274
4483,2025-09-22 01:56:12.013479 +00:00,,13261.00,false,1274
4484,2025-07-11 21:06:34.427141 +00:00,2025-07-11 21:20:06.427141 +00:00,10169.00,true,1275
4485,2025-07-25 16:18:37.495867 +00:00,2025-08-01 21:12:26.495867 +00:00,4717.00,true,1275
4486,2025-08-24 04:44:32.279724 +00:00,2025-09-02 20:19:46.279724 +00:00,10926.00,true,1275
4487,2025-07-27 22:48:14.711156 +00:00,,3868.00,false,1275
4488,2025-07-25 05:25:46.044498 +00:00,2025-07-29 09:05:59.044498 +00:00,7226.00,true,1275
4489,2023-01-05 06:38:42.137934 +00:00,2023-01-05 06:51:50.137934 +00:00,2137.00,true,1276
4490,2024-05-12 22:29:22.930202 +00:00,2024-05-16 07:11:17.930202 +00:00,15313.00,true,1276
4491,2023-05-01 22:27:27.621598 +00:00,2023-05-08 11:44:50.621598 +00:00,19564.00,true,1276
4492,2017-05-20 00:25:25.782152 +00:00,2017-05-20 00:28:19.782152 +00:00,37743.00,true,1277
4493,2025-08-09 02:30:56.269428 +00:00,2025-08-09 02:45:33.269428 +00:00,7563.00,true,1278
4494,2025-09-15 00:25:08.218383 +00:00,2025-09-26 02:43:00.218383 +00:00,3181.00,true,1278
4495,2024-07-08 02:40:01.620700 +00:00,2024-07-08 02:54:48.620700 +00:00,218.00,true,1279
4496,2025-06-04 04:52:16.695025 +00:00,2025-06-04 21:45:41.695025 +00:00,6539.00,true,1279
4497,2024-09-03 12:42:33.778127 +00:00,2024-09-12 08:12:35.778127 +00:00,4092.00,true,1279
4498,2014-09-02 22:52:25.078669 +00:00,2014-09-02 22:57:19.078669 +00:00,1790.00,true,1280
4499,2017-02-04 17:16:36.654781 +00:00,,4855.00,false,1280
4500,2022-06-02 10:12:25.734109 +00:00,2022-06-06 22:59:44.734109 +00:00,13970.00,true,1280
4501,2023-08-19 23:44:10.696560 +00:00,2023-08-24 18:54:36.696560 +00:00,8817.00,true,1280
4502,2023-01-18 07:10:35.836115 +00:00,2023-01-27 07:56:09.836115 +00:00,13752.00,true,1280
4503,2025-07-19 06:14:11.497808 +00:00,2025-07-19 06:30:37.497808 +00:00,3377.00,true,1281
4504,2025-09-14 22:01:01.218189 +00:00,2025-09-22 19:37:26.218189 +00:00,16032.00,true,1281
4505,2025-08-09 03:54:28.731458 +00:00,2025-08-20 08:17:26.731458 +00:00,14466.00,true,1281
4506,2025-09-19 17:46:13.312142 +00:00,2025-09-19 17:47:39.312142 +00:00,11079.00,true,1282
4507,2024-06-14 12:28:28.070234 +00:00,2024-06-14 12:31:50.070234 +00:00,12654.00,true,1283
4508,2025-05-17 04:17:22.571389 +00:00,2025-05-27 21:39:01.571389 +00:00,5284.00,true,1283
4509,2025-01-22 15:27:29.239471 +00:00,2025-01-23 20:10:08.239471 +00:00,36076.00,true,1283
4510,2025-08-13 03:07:32.870238 +00:00,2025-08-22 09:12:52.870238 +00:00,3959.00,true,1283
4511,2014-03-08 11:51:39.011604 +00:00,2014-03-08 11:55:07.011604 +00:00,2863.00,true,1284
4512,2015-04-25 16:41:35.367005 +00:00,2015-04-29 15:06:32.367005 +00:00,19475.00,true,1284
4513,2024-03-24 11:36:34.746590 +00:00,2024-03-27 10:19:31.746590 +00:00,3661.00,true,1284
4514,2017-09-16 16:14:45.030402 +00:00,2017-09-26 15:40:31.030402 +00:00,16572.00,true,1284
4515,2021-02-02 20:18:52.100714 +00:00,2021-02-02 20:31:17.100714 +00:00,27149.00,true,1285
4516,2022-06-26 14:26:18.856666 +00:00,2022-06-26 14:30:37.856666 +00:00,18102.00,true,1286
4517,2023-12-17 21:20:50.989055 +00:00,2023-12-26 18:10:47.989055 +00:00,9330.00,true,1286
4518,2022-10-04 10:06:04.847993 +00:00,2022-10-10 14:35:15.847993 +00:00,2703.00,true,1286
4519,2024-01-21 05:24:33.007044 +00:00,2024-02-01 15:50:52.007044 +00:00,4480.00,true,1286
4520,2013-01-23 21:33:07.157140 +00:00,2013-01-23 21:36:09.157140 +00:00,19437.00,true,1287
4521,2025-10-04 07:22:21.342730 +00:00,2025-10-04 07:29:20.342730 +00:00,7530.00,true,1288
4522,2025-10-04 16:45:35.986966 +00:00,,40238.00,false,1288
4523,2025-10-04 21:20:03.133340 +00:00,2025-10-06 03:36:10.133340 +00:00,10850.00,true,1288
4524,2020-09-29 00:26:05.883417 +00:00,2020-09-29 00:32:50.883417 +00:00,1180.00,true,1289
4525,2024-03-27 15:07:57.004081 +00:00,2024-04-03 22:53:09.004081 +00:00,1930.00,true,1289
4526,2021-08-29 08:56:58.503742 +00:00,2021-09-03 07:25:38.503742 +00:00,2766.00,true,1289
4527,2025-10-01 07:50:09.262774 +00:00,2025-10-02 03:57:18.262774 +00:00,1577.00,true,1289
4528,2021-03-10 18:07:04.436477 +00:00,2021-03-16 22:39:26.436477 +00:00,12781.00,true,1289
4529,2025-07-01 10:36:36.953959 +00:00,2025-07-01 10:48:52.953959 +00:00,26807.00,true,1290
4530,2013-03-31 09:12:37.660643 +00:00,2013-03-31 09:17:21.660643 +00:00,480.00,true,1291
4531,2017-06-18 01:16:31.450319 +00:00,2017-06-26 19:00:40.450319 +00:00,469.00,true,1291
4532,2013-05-21 20:18:28.361732 +00:00,2013-05-21 20:29:44.361732 +00:00,1970.00,true,1292
4533,2025-03-24 07:07:38.461421 +00:00,2025-04-01 05:27:22.461421 +00:00,9652.00,true,1292
4534,2018-11-29 02:19:40.658353 +00:00,2018-12-10 15:51:58.658353 +00:00,15723.00,true,1292
4535,2018-02-15 16:13:04.496395 +00:00,2018-02-15 16:26:21.496395 +00:00,17047.00,true,1293
4536,2024-10-29 00:48:40.986027 +00:00,2024-11-04 11:11:31.986027 +00:00,2935.00,true,1293
4537,2024-09-06 21:33:50.506190 +00:00,2024-09-13 15:26:45.506190 +00:00,3881.00,true,1293
4538,2020-01-30 20:01:09.993021 +00:00,2020-02-07 05:10:10.993021 +00:00,7358.00,true,1293
4539,2018-05-25 01:57:44.004943 +00:00,2018-05-31 06:31:49.004943 +00:00,2875.00,true,1293
4540,2018-03-14 05:57:31.214904 +00:00,2018-03-14 14:36:05.214904 +00:00,1346.00,true,1293
4541,2010-02-10 19:54:59.822422 +00:00,2010-02-10 20:06:55.822422 +00:00,23003.00,true,1294
4542,2015-03-01 22:05:06.424339 +00:00,2015-03-12 08:28:32.424339 +00:00,13804.00,true,1294
4543,2015-03-05 14:46:41.552397 +00:00,2015-03-14 11:33:55.552397 +00:00,6431.00,true,1294
4544,2022-02-12 18:13:47.613424 +00:00,2022-02-12 18:24:55.613424 +00:00,7968.00,true,1295
4545,2025-09-24 22:00:54.569278 +00:00,2025-09-24 22:06:29.569278 +00:00,7367.00,true,1372
4546,2025-10-03 04:47:36.429353 +00:00,,11438.00,false,1372
4547,2025-09-28 09:46:47.228763 +00:00,,1500.00,false,1372
4548,2025-10-03 12:32:49.382250 +00:00,,395.00,false,1372
4549,2025-09-27 02:33:55.638285 +00:00,2025-10-01 02:51:28.638285 +00:00,16159.00,true,1372
4550,2024-11-28 16:56:24.371481 +00:00,2024-11-28 17:11:44.371481 +00:00,19088.00,true,1296
4551,2025-05-12 04:28:44.420089 +00:00,2025-05-17 08:43:44.420089 +00:00,2156.00,true,1296
4552,2025-02-14 03:03:12.056539 +00:00,2025-02-14 13:36:19.056539 +00:00,2120.00,true,1296
4553,2025-05-14 13:19:33.434568 +00:00,2025-05-19 03:50:20.434568 +00:00,17884.00,true,1296
4554,2025-01-30 04:57:57.332321 +00:00,2025-01-31 20:12:56.332321 +00:00,2414.00,true,1296
4555,2025-09-23 01:38:30.003810 +00:00,2025-09-30 17:53:41.003810 +00:00,5192.00,true,1296
4556,2014-04-08 17:38:07.575344 +00:00,2014-04-08 17:47:42.575344 +00:00,24208.00,true,1297
4557,2020-05-13 06:19:51.568417 +00:00,2020-05-13 06:36:18.568417 +00:00,389.00,true,1298
4558,2024-09-24 00:32:30.827713 +00:00,2024-09-29 12:49:47.827713 +00:00,2258.00,true,1298
4559,2023-03-07 15:31:53.269515 +00:00,2023-03-10 09:22:41.269515 +00:00,2217.00,true,1298
4560,2022-04-09 06:53:27.359700 +00:00,2022-04-12 06:38:01.359700 +00:00,257.00,true,1298
4561,2024-01-01 00:18:34.368690 +00:00,2024-01-05 02:17:44.368690 +00:00,2280.00,true,1298
4562,2022-08-23 11:42:37.373263 +00:00,2022-08-28 14:09:21.373263 +00:00,7918.00,true,1298
4563,2012-06-13 10:30:54.247431 +00:00,2012-06-13 10:34:22.247431 +00:00,725.00,true,1299
4564,2022-06-30 05:27:43.277620 +00:00,,7985.00,false,1299
4565,2016-08-31 04:08:13.783949 +00:00,2016-09-03 01:06:38.783949 +00:00,29161.00,true,1299
4566,2016-01-15 17:04:36.072902 +00:00,2016-01-15 17:12:52.072902 +00:00,21365.00,true,1300
4567,2016-09-28 19:43:29.797663 +00:00,2016-10-06 21:00:53.797663 +00:00,6773.00,true,1300
4568,2012-03-24 17:16:46.533733 +00:00,2012-03-24 17:23:24.533733 +00:00,4213.00,true,1301
4569,2016-10-15 14:45:28.434776 +00:00,2016-10-24 10:44:22.434776 +00:00,24740.00,true,1301
4570,2025-09-27 03:51:35.273869 +00:00,2025-09-27 03:56:06.273869 +00:00,34880.00,true,1302
4571,2025-10-02 11:40:58.021281 +00:00,,126.00,false,1302
4572,2012-02-22 15:54:26.912519 +00:00,2012-02-22 16:08:10.912519 +00:00,1417.00,true,1303
4573,2025-08-08 23:39:20.214725 +00:00,2025-08-19 01:03:38.214725 +00:00,568.00,true,1303
4574,2017-09-06 22:49:30.322008 +00:00,2017-09-09 01:58:59.322008 +00:00,8259.00,true,1303
4575,2014-09-11 07:32:36.561397 +00:00,2014-09-15 08:19:49.561397 +00:00,1316.00,true,1303
4576,2018-10-14 06:57:33.282208 +00:00,2018-10-14 07:08:21.282208 +00:00,2584.00,true,1304
4577,2022-04-18 05:49:45.900795 +00:00,2022-04-24 17:13:26.900795 +00:00,339.00,true,1304
4578,2024-11-22 14:57:00.206027 +00:00,,15568.00,false,1304
4579,2025-08-12 09:44:57.318715 +00:00,2025-08-12 09:55:39.318715 +00:00,25168.00,true,1305
4580,2013-03-15 11:58:07.500299 +00:00,2013-03-15 12:13:27.500299 +00:00,12265.00,true,1306
4581,2022-05-16 19:12:45.772351 +00:00,2022-05-25 11:05:29.772351 +00:00,2713.00,true,1306
4582,2024-02-03 09:37:30.700804 +00:00,2024-02-08 21:32:30.700804 +00:00,7852.00,true,1306
4583,2011-01-21 10:45:41.042719 +00:00,2011-01-21 11:02:09.042719 +00:00,572.00,true,1307
4584,2011-02-11 22:18:38.975907 +00:00,2011-02-12 06:27:29.975907 +00:00,200.00,true,1307
4585,2015-06-04 21:33:02.024108 +00:00,2015-06-09 05:14:32.024108 +00:00,744.00,true,1307
4586,2018-06-28 06:10:41.827857 +00:00,2018-07-04 06:18:14.827857 +00:00,1088.00,true,1307
4587,2021-05-25 21:52:17.503977 +00:00,2021-05-31 19:35:47.503977 +00:00,216.00,true,1307
4588,2015-11-03 11:30:49.635632 +00:00,2015-11-03 11:35:51.635632 +00:00,1075.00,true,1308
4589,2019-04-22 19:22:44.286792 +00:00,2019-04-30 12:22:33.286792 +00:00,10916.00,true,1308
4590,2022-04-03 22:51:19.543823 +00:00,2022-04-12 01:56:43.543823 +00:00,7443.00,true,1308
4591,2021-12-04 17:38:13.631265 +00:00,2021-12-07 20:04:58.631265 +00:00,10902.00,true,1308
4592,2011-03-17 08:29:34.971376 +00:00,2011-03-17 08:31:37.971376 +00:00,1499.00,true,1309
4593,2020-01-16 05:15:50.202605 +00:00,2020-01-17 04:59:42.202605 +00:00,3841.00,true,1309
4594,2017-09-20 16:13:59.834492 +00:00,2017-09-20 16:26:29.834492 +00:00,4509.00,true,1310
4595,2025-05-02 03:49:26.207088 +00:00,2025-05-10 13:20:30.207088 +00:00,5255.00,true,1310
4596,2021-11-21 14:41:38.834955 +00:00,2021-11-25 08:58:23.834955 +00:00,4267.00,true,1310
4597,2023-04-28 14:54:16.684306 +00:00,2023-04-30 07:48:01.684306 +00:00,4994.00,true,1310
4598,2019-09-14 02:28:46.428254 +00:00,2019-09-14 16:41:09.428254 +00:00,4236.00,true,1310
4599,2022-03-13 13:47:58.855465 +00:00,2022-03-20 01:46:34.855465 +00:00,10838.00,true,1310
4600,2025-07-27 16:38:10.993175 +00:00,2025-07-27 16:40:08.993175 +00:00,53491.00,true,1311
4601,2025-09-05 01:54:49.852859 +00:00,2025-09-05 14:07:56.852859 +00:00,2204.00,true,1311
4602,2025-08-19 06:33:44.630697 +00:00,2025-08-19 06:37:40.630697 +00:00,35099.00,true,1312
4603,2025-08-14 21:07:44.813857 +00:00,2025-08-14 21:09:56.813857 +00:00,1482.00,true,1313
4604,2025-08-23 16:16:41.295594 +00:00,2025-08-30 12:22:21.295594 +00:00,4468.00,true,1313
4605,2012-12-15 17:44:11.483021 +00:00,2012-12-15 17:48:32.483021 +00:00,6442.00,true,1314
4606,2022-11-23 00:07:39.758737 +00:00,2022-11-27 03:51:27.758737 +00:00,16739.00,true,1314
4607,2017-01-25 10:09:50.615110 +00:00,2017-01-30 20:08:47.615110 +00:00,15245.00,true,1314
4608,2016-09-15 18:47:17.184853 +00:00,2016-09-17 15:51:10.184853 +00:00,10084.00,true,1314
4609,2024-04-25 04:51:05.933120 +00:00,2024-04-25 04:52:53.933120 +00:00,5051.00,true,1315
4610,2024-08-28 07:29:57.778211 +00:00,2024-09-03 12:39:10.778211 +00:00,4601.00,true,1315
4611,2024-08-28 11:24:55.156716 +00:00,2024-09-01 11:33:19.156716 +00:00,897.00,true,1315
4612,2024-07-05 12:38:54.340623 +00:00,2024-07-16 10:33:01.340623 +00:00,23447.00,true,1315
4613,2013-10-22 00:06:38.352487 +00:00,2013-10-22 00:21:09.352487 +00:00,18458.00,true,1316
4614,2017-11-05 18:04:10.751462 +00:00,2017-11-05 18:11:38.751462 +00:00,16563.00,true,1317
4615,2021-02-12 17:28:46.141507 +00:00,2021-02-20 17:36:45.141507 +00:00,3605.00,true,1317
4616,2024-01-30 07:46:04.521899 +00:00,2024-02-03 00:53:18.521899 +00:00,47812.00,true,1317
4617,2021-10-06 13:22:05.423231 +00:00,2021-10-17 16:05:40.423231 +00:00,6333.00,true,1317
4618,2012-09-25 06:56:13.012153 +00:00,2012-09-25 06:58:25.012153 +00:00,3253.00,true,1318
4619,2022-04-01 15:11:49.029815 +00:00,2022-04-09 02:46:40.029815 +00:00,2284.00,true,1318
4620,2021-03-02 03:38:19.646546 +00:00,2021-03-06 11:59:58.646546 +00:00,2822.00,true,1318
4621,2018-08-10 12:47:21.930326 +00:00,2018-08-14 12:55:18.930326 +00:00,4966.00,true,1318
4622,2013-10-16 01:28:16.697684 +00:00,2013-10-16 01:39:08.697684 +00:00,1340.00,true,1319
4623,2021-05-15 06:34:43.073865 +00:00,2021-05-24 15:58:19.073865 +00:00,71.00,true,1319
4624,2025-04-04 13:47:24.134221 +00:00,2025-04-13 17:45:17.134221 +00:00,4191.00,true,1319
4625,2015-03-09 03:50:00.173070 +00:00,2015-03-16 09:04:38.173070 +00:00,2361.00,true,1319
4626,2018-10-20 19:15:37.039364 +00:00,2018-10-23 06:21:07.039364 +00:00,1506.00,true,1319
4627,2019-05-24 19:11:27.741739 +00:00,2019-05-27 19:20:36.741739 +00:00,2861.00,true,1319
4628,2014-08-28 01:09:47.200190 +00:00,2014-08-28 01:23:26.200190 +00:00,31216.00,true,1320
4629,2025-08-05 18:58:36.323563 +00:00,2025-08-16 09:36:15.323563 +00:00,44419.00,true,1320
4630,2019-10-14 08:19:02.600912 +00:00,2019-10-19 03:28:57.600912 +00:00,5563.00,true,1320
4631,2022-05-19 06:53:47.599304 +00:00,2022-05-19 07:08:38.599304 +00:00,505.00,true,1321
4632,2023-08-20 07:22:33.126923 +00:00,2023-08-22 18:29:53.126923 +00:00,8924.00,true,1321
4633,2024-10-24 01:56:41.841829 +00:00,2024-11-02 15:48:06.841829 +00:00,4308.00,true,1321
4634,2025-08-19 17:03:40.956882 +00:00,2025-08-19 17:11:12.956882 +00:00,553.00,true,1322
4635,2025-09-12 01:07:32.793561 +00:00,2025-09-18 00:14:56.793561 +00:00,4197.00,true,1322
4636,2011-09-19 23:51:42.315216 +00:00,2011-09-20 00:01:44.315216 +00:00,2185.00,true,1323
4637,2012-10-13 03:54:43.219866 +00:00,2012-10-13 05:44:46.219866 +00:00,1240.00,true,1323
4638,2023-11-14 14:44:59.284710 +00:00,2023-11-14 14:50:28.284710 +00:00,4979.00,true,1324
4639,2024-04-23 20:59:07.711369 +00:00,2024-04-30 17:47:51.711369 +00:00,16574.00,true,1324
4640,2021-02-12 16:35:15.420356 +00:00,2021-02-12 16:46:22.420356 +00:00,58553.00,true,1325
4641,2013-08-14 17:59:47.475626 +00:00,2013-08-14 18:07:22.475626 +00:00,53789.00,true,1326
4642,2025-08-09 19:50:34.447331 +00:00,2025-08-09 20:05:00.447331 +00:00,10376.00,true,1327
4643,2025-09-18 17:36:22.067315 +00:00,2025-09-27 11:04:17.067315 +00:00,19891.00,true,1327
4644,2025-09-13 05:27:32.314092 +00:00,2025-09-16 23:30:12.314092 +00:00,486.00,true,1327
4645,2010-09-20 03:44:15.328314 +00:00,2010-09-20 03:59:49.328314 +00:00,11562.00,true,1328
4646,2023-12-28 20:37:49.543169 +00:00,2024-01-08 15:56:39.543169 +00:00,65648.00,true,1328
4647,2025-07-10 08:51:18.859617 +00:00,2025-07-10 08:56:05.859617 +00:00,16506.00,true,1329
4648,2025-08-28 10:05:44.410470 +00:00,2025-08-31 05:47:50.410470 +00:00,8935.00,true,1329
4649,2025-07-24 07:22:53.827847 +00:00,2025-07-29 14:22:26.827847 +00:00,14264.00,true,1329
4650,2025-08-09 21:51:50.051468 +00:00,2025-08-15 05:08:34.051468 +00:00,11760.00,true,1329
4651,2015-09-04 03:13:46.178329 +00:00,2015-09-04 03:16:44.178329 +00:00,2276.00,true,1330
4652,2016-01-15 23:48:43.373559 +00:00,2016-01-25 14:03:48.373559 +00:00,119.00,true,1330
4653,2018-06-01 12:48:12.696363 +00:00,2018-06-07 18:56:39.696363 +00:00,2852.00,true,1330
4654,2017-12-06 07:01:13.942313 +00:00,2017-12-11 12:21:15.942313 +00:00,705.00,true,1330
4655,2022-11-09 19:28:59.470831 +00:00,2022-11-09 19:39:11.470831 +00:00,2538.00,true,1331
4656,2025-07-26 07:14:54.045412 +00:00,,1782.00,false,1331
4657,2022-12-09 19:16:03.032982 +00:00,2022-12-19 16:27:53.032982 +00:00,7943.00,true,1331
4658,2023-12-26 00:52:08.764765 +00:00,2024-01-03 11:31:04.764765 +00:00,5741.00,true,1331
4659,2025-08-26 10:31:54.560836 +00:00,2025-09-06 10:07:11.560836 +00:00,12077.00,true,1331
4660,2025-04-30 08:47:28.014286 +00:00,2025-05-08 13:35:56.014286 +00:00,14956.00,true,1331
4661,2025-09-05 15:22:04.578199 +00:00,2025-09-05 15:27:36.578199 +00:00,4593.00,true,1332
4662,2025-09-06 19:24:31.214998 +00:00,2025-09-08 08:05:54.214998 +00:00,7531.00,true,1332
4663,2025-09-30 16:52:11.392618 +00:00,,1392.00,false,1332
4664,2025-09-14 17:41:06.459810 +00:00,2025-09-15 20:27:56.459810 +00:00,651.00,true,1332
4665,2025-09-27 08:02:10.881204 +00:00,2025-09-28 03:30:38.881204 +00:00,13795.00,true,1332
4666,2017-09-09 04:47:53.607428 +00:00,2017-09-09 04:59:31.607428 +00:00,25560.00,true,1333
4667,2019-06-01 17:48:25.416748 +00:00,2019-06-01 18:04:54.416748 +00:00,2986.00,true,1334
4668,2024-03-05 01:53:04.863651 +00:00,2024-03-08 06:01:53.863651 +00:00,820.00,true,1334
4669,2022-01-12 04:40:19.785327 +00:00,2022-01-19 13:09:58.785327 +00:00,4885.00,true,1334
4670,2023-08-16 07:48:53.761126 +00:00,2023-08-20 08:56:43.761126 +00:00,3792.00,true,1334
4671,2021-08-07 03:26:26.433546 +00:00,2021-08-18 17:01:06.433546 +00:00,2409.00,true,1334
4672,2021-05-02 09:51:55.401444 +00:00,2021-05-13 04:25:22.401444 +00:00,1830.00,true,1334
4673,2015-08-13 02:23:38.336904 +00:00,2015-08-13 02:29:55.336904 +00:00,5022.00,true,1335
4674,2011-07-19 15:54:36.263902 +00:00,2011-07-19 16:05:33.263902 +00:00,178.00,true,1336
4675,2018-06-29 06:06:38.768110 +00:00,2018-07-08 03:19:15.768110 +00:00,1755.00,true,1336
4676,2022-09-29 04:24:17.018693 +00:00,2022-10-04 22:52:53.018693 +00:00,1075.00,true,1336
4677,2023-01-01 03:22:38.577304 +00:00,2023-01-11 05:56:33.577304 +00:00,3053.00,true,1336
4678,2012-06-08 07:43:32.042441 +00:00,2012-06-08 07:55:55.042441 +00:00,812.00,true,1337
4679,2025-08-08 03:29:50.486266 +00:00,2025-08-08 03:43:48.486266 +00:00,12856.00,true,1338
4680,2025-10-01 14:14:49.925468 +00:00,,13051.00,false,1338
4681,2011-04-17 17:27:42.494341 +00:00,2011-04-17 17:44:15.494341 +00:00,1491.00,true,1339
4682,2012-12-18 05:57:19.175522 +00:00,2012-12-22 09:43:13.175522 +00:00,4842.00,true,1339
4683,2020-09-02 06:55:37.714185 +00:00,2020-09-07 22:55:51.714185 +00:00,7400.00,true,1339
4684,2014-02-28 17:21:25.745125 +00:00,2014-03-09 13:17:59.745125 +00:00,3297.00,true,1339
4685,2024-07-15 17:16:40.347074 +00:00,2024-07-15 17:27:54.347074 +00:00,3064.00,true,1340
4686,2025-07-22 09:50:57.911908 +00:00,2025-07-23 21:29:21.911908 +00:00,6003.00,true,1340
4687,2024-11-04 17:02:54.913321 +00:00,2024-11-15 00:19:25.913321 +00:00,16438.00,true,1340
4688,2024-11-24 18:46:38.933841 +00:00,2024-12-05 20:21:39.933841 +00:00,8228.00,true,1340
4689,2025-04-17 10:20:54.330379 +00:00,2025-04-26 03:12:29.330379 +00:00,21058.00,true,1340
4690,2025-09-12 21:06:49.127824 +00:00,2025-09-12 21:14:32.127824 +00:00,2381.00,true,1341
4691,2025-09-24 21:10:47.548743 +00:00,2025-10-03 12:53:59.548743 +00:00,562.00,true,1341
4692,2025-09-28 09:04:39.361960 +00:00,,147.00,false,1341
4693,2025-09-28 18:22:21.593623 +00:00,2025-10-02 17:22:26.593623 +00:00,1106.00,true,1341
4694,2025-09-17 11:09:12.164693 +00:00,2025-09-22 22:01:17.164693 +00:00,2553.00,true,1341
4695,2023-01-09 18:01:04.618040 +00:00,2023-01-09 18:08:11.618040 +00:00,14068.00,true,1342
4696,2025-03-05 14:40:41.692401 +00:00,2025-03-05 14:55:04.692401 +00:00,55175.00,true,1343
4697,2025-09-19 22:54:41.414954 +00:00,2025-09-19 22:58:34.414954 +00:00,8539.00,true,1344
4698,2025-10-02 03:27:12.105646 +00:00,2025-10-03 13:10:03.105646 +00:00,12014.00,true,1344
4699,2025-10-02 19:32:04.887228 +00:00,,3241.00,false,1344
4700,2025-09-21 05:56:44.524955 +00:00,2025-09-25 08:39:12.524955 +00:00,12430.00,true,1344
4701,2025-09-30 02:38:44.997352 +00:00,2025-10-05 10:16:59.997352 +00:00,9363.00,true,1344
4702,2023-01-07 03:27:46.753457 +00:00,2023-01-07 03:30:10.753457 +00:00,20899.00,true,1345
4703,2025-01-05 10:33:14.095142 +00:00,2025-01-05 10:35:15.095142 +00:00,4214.00,true,1346
4704,2025-05-09 08:06:58.334008 +00:00,2025-05-17 23:16:55.334008 +00:00,5659.00,true,1346
4705,2025-04-03 13:48:51.663033 +00:00,2025-04-11 23:10:38.663033 +00:00,4469.00,true,1346
4706,2025-02-14 17:11:59.881320 +00:00,2025-02-17 14:08:17.881320 +00:00,8189.00,true,1346
4707,2014-10-28 05:29:45.114825 +00:00,2014-10-28 05:42:37.114825 +00:00,1392.00,true,1347
4708,2019-05-28 06:39:39.840510 +00:00,2019-06-02 06:48:55.840510 +00:00,18110.00,true,1347
4709,2019-06-08 07:16:19.627824 +00:00,2019-06-08 07:27:25.627824 +00:00,31104.00,true,1348
4710,2023-06-11 03:05:45.414710 +00:00,2023-06-11 03:05:55.414710 +00:00,2322.00,true,1349
4711,2024-04-03 20:12:05.035469 +00:00,2024-04-08 22:53:00.035469 +00:00,1891.00,true,1349
4712,2025-01-07 01:06:00.232920 +00:00,2025-01-15 13:15:17.232920 +00:00,2091.00,true,1349
4713,2025-04-02 04:00:01.338713 +00:00,2025-04-04 18:35:58.338713 +00:00,1273.00,true,1349
4714,2023-07-02 21:00:48.591358 +00:00,2023-07-03 16:12:46.591358 +00:00,2737.00,true,1349
4715,2024-12-13 03:35:49.015993 +00:00,2024-12-16 23:57:37.015993 +00:00,2892.00,true,1349
4716,2017-04-29 01:28:09.758612 +00:00,2017-04-29 01:32:23.758612 +00:00,11133.00,true,1350
4717,2024-05-23 23:59:42.631669 +00:00,2024-05-27 02:51:18.631669 +00:00,708.00,true,1350
4718,2022-02-08 12:19:48.566314 +00:00,2022-02-12 05:45:28.566314 +00:00,14266.00,true,1350
4719,2020-03-15 20:59:58.361335 +00:00,2020-03-15 21:12:14.361335 +00:00,19806.00,true,1351
4720,2024-12-24 22:24:28.115176 +00:00,2024-12-29 01:44:03.115176 +00:00,5535.00,true,1351
4721,2021-09-15 21:16:22.751240 +00:00,2021-09-16 01:35:33.751240 +00:00,2243.00,true,1351
4722,2020-11-29 14:53:58.324488 +00:00,2020-12-10 17:53:45.324488 +00:00,5859.00,true,1351
4723,2025-06-13 04:55:31.666579 +00:00,2025-06-17 17:12:51.666579 +00:00,8414.00,true,1351
4724,2016-08-11 07:31:02.303687 +00:00,2016-08-11 07:42:23.303687 +00:00,19528.00,true,1352
4725,2018-02-15 23:47:47.575988 +00:00,2018-02-21 08:44:38.575988 +00:00,1784.00,true,1352
4726,2025-07-20 10:15:07.460476 +00:00,2025-07-20 10:27:32.460476 +00:00,1388.00,true,1353
4727,2025-08-10 15:12:26.954772 +00:00,2025-08-18 06:27:20.954772 +00:00,4857.00,true,1353
4728,2025-08-22 12:26:24.836986 +00:00,2025-08-23 14:25:47.836986 +00:00,3.00,true,1353
4729,2025-08-25 11:33:58.755111 +00:00,2025-09-02 18:37:24.755111 +00:00,1222.00,true,1353
4730,2025-08-01 06:55:54.155456 +00:00,2025-08-04 19:34:28.155456 +00:00,96.00,true,1353
4731,2025-08-31 16:02:04.204446 +00:00,2025-09-08 11:21:35.204446 +00:00,186.00,true,1353
4732,2025-08-02 03:25:53.432020 +00:00,2025-08-02 03:31:42.432020 +00:00,23.00,true,1354
4733,2025-08-09 10:19:43.275201 +00:00,2025-08-20 07:03:04.275201 +00:00,804.00,true,1354
4734,2025-09-29 08:58:38.839947 +00:00,,12418.00,false,1354
4735,2010-11-09 10:50:04.744570 +00:00,2010-11-09 10:55:05.744570 +00:00,3602.00,true,1355
4736,2024-05-31 08:24:25.743878 +00:00,2024-05-31 08:40:46.743878 +00:00,10085.00,true,1356
4737,2025-04-27 09:34:37.120395 +00:00,2025-05-03 08:31:53.120395 +00:00,11516.00,true,1356
4738,2021-04-01 22:24:31.519661 +00:00,2021-04-01 22:28:10.519661 +00:00,8643.00,true,1357
4739,2024-09-16 12:12:45.922853 +00:00,2024-09-22 21:29:59.922853 +00:00,7393.00,true,1357
4740,2023-06-09 14:33:38.706646 +00:00,2023-06-19 13:14:56.706646 +00:00,5141.00,true,1357
4741,2024-09-03 10:19:05.043300 +00:00,2024-09-10 04:09:37.043300 +00:00,18622.00,true,1357
4742,2025-07-08 20:32:02.887015 +00:00,2025-07-08 20:40:58.887015 +00:00,35186.00,true,1358
4743,2023-02-19 06:18:31.065444 +00:00,2023-02-19 06:26:19.065444 +00:00,24496.00,true,1359
4744,2012-10-03 13:25:45.441034 +00:00,2012-10-03 13:31:19.441034 +00:00,4865.00,true,1360
4745,2016-11-16 17:05:06.101871 +00:00,2016-11-16 17:18:30.101871 +00:00,7100.00,true,1361
4746,2019-02-09 04:15:16.948312 +00:00,2019-02-14 23:39:52.948312 +00:00,48460.00,true,1361
4747,2025-07-07 03:36:41.743294 +00:00,2025-07-07 03:45:50.743294 +00:00,112.00,true,1362
4748,2025-07-23 08:55:35.252719 +00:00,2025-07-31 05:04:42.252719 +00:00,1622.00,true,1362
4749,2025-09-17 09:10:54.907197 +00:00,2025-09-22 14:40:39.907197 +00:00,1097.00,true,1362
4750,2025-08-29 02:08:10.380171 +00:00,2025-09-06 23:05:16.380171 +00:00,3994.00,true,1362
4751,2025-07-22 23:34:01.757512 +00:00,2025-08-02 08:09:30.757512 +00:00,1500.00,true,1362
4752,2025-09-22 06:52:47.462414 +00:00,2025-09-24 04:41:05.462414 +00:00,1101.00,true,1362
4753,2025-07-21 13:24:21.620699 +00:00,2025-07-21 13:27:26.620699 +00:00,4433.00,true,1363
4754,2025-08-24 02:56:13.281005 +00:00,2025-08-26 21:45:08.281005 +00:00,2513.00,true,1363
4755,2010-04-21 12:44:47.339161 +00:00,2010-04-21 12:47:12.339161 +00:00,71844.00,true,1364
4756,2025-09-17 19:42:30.331219 +00:00,2025-09-17 19:54:34.331219 +00:00,3264.00,true,1365
4757,2025-09-27 10:30:39.884348 +00:00,2025-10-04 22:19:38.884348 +00:00,3488.00,true,1365
4758,2025-09-28 09:24:51.197603 +00:00,2025-10-01 06:47:30.197603 +00:00,7336.00,true,1365
4759,2025-09-25 03:32:08.219818 +00:00,,17191.00,false,1365
4760,2025-09-29 04:29:04.036570 +00:00,2025-09-30 08:22:54.036570 +00:00,1315.00,true,1365
4761,2025-09-27 20:24:13.636056 +00:00,,6641.00,false,1365
4762,2012-01-22 13:03:36.683891 +00:00,2012-01-22 13:12:38.683891 +00:00,1072.00,true,1366
4763,2018-06-24 01:38:00.144488 +00:00,2018-06-29 00:28:41.144488 +00:00,326.00,true,1366
4764,2024-05-25 13:45:05.695315 +00:00,2024-06-05 11:29:34.695315 +00:00,4474.00,true,1366
4765,2021-11-27 22:28:18.642448 +00:00,2021-11-28 21:38:14.642448 +00:00,1782.00,true,1366
4766,2018-08-07 12:51:46.479504 +00:00,2018-08-08 04:43:44.479504 +00:00,4379.00,true,1366
4767,2013-08-18 07:10:11.451237 +00:00,2013-08-25 03:45:13.451237 +00:00,1244.00,true,1366
4768,2010-08-08 16:38:24.447083 +00:00,2010-08-08 16:41:26.447083 +00:00,293.00,true,1367
4769,2016-08-10 03:49:29.317870 +00:00,2016-08-17 12:41:53.317870 +00:00,767.00,true,1367
4770,2020-12-22 07:21:08.843826 +00:00,2020-12-25 17:18:24.843826 +00:00,14857.00,true,1367
4771,2015-03-04 20:20:18.908890 +00:00,2015-03-07 01:00:40.908890 +00:00,2171.00,true,1367
4772,2021-11-23 01:53:30.442330 +00:00,2021-11-23 02:01:13.442330 +00:00,1431.00,true,1368
4773,2022-05-13 05:43:58.052725 +00:00,2022-05-23 13:26:43.052725 +00:00,2532.00,true,1368
4774,2024-03-19 02:55:37.749425 +00:00,2024-03-22 10:52:25.749425 +00:00,2219.00,true,1368
4775,2022-04-03 16:45:23.564899 +00:00,2022-04-12 05:59:56.564899 +00:00,321.00,true,1368
4776,2024-03-29 15:27:09.462425 +00:00,2024-04-08 21:43:35.462425 +00:00,164.00,true,1368
4777,2023-02-01 01:51:14.799894 +00:00,2023-02-03 11:14:06.799894 +00:00,1693.00,true,1368
4778,2024-05-01 17:18:09.419815 +00:00,2024-05-01 17:25:27.419815 +00:00,8915.00,true,1369
4779,2025-01-31 08:40:07.448266 +00:00,2025-02-08 16:35:34.448266 +00:00,27290.00,true,1369
4780,2024-05-29 15:40:48.896710 +00:00,2024-06-05 15:13:33.896710 +00:00,2921.00,true,1369
4781,2025-08-26 16:20:45.938151 +00:00,2025-09-03 02:01:03.938151 +00:00,8873.00,true,1369
4782,2014-01-11 04:45:39.638668 +00:00,2014-01-11 04:52:45.638668 +00:00,8326.00,true,1370
4783,2021-07-25 00:57:36.670883 +00:00,2021-08-03 06:53:57.670883 +00:00,2900.00,true,1370
4784,2020-01-03 07:04:57.210853 +00:00,2020-01-14 10:42:10.210853 +00:00,2616.00,true,1370
4785,2025-08-12 17:38:34.404434 +00:00,2025-08-14 04:07:20.404434 +00:00,6877.00,true,1370
4786,2021-07-25 12:42:48.220425 +00:00,2021-07-27 12:55:36.220425 +00:00,16874.00,true,1370
4787,2014-12-05 13:30:49.372900 +00:00,2014-12-07 20:52:51.372900 +00:00,1283.00,true,1370
4788,2016-10-28 10:46:36.466746 +00:00,2016-10-28 11:01:04.466746 +00:00,3141.00,true,1371
4789,2024-09-15 17:59:50.363925 +00:00,2024-09-25 14:52:59.363925 +00:00,2695.00,true,1371
4790,2018-05-25 00:01:06.707813 +00:00,2018-06-01 03:27:33.707813 +00:00,19724.00,true,1371
4791,2018-08-26 16:07:48.063301 +00:00,2018-08-29 08:52:31.063301 +00:00,7175.00,true,1371
4792,2018-01-17 18:49:03.914118 +00:00,2018-01-23 21:52:45.914118 +00:00,3600.00,true,1371
4793,2025-10-04 04:58:42.541307 +00:00,2025-10-04 05:04:48.541307 +00:00,37863.00,true,1373
4794,2025-08-15 14:21:41.772004 +00:00,2025-08-15 14:33:48.772004 +00:00,6142.00,true,1374
4795,2025-09-09 15:16:35.456080 +00:00,,7518.00,false,1374
4796,2025-08-18 19:44:59.080527 +00:00,2025-08-27 16:15:02.080527 +00:00,5352.00,true,1374
4797,2014-10-10 14:51:27.787259 +00:00,2014-10-10 15:00:43.787259 +00:00,68501.00,true,1375
4798,2021-04-06 21:46:13.923972 +00:00,2021-04-06 21:53:47.923972 +00:00,6836.00,true,1376
4799,2023-11-05 12:05:50.787196 +00:00,2023-11-09 03:36:22.787196 +00:00,5862.00,true,1376
4800,2022-06-10 22:16:40.052426 +00:00,2022-06-18 22:14:54.052426 +00:00,2360.00,true,1376
4801,2025-07-19 00:29:13.994045 +00:00,2025-07-21 22:37:15.994045 +00:00,1450.00,true,1376
4802,2021-06-02 17:12:22.742445 +00:00,2021-06-02 17:27:29.742445 +00:00,7638.00,true,1377
4803,2025-04-21 07:06:04.951538 +00:00,2025-04-21 09:01:39.951538 +00:00,4515.00,true,1377
4804,2023-03-14 03:13:41.546950 +00:00,2023-03-16 00:39:24.546950 +00:00,2728.00,true,1377
4805,2022-05-01 02:46:02.368850 +00:00,2022-05-06 13:46:39.368850 +00:00,77.00,true,1377
4806,2023-10-03 04:01:25.961837 +00:00,2023-10-08 09:09:28.961837 +00:00,1986.00,true,1377
4807,2025-08-24 02:24:56.070538 +00:00,2025-08-24 02:37:11.070538 +00:00,934.00,true,1378
4808,2025-09-25 14:42:15.638140 +00:00,,1474.00,false,1378
4809,2025-09-04 14:15:20.603039 +00:00,2025-09-06 13:20:51.603039 +00:00,2440.00,true,1378
4810,2025-07-22 19:04:10.173656 +00:00,2025-07-22 19:19:17.173656 +00:00,5751.00,true,1379
4811,2025-09-28 08:36:36.540498 +00:00,2025-09-29 23:37:46.540498 +00:00,2323.00,true,1379
4812,2022-10-30 06:28:44.068743 +00:00,2022-10-30 06:35:56.068743 +00:00,17880.00,true,1380
4813,2022-11-25 10:53:29.203102 +00:00,2022-12-02 02:40:25.203102 +00:00,5951.00,true,1380
4814,2024-01-07 12:04:06.489918 +00:00,2024-01-11 21:30:28.489918 +00:00,8741.00,true,1380
4815,2024-02-14 20:44:03.485765 +00:00,2024-02-19 01:32:44.485765 +00:00,22675.00,true,1380
4816,2014-01-12 20:15:43.500676 +00:00,2014-01-12 20:22:13.500676 +00:00,7681.00,true,1381
4817,2019-10-19 12:36:22.020806 +00:00,2019-10-30 12:19:19.020806 +00:00,12093.00,true,1381
4818,2018-07-27 06:26:43.507804 +00:00,2018-07-27 20:06:51.507804 +00:00,2317.00,true,1381
4819,2018-12-29 06:39:21.057673 +00:00,2019-01-04 02:09:13.057673 +00:00,3583.00,true,1381
4820,2019-07-26 16:07:36.596494 +00:00,2019-08-07 03:50:51.596494 +00:00,5798.00,true,1381
4821,2025-09-26 02:38:12.597146 +00:00,2025-09-26 02:48:16.597146 +00:00,5882.00,true,1382
4822,2025-10-02 13:30:03.176920 +00:00,,8402.00,false,1382
4823,2025-10-02 01:50:29.941194 +00:00,2025-10-02 11:01:57.941194 +00:00,8330.00,true,1382
4824,2025-09-29 02:26:09.309601 +00:00,2025-10-04 13:42:58.309601 +00:00,7466.00,true,1382
4825,2016-03-22 02:07:18.219221 +00:00,2016-03-22 02:10:05.219221 +00:00,1707.00,true,1383
4826,2019-03-21 10:26:50.329540 +00:00,2019-03-24 03:32:42.329540 +00:00,39055.00,true,1383
4827,2025-08-21 09:07:40.400661 +00:00,2025-08-21 09:11:45.400661 +00:00,1097.00,true,1384
4828,2025-09-04 02:34:11.595955 +00:00,2025-09-05 19:45:05.595955 +00:00,12691.00,true,1384
4829,2025-08-22 09:25:52.961622 +00:00,2025-08-24 06:49:15.961622 +00:00,29692.00,true,1384
4830,2025-09-04 22:29:38.774243 +00:00,2025-09-05 20:04:18.774243 +00:00,2579.00,true,1384
4831,2017-05-10 04:34:22.790415 +00:00,2017-05-10 04:46:32.790415 +00:00,11249.00,true,1385
4832,2021-11-08 17:45:00.623272 +00:00,2021-11-10 11:22:38.623272 +00:00,22706.00,true,1385
4833,2015-09-30 15:07:34.265145 +00:00,2015-09-30 15:09:19.265145 +00:00,82363.00,true,1386
4834,2016-06-05 20:13:20.772409 +00:00,,1808.00,false,1386
4835,2010-03-19 18:40:55.541819 +00:00,2010-03-19 18:42:49.541819 +00:00,1696.00,true,1387
4836,2025-06-16 06:07:49.708182 +00:00,2025-06-17 21:53:15.708182 +00:00,1128.00,true,1387
4837,2019-09-09 06:00:54.342612 +00:00,2019-09-20 17:38:15.342612 +00:00,1608.00,true,1387
4838,2014-05-27 23:51:53.918548 +00:00,2014-05-28 00:02:42.918548 +00:00,3103.00,true,1388
4839,2020-09-28 07:55:24.396050 +00:00,2020-09-28 12:40:36.396050 +00:00,1441.00,true,1388
4840,2021-03-15 02:22:11.397883 +00:00,2021-03-22 15:57:22.397883 +00:00,3319.00,true,1388
4841,2016-01-19 18:43:03.759408 +00:00,2016-01-20 18:14:30.759408 +00:00,19976.00,true,1388
4842,2015-10-10 18:31:05.577770 +00:00,2015-10-10 18:43:18.577770 +00:00,25395.00,true,1389
4843,2023-07-01 16:19:21.859900 +00:00,2023-07-03 01:09:11.859900 +00:00,8168.00,true,1389
4844,2022-07-12 07:19:37.402960 +00:00,2022-07-23 07:34:57.402960 +00:00,1545.00,true,1389
4845,2016-08-18 05:04:42.713963 +00:00,2016-08-24 06:16:33.713963 +00:00,30540.00,true,1389
4846,2025-09-19 17:31:37.918709 +00:00,2025-09-19 17:32:08.918709 +00:00,8842.00,true,1390
4847,2025-10-04 14:09:34.660620 +00:00,2025-10-05 04:05:31.660620 +00:00,36733.00,true,1390
4848,2025-03-29 23:24:47.268504 +00:00,2025-03-29 23:26:32.268504 +00:00,30200.00,true,1391
4849,2025-07-20 18:05:43.160620 +00:00,2025-07-24 13:06:26.160620 +00:00,2193.00,true,1391
4850,2025-07-28 15:28:29.471940 +00:00,2025-07-28 15:35:32.471940 +00:00,9213.00,true,1392
4851,2025-09-03 06:07:19.183980 +00:00,2025-09-08 17:04:29.183980 +00:00,1725.00,true,1392
4852,2025-09-02 00:02:44.676446 +00:00,2025-09-12 21:46:04.676446 +00:00,2248.00,true,1392
4853,2025-08-01 02:48:57.577972 +00:00,2025-08-05 03:36:22.577972 +00:00,848.00,true,1392
4854,2025-08-18 01:02:23.876631 +00:00,2025-08-28 14:57:21.876631 +00:00,7915.00,true,1392
4855,2010-10-22 10:32:54.341357 +00:00,2010-10-22 10:35:35.341357 +00:00,13147.00,true,1393
4856,2020-07-31 12:08:38.682257 +00:00,2020-08-04 20:40:54.682257 +00:00,2090.00,true,1393
4857,2013-02-13 14:00:32.458095 +00:00,2013-02-18 13:11:36.458095 +00:00,15132.00,true,1393
4858,2025-08-13 16:07:45.321889 +00:00,2025-08-13 16:13:53.321889 +00:00,2332.00,true,1394
4859,2025-09-24 17:10:37.959349 +00:00,2025-10-02 07:20:20.959349 +00:00,2323.00,true,1394
4860,2025-09-23 05:49:13.684246 +00:00,2025-09-25 00:43:00.684246 +00:00,17796.00,true,1394
4861,2025-08-16 19:44:26.825514 +00:00,2025-08-27 08:28:15.825514 +00:00,2060.00,true,1394
4862,2025-09-03 00:13:25.362142 +00:00,2025-09-13 03:18:25.362142 +00:00,427.00,true,1394
4863,2025-09-07 12:02:19.373269 +00:00,2025-09-07 17:01:44.373269 +00:00,421.00,true,1394
4864,2016-12-08 08:16:17.587134 +00:00,2016-12-08 08:20:55.587134 +00:00,7854.00,true,1395
4865,2018-12-16 23:35:10.568924 +00:00,2018-12-18 16:16:35.568924 +00:00,6504.00,true,1395
4866,2025-10-04 21:25:50.788181 +00:00,2025-10-04 21:28:51.788181 +00:00,37012.00,true,1396
4867,2025-10-04 23:53:35.249408 +00:00,,9746.00,false,1396
4868,2025-10-04 22:43:38.649355 +00:00,,21405.00,false,1396
4869,2025-10-04 21:33:35.272530 +00:00,,7907.00,false,1396
4870,2025-09-19 14:55:51.267718 +00:00,2025-09-19 14:59:43.267718 +00:00,2673.00,true,1397
4871,2025-10-04 21:42:56.563006 +00:00,,3657.00,false,1397
4872,2025-09-30 11:56:57.784410 +00:00,2025-10-05 18:54:37.784410 +00:00,5029.00,true,1397
4873,2025-10-01 04:56:11.503115 +00:00,,7752.00,false,1397
4874,2025-09-23 08:59:17.231769 +00:00,2025-09-23 09:03:57.231769 +00:00,5154.00,true,1398
4875,2025-09-27 09:17:34.367316 +00:00,2025-10-05 05:25:05.367316 +00:00,14496.00,true,1398
4876,2023-07-03 07:21:03.802660 +00:00,2023-07-03 07:26:05.802660 +00:00,7336.00,true,1399
4877,2025-06-03 17:49:46.253233 +00:00,2025-06-03 23:49:30.253233 +00:00,9085.00,true,1399
4878,2025-07-12 17:06:21.757069 +00:00,2025-07-20 00:03:02.757069 +00:00,1540.00,true,1399
4879,2024-04-28 21:37:00.003485 +00:00,2024-05-09 06:34:31.003485 +00:00,8271.00,true,1399
4880,2025-08-28 08:26:52.498009 +00:00,2025-08-28 08:39:57.498009 +00:00,10783.00,true,1400
4881,2025-09-04 07:59:52.850230 +00:00,2025-09-04 08:15:22.850230 +00:00,15771.00,true,1401
4882,2025-09-14 06:06:40.836310 +00:00,2025-09-16 17:40:25.836310 +00:00,15893.00,true,1401
4883,2025-09-24 15:13:09.559383 +00:00,2025-10-04 11:48:44.559383 +00:00,3772.00,true,1401
4884,2014-04-10 21:32:22.380892 +00:00,2014-04-10 21:43:02.380892 +00:00,1484.00,true,1402
4885,2024-12-07 04:48:58.908958 +00:00,2024-12-15 08:40:08.908958 +00:00,1261.00,true,1402
4886,2022-12-18 03:06:07.583077 +00:00,2022-12-28 21:44:32.583077 +00:00,10073.00,true,1402
4887,2014-05-04 13:52:22.445605 +00:00,2014-05-04 14:07:34.445605 +00:00,15288.00,true,1403
4888,2024-09-29 17:42:23.237381 +00:00,2024-10-01 01:38:00.237381 +00:00,33570.00,true,1403
4889,2020-08-31 15:35:00.517887 +00:00,2020-09-02 03:41:22.517887 +00:00,3378.00,true,1403
4890,2011-12-18 09:22:37.305470 +00:00,2011-12-18 09:31:30.305470 +00:00,2712.00,true,1404
4891,2017-04-21 05:51:51.288740 +00:00,2017-05-01 05:19:54.288740 +00:00,525.00,true,1404
4892,2016-06-08 22:57:11.667975 +00:00,2016-06-11 09:00:26.667975 +00:00,3435.00,true,1404
4893,2025-09-27 19:31:24.174777 +00:00,2025-09-27 19:46:25.174777 +00:00,5793.00,true,1405
4894,2025-10-01 05:21:36.671472 +00:00,2025-10-06 02:02:44.671472 +00:00,13735.00,true,1405
4895,2025-09-29 13:08:30.140511 +00:00,,1409.00,false,1405
4896,2025-09-28 22:16:58.184518 +00:00,2025-10-05 22:03:23.184518 +00:00,1028.00,true,1405
4897,2025-09-27 22:40:47.628209 +00:00,2025-09-30 20:41:41.628209 +00:00,14922.00,true,1405
4898,2025-10-04 21:34:44.999348 +00:00,,2389.00,false,1405
4899,2014-01-27 09:32:03.362457 +00:00,2014-01-27 09:41:11.362457 +00:00,26154.00,true,1406
4900,2022-03-16 20:55:45.611428 +00:00,2022-03-22 04:54:48.611428 +00:00,2626.00,true,1406
4901,2021-11-01 11:36:52.295867 +00:00,2021-11-09 02:34:53.295867 +00:00,20494.00,true,1406
4902,2019-08-27 09:15:26.483463 +00:00,2019-08-27 09:16:28.483463 +00:00,12159.00,true,1407
4903,2010-01-04 19:56:37.420109 +00:00,2010-01-04 20:01:20.420109 +00:00,55917.00,true,1408
4904,2025-08-12 00:49:18.779001 +00:00,2025-08-12 01:02:26.779001 +00:00,41999.00,true,1409
4905,2023-05-06 06:12:42.140532 +00:00,2023-05-06 06:17:29.140532 +00:00,21286.00,true,1410
4906,2024-02-08 00:25:24.996597 +00:00,2024-02-14 11:46:50.996597 +00:00,32822.00,true,1410
4907,2023-09-03 23:25:13.716145 +00:00,2023-09-07 21:50:14.716145 +00:00,13254.00,true,1410
4908,2024-10-30 07:40:02.442436 +00:00,2024-11-01 21:04:43.442436 +00:00,4708.00,true,1410
4909,2010-04-02 01:49:13.007132 +00:00,2010-04-02 01:50:55.007132 +00:00,1629.00,true,1411
4910,2021-12-23 14:49:08.525157 +00:00,2021-12-24 21:29:56.525157 +00:00,124.00,true,1411
4911,2014-11-16 02:45:53.027289 +00:00,,471.00,false,1411
4912,2024-03-15 00:38:52.838127 +00:00,2024-03-15 10:54:21.838127 +00:00,1430.00,true,1411
4913,2015-09-14 19:23:09.890707 +00:00,2015-09-21 17:34:35.890707 +00:00,618.00,true,1411
4914,2021-07-21 18:04:55.231041 +00:00,2021-07-21 18:08:00.231041 +00:00,3733.00,true,1412
4915,2025-07-16 06:29:27.412451 +00:00,2025-07-25 16:22:32.412451 +00:00,4752.00,true,1412
4916,2025-01-21 11:18:06.782856 +00:00,2025-01-30 02:27:09.782856 +00:00,6911.00,true,1412
4917,2023-06-22 09:27:31.372721 +00:00,2023-07-02 06:30:24.372721 +00:00,2437.00,true,1412
4918,2025-10-04 05:44:39.069195 +00:00,,784.00,false,1412
4919,2025-05-29 13:48:18.601041 +00:00,2025-06-03 16:07:14.601041 +00:00,15085.00,true,1412
4920,2025-07-08 03:00:39.132316 +00:00,2025-07-08 03:10:27.132316 +00:00,1303.00,true,1413
4921,2025-07-09 21:08:03.597456 +00:00,,951.00,false,1413
4922,2025-07-28 14:45:10.024225 +00:00,2025-08-03 06:07:55.024225 +00:00,181.00,true,1413
4923,2025-07-18 19:58:41.439506 +00:00,2025-07-23 17:03:46.439506 +00:00,2509.00,true,1413
4924,2025-09-29 12:45:57.518398 +00:00,,342.00,false,1413
4925,2019-06-30 21:33:14.440847 +00:00,2019-06-30 21:42:18.440847 +00:00,21361.00,true,1414
4926,2025-06-14 21:42:51.899738 +00:00,,19264.00,false,1414
4927,2015-06-08 23:40:08.174531 +00:00,2015-06-08 23:53:09.174531 +00:00,961.00,true,1415
4928,2022-05-22 10:17:25.055950 +00:00,2022-05-27 08:09:35.055950 +00:00,825.00,true,1415
4929,2020-02-27 20:22:31.369899 +00:00,2020-03-05 00:17:29.369899 +00:00,423.00,true,1415
4930,2015-06-18 19:16:00.728855 +00:00,2015-06-26 05:37:15.728855 +00:00,2424.00,true,1415
4931,2015-06-22 17:03:00.524884 +00:00,,1484.00,false,1415
4932,2018-04-05 17:18:34.694018 +00:00,2018-04-05 17:33:52.694018 +00:00,3975.00,true,1416
4933,2020-01-04 22:41:38.248994 +00:00,2020-01-15 01:33:51.248994 +00:00,1628.00,true,1416
4934,2024-01-02 19:37:09.538574 +00:00,2024-01-10 14:38:28.538574 +00:00,1831.00,true,1416
4935,2025-05-18 04:06:38.806371 +00:00,2025-05-24 04:58:43.806371 +00:00,3786.00,true,1416
\.
