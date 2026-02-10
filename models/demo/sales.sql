{{
    config
    (
        materialized='incremental',
        incremantal_strategy = 'append'
    )
}}


with sales_src as (
    select
        SALE_ID,
        SALE_DATE,
        CUSTOMER_ID,
        PRODUCT_ID,
        QUANTITY,
        TOTAL_AMOUNT,
        CREATED_AT,
        CURRENT_TIMESTAMP as INSERT_DTS
    from {{source("sales", "SALES_SRC")}}

{% if is_incremental() %}
  where CREATED_AT > (select max(INSERT_DTS) from {{ this }})
{% endif %}

)


select * from sales_src