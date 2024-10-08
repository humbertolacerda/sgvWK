PGDMP  7                 	    |            wk_tech    16.4    16.4 (    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    24588    wk_tech    DATABASE     ~   CREATE DATABASE wk_tech WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Portuguese_Brazil.1252';
    DROP DATABASE wk_tech;
                postgres    false            �            1259    24630    tbl_wk_clientes    TABLE     �   CREATE TABLE public.tbl_wk_clientes (
    id integer NOT NULL,
    nome character varying(75) NOT NULL,
    cidade character varying(30) NOT NULL,
    uf character varying(2) NOT NULL
);
 #   DROP TABLE public.tbl_wk_clientes;
       public         heap    postgres    false            �            1259    24667    tbl_wk_clientes_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tbl_wk_clientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.tbl_wk_clientes_id_seq;
       public          postgres    false    215            �           0    0    tbl_wk_clientes_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.tbl_wk_clientes_id_seq OWNED BY public.tbl_wk_clientes.id;
          public          postgres    false    222            �            1259    24654    tbl_wk_itens_pedido    TABLE        CREATE TABLE public.tbl_wk_itens_pedido (
    id integer NOT NULL,
    pedido_id integer NOT NULL,
    produto_id integer NOT NULL,
    quantidade numeric(12,3) NOT NULL,
    valor_unitario numeric(12,2) NOT NULL,
    valor_total numeric(12,2) NOT NULL
);
 '   DROP TABLE public.tbl_wk_itens_pedido;
       public         heap    postgres    false            �            1259    24653    tbl_wk_itens_pedido_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tbl_wk_itens_pedido_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.tbl_wk_itens_pedido_id_seq;
       public          postgres    false    219            �           0    0    tbl_wk_itens_pedido_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.tbl_wk_itens_pedido_id_seq OWNED BY public.tbl_wk_itens_pedido.id;
          public          postgres    false    218            �            1259    24661    tbl_wk_pedido    TABLE     �   CREATE TABLE public.tbl_wk_pedido (
    id integer NOT NULL,
    cliente_id integer NOT NULL,
    data_emissao date NOT NULL,
    valor_total numeric(12,2) NOT NULL
);
 !   DROP TABLE public.tbl_wk_pedido;
       public         heap    postgres    false            �            1259    24660    tbl_wk_pedido_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tbl_wk_pedido_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.tbl_wk_pedido_id_seq;
       public          postgres    false    221            �           0    0    tbl_wk_pedido_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.tbl_wk_pedido_id_seq OWNED BY public.tbl_wk_pedido.id;
          public          postgres    false    220            �            1259    24645    tbl_wk_produtos    TABLE     �   CREATE TABLE public.tbl_wk_produtos (
    codigo integer NOT NULL,
    descricao character varying(120) NOT NULL,
    preco numeric(12,2) NOT NULL,
    quantidade numeric(12,3) NOT NULL
);
 #   DROP TABLE public.tbl_wk_produtos;
       public         heap    postgres    false            �            1259    24644    tbl_wk_produtos_codigo_seq    SEQUENCE     �   CREATE SEQUENCE public.tbl_wk_produtos_codigo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.tbl_wk_produtos_codigo_seq;
       public          postgres    false    217            �           0    0    tbl_wk_produtos_codigo_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.tbl_wk_produtos_codigo_seq OWNED BY public.tbl_wk_produtos.codigo;
          public          postgres    false    216            �            1259    24707    tbl_wk_provisorio    TABLE     .  CREATE TABLE public.tbl_wk_provisorio (
    id integer NOT NULL,
    cliente_id integer NOT NULL,
    produto_id integer NOT NULL,
    descricao character varying(120) NOT NULL,
    quantidade numeric(12,3) NOT NULL,
    valor_unitario numeric(12,2) NOT NULL,
    valor_total numeric(12,2) NOT NULL
);
 %   DROP TABLE public.tbl_wk_provisorio;
       public         heap    postgres    false            �            1259    24706    tbl_wk_provisorio_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tbl_wk_provisorio_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.tbl_wk_provisorio_id_seq;
       public          postgres    false    224            �           0    0    tbl_wk_provisorio_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.tbl_wk_provisorio_id_seq OWNED BY public.tbl_wk_provisorio.id;
          public          postgres    false    223            .           2604    24668    tbl_wk_clientes id    DEFAULT     x   ALTER TABLE ONLY public.tbl_wk_clientes ALTER COLUMN id SET DEFAULT nextval('public.tbl_wk_clientes_id_seq'::regclass);
 A   ALTER TABLE public.tbl_wk_clientes ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    222    215            0           2604    24657    tbl_wk_itens_pedido id    DEFAULT     �   ALTER TABLE ONLY public.tbl_wk_itens_pedido ALTER COLUMN id SET DEFAULT nextval('public.tbl_wk_itens_pedido_id_seq'::regclass);
 E   ALTER TABLE public.tbl_wk_itens_pedido ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    219    218    219            1           2604    24664    tbl_wk_pedido id    DEFAULT     t   ALTER TABLE ONLY public.tbl_wk_pedido ALTER COLUMN id SET DEFAULT nextval('public.tbl_wk_pedido_id_seq'::regclass);
 ?   ALTER TABLE public.tbl_wk_pedido ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    221    220    221            /           2604    24648    tbl_wk_produtos codigo    DEFAULT     �   ALTER TABLE ONLY public.tbl_wk_produtos ALTER COLUMN codigo SET DEFAULT nextval('public.tbl_wk_produtos_codigo_seq'::regclass);
 E   ALTER TABLE public.tbl_wk_produtos ALTER COLUMN codigo DROP DEFAULT;
       public          postgres    false    217    216    217            2           2604    24710    tbl_wk_provisorio id    DEFAULT     |   ALTER TABLE ONLY public.tbl_wk_provisorio ALTER COLUMN id SET DEFAULT nextval('public.tbl_wk_provisorio_id_seq'::regclass);
 C   ALTER TABLE public.tbl_wk_provisorio ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    223    224    224            �          0    24630    tbl_wk_clientes 
   TABLE DATA           ?   COPY public.tbl_wk_clientes (id, nome, cidade, uf) FROM stdin;
    public          postgres    false    215   /       �          0    24654    tbl_wk_itens_pedido 
   TABLE DATA           q   COPY public.tbl_wk_itens_pedido (id, pedido_id, produto_id, quantidade, valor_unitario, valor_total) FROM stdin;
    public          postgres    false    219   �/       �          0    24661    tbl_wk_pedido 
   TABLE DATA           R   COPY public.tbl_wk_pedido (id, cliente_id, data_emissao, valor_total) FROM stdin;
    public          postgres    false    221   00       �          0    24645    tbl_wk_produtos 
   TABLE DATA           O   COPY public.tbl_wk_produtos (codigo, descricao, preco, quantidade) FROM stdin;
    public          postgres    false    217   h0       �          0    24707    tbl_wk_provisorio 
   TABLE DATA           {   COPY public.tbl_wk_provisorio (id, cliente_id, produto_id, descricao, quantidade, valor_unitario, valor_total) FROM stdin;
    public          postgres    false    224   *2       �           0    0    tbl_wk_clientes_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.tbl_wk_clientes_id_seq', 12, true);
          public          postgres    false    222            �           0    0    tbl_wk_itens_pedido_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.tbl_wk_itens_pedido_id_seq', 4, true);
          public          postgres    false    218            �           0    0    tbl_wk_pedido_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.tbl_wk_pedido_id_seq', 5, true);
          public          postgres    false    220            �           0    0    tbl_wk_produtos_codigo_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.tbl_wk_produtos_codigo_seq', 20, true);
          public          postgres    false    216            �           0    0    tbl_wk_provisorio_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.tbl_wk_provisorio_id_seq', 55, true);
          public          postgres    false    223            4           2606    24673 $   tbl_wk_clientes tbl_wk_clientes_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.tbl_wk_clientes
    ADD CONSTRAINT tbl_wk_clientes_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.tbl_wk_clientes DROP CONSTRAINT tbl_wk_clientes_pkey;
       public            postgres    false    215            8           2606    24659 ,   tbl_wk_itens_pedido tbl_wk_itens_pedido_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.tbl_wk_itens_pedido
    ADD CONSTRAINT tbl_wk_itens_pedido_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.tbl_wk_itens_pedido DROP CONSTRAINT tbl_wk_itens_pedido_pkey;
       public            postgres    false    219            :           2606    24666     tbl_wk_pedido tbl_wk_pedido_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.tbl_wk_pedido
    ADD CONSTRAINT tbl_wk_pedido_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.tbl_wk_pedido DROP CONSTRAINT tbl_wk_pedido_pkey;
       public            postgres    false    221            6           2606    24652 $   tbl_wk_produtos tbl_wk_produtos_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.tbl_wk_produtos
    ADD CONSTRAINT tbl_wk_produtos_pkey PRIMARY KEY (codigo);
 N   ALTER TABLE ONLY public.tbl_wk_produtos DROP CONSTRAINT tbl_wk_produtos_pkey;
       public            postgres    false    217            <           2606    24712 (   tbl_wk_provisorio tbl_wk_provisorio_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.tbl_wk_provisorio
    ADD CONSTRAINT tbl_wk_provisorio_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.tbl_wk_provisorio DROP CONSTRAINT tbl_wk_provisorio_pkey;
       public            postgres    false    224            =           2606    24675    tbl_wk_pedido fk_pedido_cliente    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_wk_pedido
    ADD CONSTRAINT fk_pedido_cliente FOREIGN KEY (cliente_id) REFERENCES public.tbl_wk_clientes(id) NOT VALID;
 I   ALTER TABLE ONLY public.tbl_wk_pedido DROP CONSTRAINT fk_pedido_cliente;
       public          postgres    false    221    4660    215            �   �   x���=n1F��)�Q�_	)��
ň��va�ؒ��"�I�>7؋eJCG:k���7��8}E�Z�"�-r��ҏ6�F(��#�6Z-h����`���u}q�zke��g��6i�>�V���ciﲨ�]���_7���<ݔ�����A�>���>z�܋�/c���w���j��>����C�n��u��|����莠N�ÝR�qA�}      �   =   x�u��  �0L�U���sX}kx@�\è�I��T3nӋL�ei]��!�:��2��*�      �   (   x�3�44�4202�54�5��4533�31�2�!���� �(�      �   �  x���Mn�0���S�	�")j�q[��f��D�m&�(�r��=A�E�s�b�vm�� �}�q~(!�w��hA*�����(�baa����;�:�1bK�9N�Ĝp%h[�X��γ��6�~���.��UڙrpC���ߏ)��P���h�bZ��Գ��%�>�e�{}
t`W�q�P&�<��`��#��a�Sܦ��&4�W?����)�l}��?��)��W���p�!OT�ʋVr�fz�%���S�[�D�^��53��5��'ȼ����Ɓ�0���#O�<=(�>$�b�J�tg��m���(+��pk|��6LO}h"��ǻ��C�V��{Լ[W����7�H~3\�9U�F#��t���	謹o��gc�:@�Y*_$\w���nO����q�t(U5�X��Q~�{�����i�_�b���;�      �   R   x�35�44�4���4�4�300�4�00 28M��4��)H�)�[bQf^F�BJ�Bnb^Jf~r"�X���������W� �Os     