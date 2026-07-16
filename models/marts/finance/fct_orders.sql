with orders as (

    select *
    from {{ ref('stg_jaffle_shop__orders') }}

),

payments as (

    select *
    from {{ ref('stg_stripe__payments') }}
    where status = 'success'

),

payments_by_order as (

    select
        order_id,
        sum(amount) as amount

    from payments

    group by 1

),

final as (

    select
        orders.order_id,
        orders.customer_id,
        coalesce(payments_by_order.amount, 0) as amount

    from orders

    left join payments_by_order using (order_id)

)

select * from final