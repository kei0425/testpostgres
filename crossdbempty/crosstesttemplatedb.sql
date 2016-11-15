--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: isnumeric(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnumeric(text) RETURNS boolean
    LANGUAGE sql
    AS $_$
SELECT $1 ~ '^[0-9]+$'
$_$;


ALTER FUNCTION public.isnumeric(text) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: t_logical_expression_params; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_logical_expression_params (
    logic_id integer NOT NULL,
    item_no integer NOT NULL,
    expr_id integer,
    child_logic_id integer
);


ALTER TABLE public.t_logical_expression_params OWNER TO postgres;

--
-- Name: t_logic_expr_params_list(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION t_logic_expr_params_list(_logic_id integer) RETURNS SETOF t_logical_expression_params
    LANGUAGE plpgsql
    AS $$
declare
    rec_p record;
    rec_c record;
begin
    for rec_p in select * from t_logical_expression_params where logic_id = _logic_id loop
        return next rec_p;
        for rec_c in select * from t_logic_expr_params_list( rec_p.child_logic_id ) loop
            return next rec_c;
        end loop;
    end loop;
    return;
end;
$$;


ALTER FUNCTION public.t_logic_expr_params_list(_logic_id integer) OWNER TO postgres;

--
-- Name: define_average; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE define_average (
    average_id integer NOT NULL,
    child_category_id integer NOT NULL,
    weight double precision
);


ALTER TABLE public.define_average OWNER TO postgres;

--
-- Name: define_average_average_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE define_average_average_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.define_average_average_id_seq OWNER TO postgres;

--
-- Name: define_average_average_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE define_average_average_id_seq OWNED BY define_average.average_id;


--
-- Name: define_di; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE define_di (
    di_id integer NOT NULL,
    child_category_id integer NOT NULL,
    plus_minus integer
);


ALTER TABLE public.define_di OWNER TO postgres;

--
-- Name: define_di_di_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE define_di_di_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.define_di_di_id_seq OWNER TO postgres;

--
-- Name: define_di_di_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE define_di_di_id_seq OWNED BY define_di.di_id;


--
-- Name: m_logical_type; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE m_logical_type (
    logical_type_id integer NOT NULL,
    logical_type text
);


ALTER TABLE public.m_logical_type OWNER TO postgres;

--
-- Name: m_logical_type_logical_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE m_logical_type_logical_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.m_logical_type_logical_type_id_seq OWNER TO postgres;

--
-- Name: m_logical_type_logical_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE m_logical_type_logical_type_id_seq OWNED BY m_logical_type.logical_type_id;


--
-- Name: m_operator_list; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE m_operator_list (
    id integer NOT NULL,
    word text NOT NULL,
    answer_type character varying(20) NOT NULL,
    multiple_flag boolean NOT NULL
);


ALTER TABLE public.m_operator_list OWNER TO postgres;

--
-- Name: m_operator_list_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE m_operator_list_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.m_operator_list_id_seq OWNER TO postgres;

--
-- Name: m_operator_list_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE m_operator_list_id_seq OWNED BY m_operator_list.id;


SET default_with_oids = true;

--
-- Name: pd_variable; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE pd_variable (
    id integer NOT NULL,
    enq_id integer NOT NULL,
    raw_flag boolean DEFAULT false NOT NULL,
    variable_name character varying(64) NOT NULL,
    type character varying(16) NOT NULL,
    length character varying(16),
    range text DEFAULT ''::text,
    gousei boolean DEFAULT false,
    var_order integer DEFAULT 0,
    gousei_type smallint,
    gousei_query text
);


ALTER TABLE public.pd_variable OWNER TO postgres;

--
-- Name: pd_variable_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE pd_variable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pd_variable_id_seq OWNER TO postgres;

--
-- Name: pd_variable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE pd_variable_id_seq OWNED BY pd_variable.id;


SET default_with_oids = false;

--
-- Name: sessions2; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE sessions2 (
    session_id character(128) NOT NULL,
    atime timestamp without time zone DEFAULT now() NOT NULL,
    data text
);


ALTER TABLE public.sessions2 OWNER TO postgres;

SET default_with_oids = true;

--
-- Name: t_category; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_category (
    id integer NOT NULL,
    enq_id integer NOT NULL,
    variable_name character varying(128) NOT NULL,
    entry_type integer NOT NULL,
    category_order integer NOT NULL,
    category_value text NOT NULL,
    category_type integer,
    row_flag boolean,
    col_flag boolean,
    category_label character varying(1000),
    detail text,
    category_label_org character varying(1000),
    label_edit_flag boolean
);


ALTER TABLE public.t_category OWNER TO postgres;

--
-- Name: t_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE t_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_category_id_seq OWNER TO postgres;

--
-- Name: t_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE t_category_id_seq OWNED BY t_category.id;


SET default_with_oids = false;

--
-- Name: t_column_sort; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_column_sort (
    enq_id integer NOT NULL,
    customize_id integer DEFAULT 0 NOT NULL,
    variable_name character varying(128) NOT NULL,
    direction integer DEFAULT 0 NOT NULL,
    freeze_category text
);


ALTER TABLE public.t_column_sort OWNER TO postgres;

--
-- Name: t_combination; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_combination (
    combination_id integer NOT NULL
);


ALTER TABLE public.t_combination OWNER TO postgres;

--
-- Name: t_combination_category; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_combination_category (
    combination_id integer NOT NULL,
    combination_category_value integer NOT NULL,
    logic_id integer NOT NULL
);


ALTER TABLE public.t_combination_category OWNER TO postgres;

--
-- Name: t_combination_combination_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE t_combination_combination_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_combination_combination_id_seq OWNER TO postgres;

--
-- Name: t_combination_combination_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE t_combination_combination_id_seq OWNED BY t_combination.combination_id;


--
-- Name: t_combination_variable; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_combination_variable (
    combination_id integer NOT NULL,
    enq_id integer NOT NULL,
    variable_name character varying(64) NOT NULL
);


ALTER TABLE public.t_combination_variable OWNER TO postgres;

--
-- Name: t_convined; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_convined (
    enq_id integer NOT NULL,
    convined text
);


ALTER TABLE public.t_convined OWNER TO postgres;

--
-- Name: t_customize; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_customize (
    customize_id integer NOT NULL,
    enq_id integer,
    owner_id integer,
    customize_name character varying(255),
    share_flg boolean DEFAULT false,
    publish_flg boolean DEFAULT false
);


ALTER TABLE public.t_customize OWNER TO postgres;

--
-- Name: t_customize_customize_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE t_customize_customize_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_customize_customize_id_seq OWNER TO postgres;

--
-- Name: t_customize_customize_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE t_customize_customize_id_seq OWNED BY t_customize.customize_id;


--
-- Name: t_export; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_export (
    export_id integer NOT NULL,
    export_set_id integer NOT NULL,
    make_date timestamp without time zone,
    real_per integer NOT NULL,
    score_orientation integer NOT NULL,
    head_variable_names text NOT NULL,
    side_variable_names text NOT NULL,
    side_type integer NOT NULL,
    filter_vname text,
    filter_vname_value text,
    filter_values text,
    highlight_type integer
);


ALTER TABLE public.t_export OWNER TO postgres;

--
-- Name: t_export_export_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE t_export_export_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_export_export_id_seq OWNER TO postgres;

--
-- Name: t_export_export_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE t_export_export_id_seq OWNED BY t_export.export_id;


--
-- Name: t_export_gt_matrix; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_export_gt_matrix (
    export_id integer,
    gt_matrix_id integer
);


ALTER TABLE public.t_export_gt_matrix OWNER TO postgres;

--
-- Name: t_export_set; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_export_set (
    export_set_id integer NOT NULL,
    enq_id integer NOT NULL,
    set_name text NOT NULL,
    customize_id integer DEFAULT 0
);


ALTER TABLE public.t_export_set OWNER TO postgres;

--
-- Name: t_export_set_export_set_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE t_export_set_export_set_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_export_set_export_set_id_seq OWNER TO postgres;

--
-- Name: t_export_set_export_set_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE t_export_set_export_set_id_seq OWNED BY t_export_set.export_set_id;


--
-- Name: t_expression; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_expression (
    expr_id integer NOT NULL,
    enq_id integer NOT NULL,
    operator_id integer NOT NULL,
    varname character varying(64) NOT NULL
);


ALTER TABLE public.t_expression OWNER TO postgres;

--
-- Name: t_expression_expr_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE t_expression_expr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_expression_expr_id_seq OWNER TO postgres;

--
-- Name: t_expression_expr_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE t_expression_expr_id_seq OWNED BY t_expression.expr_id;


--
-- Name: t_expression_params; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_expression_params (
    expr_id integer NOT NULL,
    item_no integer NOT NULL,
    data character varying(64) NOT NULL
);


ALTER TABLE public.t_expression_params OWNER TO postgres;

--
-- Name: t_filter; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_filter (
    filter_id integer NOT NULL,
    enq_id integer NOT NULL,
    logic_id integer NOT NULL,
    filter_name character varying(1000),
    del_flg boolean DEFAULT false,
    customize_id integer DEFAULT 0
);


ALTER TABLE public.t_filter OWNER TO postgres;

--
-- Name: t_filter_filter_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE t_filter_filter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_filter_filter_id_seq OWNER TO postgres;

--
-- Name: t_filter_filter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE t_filter_filter_id_seq OWNED BY t_filter.filter_id;


--
-- Name: t_filter_varname; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_filter_varname (
    filter_id integer NOT NULL,
    enq_id integer NOT NULL,
    varname character varying(64) NOT NULL
);


ALTER TABLE public.t_filter_varname OWNER TO postgres;

--
-- Name: t_gousei_order; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_gousei_order (
    id integer NOT NULL,
    enq_id integer,
    customize_id integer,
    variable_name character varying(64),
    pre_variable_name character varying(64)
);


ALTER TABLE public.t_gousei_order OWNER TO postgres;

--
-- Name: TABLE t_gousei_order; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE t_gousei_order IS '合成変数順番管理テーブル';


--
-- Name: COLUMN t_gousei_order.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN t_gousei_order.id IS 'ID';


--
-- Name: COLUMN t_gousei_order.enq_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN t_gousei_order.enq_id IS 'アンケートNO';


--
-- Name: COLUMN t_gousei_order.customize_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN t_gousei_order.customize_id IS '集計セットNO';


--
-- Name: COLUMN t_gousei_order.pre_variable_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN t_gousei_order.pre_variable_name IS '前の変数名（null:先頭)';


--
-- Name: t_gousei_order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE t_gousei_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_gousei_order_id_seq OWNER TO postgres;

--
-- Name: t_gousei_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE t_gousei_order_id_seq OWNED BY t_gousei_order.id;


--
-- Name: t_gt_matrix; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_gt_matrix (
    gt_matrix_id integer NOT NULL,
    enq_id integer NOT NULL,
    customize_id integer DEFAULT 0,
    gt_matrix_order integer NOT NULL,
    gt_matrix_title character varying(1000) NOT NULL,
    variable_names text NOT NULL
);


ALTER TABLE public.t_gt_matrix OWNER TO postgres;

--
-- Name: t_gt_matrix_gt_matrix_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE t_gt_matrix_gt_matrix_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_gt_matrix_gt_matrix_id_seq OWNER TO postgres;

--
-- Name: t_gt_matrix_gt_matrix_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE t_gt_matrix_gt_matrix_id_seq OWNED BY t_gt_matrix.gt_matrix_id;


--
-- Name: t_job; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_job (
    id integer NOT NULL,
    server_name character varying(50),
    directory_path character varying(255),
    dat_name character varying(50),
    w_path character varying(1000),
    end_date character varying(20),
    survey_name character varying(100),
    job_no character varying(50),
    sample_count integer,
    need_auth boolean DEFAULT false,
    use_customize boolean DEFAULT true,
    last_upload_date timestamp without time zone
);


ALTER TABLE public.t_job OWNER TO postgres;

--
-- Name: t_job_client_customize; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_job_client_customize (
    enq_id integer NOT NULL,
    client_id integer NOT NULL,
    customize_id integer
);


ALTER TABLE public.t_job_client_customize OWNER TO postgres;

--
-- Name: t_job_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE t_job_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_job_id_seq OWNER TO postgres;

--
-- Name: t_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE t_job_id_seq OWNED BY t_job.id;


--
-- Name: t_job_user; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_job_user (
    enq_id integer NOT NULL,
    user_id character varying(50) NOT NULL,
    expire_date date
);


ALTER TABLE public.t_job_user OWNER TO postgres;

--
-- Name: t_job_weight; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_job_weight (
    enq_id integer NOT NULL,
    weight_id integer NOT NULL,
    customize_id integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.t_job_weight OWNER TO postgres;

--
-- Name: t_logical_expression; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_logical_expression (
    logic_id integer NOT NULL,
    enq_id integer,
    logic_operator_id integer
);


ALTER TABLE public.t_logical_expression OWNER TO postgres;

--
-- Name: t_logical_expression_logic_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE t_logical_expression_logic_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_logical_expression_logic_id_seq OWNER TO postgres;

--
-- Name: t_logical_expression_logic_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE t_logical_expression_logic_id_seq OWNED BY t_logical_expression.logic_id;


--
-- Name: t_maintenance; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_maintenance (
    mainte_id integer NOT NULL,
    mainte_day integer DEFAULT 0,
    mainte_start_time character varying(5),
    mainte_end_time character varying(5)
);


ALTER TABLE public.t_maintenance OWNER TO postgres;

--
-- Name: t_maintenance_mainte_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE t_maintenance_mainte_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_maintenance_mainte_id_seq OWNER TO postgres;

--
-- Name: t_maintenance_mainte_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE t_maintenance_mainte_id_seq OWNED BY t_maintenance.mainte_id;


--
-- Name: t_numeric_categorize; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_numeric_categorize (
    numeric_categorize_id integer NOT NULL,
    enq_id integer NOT NULL,
    variable_name character varying(64) NOT NULL,
    numeric_variable_name character varying(64) NOT NULL,
    categorize_type integer NOT NULL
);


ALTER TABLE public.t_numeric_categorize OWNER TO postgres;

--
-- Name: t_numeric_categorize_limits; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_numeric_categorize_limits (
    numeric_categorize_id integer NOT NULL,
    category_value text NOT NULL,
    category_limit text NOT NULL
);


ALTER TABLE public.t_numeric_categorize_limits OWNER TO postgres;

--
-- Name: t_numeric_categorize_numeric_categorize_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE t_numeric_categorize_numeric_categorize_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_numeric_categorize_numeric_categorize_id_seq OWNER TO postgres;

--
-- Name: t_numeric_categorize_numeric_categorize_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE t_numeric_categorize_numeric_categorize_id_seq OWNED BY t_numeric_categorize.numeric_categorize_id;


--
-- Name: t_numeric_divide_by; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_numeric_divide_by (
    enq_id integer NOT NULL,
    customize_id integer NOT NULL,
    varname character varying NOT NULL,
    divide_by integer,
    decimal_places integer
);


ALTER TABLE public.t_numeric_divide_by OWNER TO postgres;

--
-- Name: t_table_side; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_table_side (
    side_id integer NOT NULL,
    enq_id integer NOT NULL,
    side_order integer NOT NULL,
    variable_names text NOT NULL,
    side_name text NOT NULL,
    customize_id integer DEFAULT 0
);


ALTER TABLE public.t_table_side OWNER TO postgres;

--
-- Name: t_table_side_side_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE t_table_side_side_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_table_side_side_id_seq OWNER TO postgres;

--
-- Name: t_table_side_side_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE t_table_side_side_id_seq OWNED BY t_table_side.side_id;


--
-- Name: t_token; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_token (
    id integer NOT NULL,
    enq_id integer NOT NULL,
    token character varying(255) NOT NULL,
    m_clients_id integer
);


ALTER TABLE public.t_token OWNER TO postgres;

--
-- Name: t_token_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE t_token_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_token_id_seq OWNER TO postgres;

--
-- Name: t_token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE t_token_id_seq OWNED BY t_token.id;


--
-- Name: t_user; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_user (
    user_id character varying(50) NOT NULL,
    wave_no integer,
    del_flg boolean
);


ALTER TABLE public.t_user OWNER TO postgres;

--
-- Name: t_weight; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_weight (
    weight_id integer NOT NULL,
    enq_id integer,
    variable_name character varying(255),
    description character varying,
    weight_type integer DEFAULT 2,
    target_total integer,
    customize_id integer DEFAULT 0
);


ALTER TABLE public.t_weight OWNER TO postgres;

--
-- Name: t_weight_values; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_weight_values (
    weight_id integer NOT NULL,
    category_value character varying(255) NOT NULL,
    weight_value character varying,
    weight_count character varying,
    weight_ratio character varying
);


ALTER TABLE public.t_weight_values OWNER TO postgres;

--
-- Name: t_weight_weight_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE t_weight_weight_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_weight_weight_id_seq OWNER TO postgres;

--
-- Name: t_weight_weight_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE t_weight_weight_id_seq OWNED BY t_weight.weight_id;


--
-- Name: average_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY define_average ALTER COLUMN average_id SET DEFAULT nextval('define_average_average_id_seq'::regclass);


--
-- Name: di_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY define_di ALTER COLUMN di_id SET DEFAULT nextval('define_di_di_id_seq'::regclass);


--
-- Name: logical_type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY m_logical_type ALTER COLUMN logical_type_id SET DEFAULT nextval('m_logical_type_logical_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY m_operator_list ALTER COLUMN id SET DEFAULT nextval('m_operator_list_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pd_variable ALTER COLUMN id SET DEFAULT nextval('pd_variable_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY t_category ALTER COLUMN id SET DEFAULT nextval('t_category_id_seq'::regclass);


--
-- Name: combination_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY t_combination ALTER COLUMN combination_id SET DEFAULT nextval('t_combination_combination_id_seq'::regclass);


--
-- Name: customize_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY t_customize ALTER COLUMN customize_id SET DEFAULT nextval('t_customize_customize_id_seq'::regclass);


--
-- Name: export_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY t_export ALTER COLUMN export_id SET DEFAULT nextval('t_export_export_id_seq'::regclass);


--
-- Name: export_set_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY t_export_set ALTER COLUMN export_set_id SET DEFAULT nextval('t_export_set_export_set_id_seq'::regclass);


--
-- Name: expr_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY t_expression ALTER COLUMN expr_id SET DEFAULT nextval('t_expression_expr_id_seq'::regclass);


--
-- Name: filter_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY t_filter ALTER COLUMN filter_id SET DEFAULT nextval('t_filter_filter_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY t_gousei_order ALTER COLUMN id SET DEFAULT nextval('t_gousei_order_id_seq'::regclass);


--
-- Name: gt_matrix_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY t_gt_matrix ALTER COLUMN gt_matrix_id SET DEFAULT nextval('t_gt_matrix_gt_matrix_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY t_job ALTER COLUMN id SET DEFAULT nextval('t_job_id_seq'::regclass);


--
-- Name: logic_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY t_logical_expression ALTER COLUMN logic_id SET DEFAULT nextval('t_logical_expression_logic_id_seq'::regclass);


--
-- Name: mainte_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY t_maintenance ALTER COLUMN mainte_id SET DEFAULT nextval('t_maintenance_mainte_id_seq'::regclass);


--
-- Name: numeric_categorize_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY t_numeric_categorize ALTER COLUMN numeric_categorize_id SET DEFAULT nextval('t_numeric_categorize_numeric_categorize_id_seq'::regclass);


--
-- Name: side_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY t_table_side ALTER COLUMN side_id SET DEFAULT nextval('t_table_side_side_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY t_token ALTER COLUMN id SET DEFAULT nextval('t_token_id_seq'::regclass);


--
-- Name: weight_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY t_weight ALTER COLUMN weight_id SET DEFAULT nextval('t_weight_weight_id_seq'::regclass);


--
-- Data for Name: define_average; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY define_average (average_id, child_category_id, weight) FROM stdin;
\.


--
-- Name: define_average_average_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('define_average_average_id_seq', 4386, true);


--
-- Data for Name: define_di; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY define_di (di_id, child_category_id, plus_minus) FROM stdin;
\.


--
-- Name: define_di_di_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('define_di_di_id_seq', 1510, true);


--
-- Data for Name: m_logical_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY m_logical_type (logical_type_id, logical_type) FROM stdin;
1	Root
2	Leaf
3	And
4	Or
5	Not
\.


--
-- Name: m_logical_type_logical_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('m_logical_type_logical_type_id_seq', 5, true);


--
-- Data for Name: m_operator_list; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY m_operator_list (id, word, answer_type, multiple_flag) FROM stdin;
1	を1つでも含む	checkbox	t
2	を1つも含まない	checkbox	t
3	を全て含む	checkbox	t
4	と等しい、過不足が無い	checkbox	t
5	のいずれかと等しい	radio	t
6	のいずれとも等しくない	radio	t
7	より大きい	radio	f
8	より小さい	radio	f
9	以上	radio	f
10	以下	radio	f
11	の数値以上	numeric	f
12	の数値以下	numeric	f
13	の数値より大きい	numeric	f
14	の数値より小さい	numeric	f
15	の数値と等しい	numeric	f
16	の数値と等しくない	numeric	f
17	の数値以上　または　無回答	numeric	f
18	の数値以下　または　無回答	numeric	f
19	の数値より大きい　または　無回答	numeric	f
20	の数値より小さい　または　無回答	numeric	f
21	の文言と完全一致	text	f
22	の文言と前方一致	text	f
23	の文言と部分一致	text	f
24	の文言と完全一致しない	text	f
25	の文言と前方一致しない	text	f
26	の文言と部分一致しない	text	f
\.


--
-- Name: m_operator_list_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('m_operator_list_id_seq', 26, true);


--
-- Data for Name: pd_variable; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY pd_variable (id, enq_id, raw_flag, variable_name, type, length, range, gousei, var_order, gousei_type, gousei_query) FROM stdin;
\.


--
-- Name: pd_variable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('pd_variable_id_seq', 469672, true);


--
-- Data for Name: sessions2; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY sessions2 (session_id, atime, data) FROM stdin;
\.


--
-- Data for Name: t_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_category (id, enq_id, variable_name, entry_type, category_order, category_value, category_type, row_flag, col_flag, category_label, detail, category_label_org, label_edit_flag) FROM stdin;
\.


--
-- Name: t_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('t_category_id_seq', 2078062, true);


--
-- Data for Name: t_column_sort; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_column_sort (enq_id, customize_id, variable_name, direction, freeze_category) FROM stdin;
\.


--
-- Data for Name: t_combination; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_combination (combination_id) FROM stdin;
\.


--
-- Data for Name: t_combination_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_combination_category (combination_id, combination_category_value, logic_id) FROM stdin;
\.


--
-- Name: t_combination_combination_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('t_combination_combination_id_seq', 507, true);


--
-- Data for Name: t_combination_variable; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_combination_variable (combination_id, enq_id, variable_name) FROM stdin;
\.


--
-- Data for Name: t_convined; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_convined (enq_id, convined, convined_b) FROM stdin;
\.


--
-- Data for Name: t_customize; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_customize (customize_id, enq_id, owner_id, customize_name, share_flg, publish_flg) FROM stdin;
\.


--
-- Name: t_customize_customize_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('t_customize_customize_id_seq', 319, true);


--
-- Data for Name: t_export; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_export (export_id, export_set_id, make_date, real_per, score_orientation, head_variable_names, side_variable_names, side_type, filter_vname, filter_vname_value, filter_values, highlight_type) FROM stdin;
\.


--
-- Name: t_export_export_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('t_export_export_id_seq', 1695, true);


--
-- Data for Name: t_export_gt_matrix; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_export_gt_matrix (export_id, gt_matrix_id) FROM stdin;
\.


--
-- Data for Name: t_export_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_export_set (export_set_id, enq_id, set_name, customize_id) FROM stdin;
\.


--
-- Name: t_export_set_export_set_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('t_export_set_export_set_id_seq', 1369, true);


--
-- Data for Name: t_expression; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_expression (expr_id, enq_id, operator_id, varname) FROM stdin;
\.


--
-- Name: t_expression_expr_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('t_expression_expr_id_seq', 2063, true);


--
-- Data for Name: t_expression_params; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_expression_params (expr_id, item_no, data) FROM stdin;
\.


--
-- Data for Name: t_filter; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_filter (filter_id, enq_id, logic_id, filter_name, del_flg, customize_id) FROM stdin;
\.


--
-- Name: t_filter_filter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('t_filter_filter_id_seq', 389, true);


--
-- Data for Name: t_filter_varname; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_filter_varname (filter_id, enq_id, varname) FROM stdin;
\.


--
-- Data for Name: t_gousei_order; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_gousei_order (id, enq_id, customize_id, variable_name, pre_variable_name) FROM stdin;
\.


--
-- Name: t_gousei_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('t_gousei_order_id_seq', 1, false);


--
-- Data for Name: t_gt_matrix; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_gt_matrix (gt_matrix_id, enq_id, customize_id, gt_matrix_order, gt_matrix_title, variable_names) FROM stdin;
\.


--
-- Name: t_gt_matrix_gt_matrix_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('t_gt_matrix_gt_matrix_id_seq', 1, false);


--
-- Data for Name: t_job; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_job (id, server_name, directory_path, dat_name, w_path, end_date, survey_name, job_no, sample_count, need_auth, use_customize, last_upload_date) FROM stdin;
\.


--
-- Data for Name: t_job_client_customize; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_job_client_customize (enq_id, client_id, customize_id) FROM stdin;
\.


--
-- Name: t_job_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('t_job_id_seq', 962, true);


--
-- Data for Name: t_job_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_job_user (enq_id, user_id) FROM stdin;
\.


--
-- Data for Name: t_job_weight; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_job_weight (enq_id, weight_id, customize_id) FROM stdin;
\.


--
-- Data for Name: t_logical_expression; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_logical_expression (logic_id, enq_id, logic_operator_id) FROM stdin;
\.


--
-- Name: t_logical_expression_logic_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('t_logical_expression_logic_id_seq', 4136, true);


--
-- Data for Name: t_logical_expression_params; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_logical_expression_params (logic_id, item_no, expr_id, child_logic_id) FROM stdin;
\.


--
-- Data for Name: t_maintenance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_maintenance (mainte_id, mainte_day, mainte_start_time, mainte_end_time) FROM stdin;
\.


--
-- Name: t_maintenance_mainte_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('t_maintenance_mainte_id_seq', 2, true);


--
-- Data for Name: t_numeric_categorize; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_numeric_categorize (numeric_categorize_id, enq_id, variable_name, numeric_variable_name, categorize_type) FROM stdin;
\.


--
-- Data for Name: t_numeric_categorize_limits; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_numeric_categorize_limits (numeric_categorize_id, category_value, category_limit) FROM stdin;
\.


--
-- Name: t_numeric_categorize_numeric_categorize_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('t_numeric_categorize_numeric_categorize_id_seq', 27, true);


--
-- Data for Name: t_numeric_divide_by; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_numeric_divide_by (enq_id, customize_id, varname, divide_by, decimal_places) FROM stdin;
\.


--
-- Data for Name: t_table_side; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_table_side (side_id, enq_id, side_order, variable_names, side_name, customize_id) FROM stdin;
\.


--
-- Name: t_table_side_side_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('t_table_side_side_id_seq', 347, true);


--
-- Data for Name: t_token; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_token (id, enq_id, token, m_clients_id) FROM stdin;
\.


--
-- Name: t_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('t_token_id_seq', 107, true);


--
-- Data for Name: t_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_user (user_id, wave_no, del_flg) FROM stdin;
taihei_kobayashi	1	f
0506	1	f
\.


--
-- Data for Name: t_weight; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_weight (weight_id, enq_id, variable_name, description, weight_type, target_total, customize_id) FROM stdin;
\.


--
-- Data for Name: t_weight_values; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY t_weight_values (weight_id, category_value, weight_value, weight_count, weight_ratio) FROM stdin;
\.


--
-- Name: t_weight_weight_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('t_weight_weight_id_seq', 273, true);


--
-- Name: define_average_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY define_average
    ADD CONSTRAINT define_average_pkey PRIMARY KEY (average_id, child_category_id);


--
-- Name: define_di_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY define_di
    ADD CONSTRAINT define_di_pkey PRIMARY KEY (di_id, child_category_id);


--
-- Name: m_logical_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY m_logical_type
    ADD CONSTRAINT m_logical_type_pkey PRIMARY KEY (logical_type_id);


--
-- Name: m_operator_list_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY m_operator_list
    ADD CONSTRAINT m_operator_list_pkey PRIMARY KEY (id);


--
-- Name: pd_variable_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY pd_variable
    ADD CONSTRAINT pd_variable_uniq PRIMARY KEY (id);


--
-- Name: pk_column_sort; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_column_sort
    ADD CONSTRAINT pk_column_sort PRIMARY KEY (enq_id, customize_id, variable_name);


--
-- Name: pk_expr_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_expression
    ADD CONSTRAINT pk_expr_id PRIMARY KEY (expr_id);


--
-- Name: pk_expr_item; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_expression_params
    ADD CONSTRAINT pk_expr_item PRIMARY KEY (expr_id, item_no);


--
-- Name: pk_filter_varname; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_filter_varname
    ADD CONSTRAINT pk_filter_varname PRIMARY KEY (enq_id, varname);


--
-- Name: pk_gt_matrix_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_gt_matrix
    ADD CONSTRAINT pk_gt_matrix_id PRIMARY KEY (gt_matrix_id);


--
-- Name: pk_logic_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_logical_expression
    ADD CONSTRAINT pk_logic_id PRIMARY KEY (logic_id);


--
-- Name: pk_logic_item; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_logical_expression_params
    ADD CONSTRAINT pk_logic_item PRIMARY KEY (logic_id, item_no);


--
-- Name: pk_session_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sessions2
    ADD CONSTRAINT pk_session_id PRIMARY KEY (session_id);


--
-- Name: pk_t_combination; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_combination
    ADD CONSTRAINT pk_t_combination PRIMARY KEY (combination_id);


--
-- Name: pk_t_combination_category; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_combination_category
    ADD CONSTRAINT pk_t_combination_category PRIMARY KEY (combination_id, logic_id);


--
-- Name: pk_t_combination_variable; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_combination_variable
    ADD CONSTRAINT pk_t_combination_variable PRIMARY KEY (enq_id, variable_name);


--
-- Name: pk_t_convined; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_convined
    ADD CONSTRAINT pk_t_convined PRIMARY KEY (enq_id);


--
-- Name: pk_t_customize; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_customize
    ADD CONSTRAINT pk_t_customize PRIMARY KEY (customize_id);


--
-- Name: pk_t_export; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_export
    ADD CONSTRAINT pk_t_export PRIMARY KEY (export_id);


--
-- Name: pk_t_export_set; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_export_set
    ADD CONSTRAINT pk_t_export_set PRIMARY KEY (export_set_id);


--
-- Name: pk_t_filter; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_filter
    ADD CONSTRAINT pk_t_filter PRIMARY KEY (filter_id);


--
-- Name: pk_t_job; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_job
    ADD CONSTRAINT pk_t_job PRIMARY KEY (id);


--
-- Name: pk_t_job_client_customize; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_job_client_customize
    ADD CONSTRAINT pk_t_job_client_customize PRIMARY KEY (enq_id, client_id);


--
-- Name: pk_t_job_user; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_job_user
    ADD CONSTRAINT pk_t_job_user PRIMARY KEY (enq_id, user_id);


--
-- Name: pk_t_job_weight; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_job_weight
    ADD CONSTRAINT pk_t_job_weight PRIMARY KEY (enq_id, weight_id, customize_id);


--
-- Name: pk_t_maintenance; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_maintenance
    ADD CONSTRAINT pk_t_maintenance PRIMARY KEY (mainte_id);


--
-- Name: pk_t_numeric_categorize; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_numeric_categorize
    ADD CONSTRAINT pk_t_numeric_categorize PRIMARY KEY (numeric_categorize_id);


--
-- Name: pk_t_numeric_categorize_limits; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_numeric_categorize_limits
    ADD CONSTRAINT pk_t_numeric_categorize_limits PRIMARY KEY (numeric_categorize_id, category_value);


--
-- Name: pk_t_table_side; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_table_side
    ADD CONSTRAINT pk_t_table_side PRIMARY KEY (side_id);


--
-- Name: pk_t_token; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_token
    ADD CONSTRAINT pk_t_token PRIMARY KEY (id);


--
-- Name: pk_t_user; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_user
    ADD CONSTRAINT pk_t_user PRIMARY KEY (user_id);


--
-- Name: pk_t_weight; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_weight
    ADD CONSTRAINT pk_t_weight PRIMARY KEY (weight_id);


--
-- Name: pk_weight_values; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_weight_values
    ADD CONSTRAINT pk_weight_values PRIMARY KEY (weight_id, category_value);


--
-- Name: sessions2_session_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sessions2
    ADD CONSTRAINT sessions2_session_id_key UNIQUE (session_id);


--
-- Name: t_category_pry; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_category
    ADD CONSTRAINT t_category_pry PRIMARY KEY (id);


--
-- Name: t_gousei_order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_gousei_order
    ADD CONSTRAINT t_gousei_order_pkey PRIMARY KEY (id);


--
-- Name: t_numeric_dived_by_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_numeric_divide_by
    ADD CONSTRAINT t_numeric_dived_by_pkey PRIMARY KEY (enq_id, customize_id, varname);


--
-- Name: uniq_t_customize_enq_id_customize_name; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_customize
    ADD CONSTRAINT uniq_t_customize_enq_id_customize_name UNIQUE (enq_id, customize_name);


--
-- Name: uq_t_t_filter_varname; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t_filter_varname
    ADD CONSTRAINT uq_t_t_filter_varname UNIQUE (enq_id, varname);


--
-- Name: idx_pd_variable; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_pd_variable ON pd_variable USING btree (enq_id, variable_name);


--
-- Name: idx_t_job; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_t_job ON t_job USING btree (survey_name);


--
-- Name: t_category_idx1; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX t_category_idx1 ON t_category USING btree (enq_id);


--
-- Name: t_category_idx2; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX t_category_idx2 ON t_category USING btree (enq_id, variable_name);


--
-- Name: t_category_idx3; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX t_category_idx3 ON t_category USING btree (enq_id, category_value);


--
-- Name: t_category_idx4; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX t_category_idx4 ON t_category USING btree (category_label);


--
-- Name: t_category_idx5; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX t_category_idx5 ON t_category USING btree (category_value);


--
-- Name: t_category_idx6; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX t_category_idx6 ON t_category USING btree (enq_id, variable_name, category_value);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

