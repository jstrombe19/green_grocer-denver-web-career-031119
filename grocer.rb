def consolidate_cart(cart)
  consolidated_cart = {}
  
  cart.each do |items|
    items.each do |item, attributes|
      if !consolidated_cart.has_key?(item)
        consolidated_cart[item] = attributes
        consolidated_cart[item][:count] = 1
      else
        consolidated_cart[item][:count] += 1
      end
    end
  end
  
  consolidated_cart
end

def apply_coupons(cart, coupons)
  cart_with_coupons_applied = {}
  
  cart.each do |item, attributes|
    cart_with_coupons_applied[item] = attributes
  end
  
  coupons.each do |coupon|
    item = coupon[:item]
    if cart_with_coupons_applied.has_key?(item)
      attributes = cart_with_coupons_applied[item]
      if attributes[:count] >= coupon[:num]  # Does the coupon apply?
        cart_with_coupons_applied[item][:count] -= coupon[:num]
      
        coupon_key = "#{item} W/COUPON"
        if !cart_with_coupons_applied.has_key?(coupon_key)
          cart_with_coupons_applied[coupon_key] = {
            :price => coupon[:cost],
            :clearance => attributes[:clearance],
            :count => 1
          }
        else
          cart_with_coupons_applied[coupon_key][:count] += 1
        end
      end
    end
  end
  
  cart_with_coupons_applied
end

def apply_clearance(cart)
  cart_with_clearance_applied = {}
  
  cart.each do |item, attributes|
    cart_with_clearance_applied[item] = attributes
    if attributes[:clearance]
      cart_with_clearance_applied[item][:price] = (cart_with_clearance_applied[item][:price] * 0.8).round(2)
    end
  end
  
  cart_with_clearance_applied
end


def subtotal(cart)
  total = 0
  cart.each do |item, attributes|
    total += (attributes[:price] * attributes[:count])
  end
  
  total
end

def checkout(cart, coupons)
  
  cart = consolidate_cart(cart)
  
  cart = apply_coupons(cart, coupons)
  
  cart = apply_clearance(cart)
  
  total = subtotal(cart)
  if total > 100.0
    total *= 0.9
  end

  total
  
end

