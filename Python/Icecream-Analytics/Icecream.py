# Name: Pruthvi Shyam Billa
# Course: BUDT704
# Section: 501
# Date: 09/09/2022


#The US has the biggest ice cream lovers in the world on a per capita basis.
#True to this fact, I was pleased to see people consuming them regularly. 
#Interestingly, one of my professor’s ardent love for ice cream was evident 
#in his first lecture. In the hope of winning his admiration, I have started 
#a business in Maryland. Unfortunately, customers will be able to purchase 
#only two items due to global supply chain issues. These items are– ice cream
#bars and water bottles. A script to generate a sales report for each order 
#received will help monitor and analyze the sales efficiently.


# 1. Determine total number of items purchased in the order

# read ice cream bars and water bottles purchased
icecream_count = int(input('Number of ice cream bars purchased: '))
water_bottle_count = int(input('Number of water bottles purchased : '))

# calculate total number of items in the order's purchase
total_items_count = (icecream_count + water_bottle_count)


# 2. Determine total price for the items purchased in the order

# read each ice cream bar and water bottle cost sold by the truck
icecream_price = int(input('Price of an ice cream bar : '))
water_bottle_price = int(input('Price of a water bottle : '))


# calculate total price for each item, and then for the order
icecream_price_total = (icecream_count * icecream_price)
water_bottle_price_total = (water_bottle_count * water_bottle_price)

items_price_total = (icecream_price_total + water_bottle_price_total)


# 3. Determine sales tax charged for the order

sales_tax_percentage = 6   #Maryland charges 6% sales tax for all purchases
sales_tax_price = ( (sales_tax_percentage / 100) * items_price_total )


# 4. Determine the overall total price of the order the truck receives

grand_total_price = (items_price_total + sales_tax_price)


# 5. Determine the royalty fee ice cream truck owes to the University

royalty_fee_price = ( ( 0.12 * total_items_count ) + ( 0.021 * items_price_total) )


# 6. Determine total profit earned by the ice cream truck

total_profit = ( grand_total_price - (royalty_fee_price + sales_tax_price) )


#The script reads the data: number of items purchased by the customer for 
#both ice cream bars and water bottles, and also the price for each of these 
#item type. This received data is used for computing various prices, sales
#tax, and royalty fee. Total profit earned by the ice cream truck except
#will help us track sales and make better business decisions.


print(f'<<<<<<<<<<<<<<<<<<<<SALES REPORT>>>>>>>>>>>>>>>>>>>>')

#print value for items purchased
print(f'Number of ice cream bars purchased          : {icecream_count} ')
print(f'Number of water bottles purchased           : {water_bottle_count}')

#print calculated values for each item type and the order
print(f'Total price of all ice cream bars purchased : ${icecream_price_total:0.2f}')
print(f'Total price of all water bottles purchased  : ${water_bottle_price_total:0.2f}')
print(f'Total price for the entire order            : ${items_price_total:0.2f}')

#print sales tax percentage and its price
print(f'Sales tax percentage                        : {sales_tax_percentage:0.2f}%')  
print(f'Sales tax price                             : ${sales_tax_price:0.2f}')

#print grand order total which includes total items value and sales tax
print(f'Grand total of the order                    : ${grand_total_price:0.2f}')

#print royalty fee truck owes to the University
print(f'Univeristy Royalty fee                      : ${royalty_fee_price:0.2f}')

#print total profit earned after discounting sales tax and royalty fee
print(f'Total profit earned                         : ${total_profit:0.2f}')



# "I pledge on my honor that I have not given nor received any unauthorized
# assistance on this assignment."
# --<<Pruthvi Shyam Billa>>
