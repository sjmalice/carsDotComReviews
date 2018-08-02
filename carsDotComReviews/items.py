# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# https://doc.org/en/latest/topics/items.html

from scrapy import Item, Field


class carsDotComReviewsItem(Item):
    # define the fields for your item here like:
    # name = Field()
    make = Field()   #add these later after correct way to loop through urls is done
    model = Field()
    modelYear = Field()
    rating = Field()
    url = Field()
    title = Field()
    author = Field()
    location = Field()
    #city = Field()
    #state = Field()
    date = Field()
    reviewBody = Field()
    comfort = Field()
    exteriorStyling = Field()
    value = Field()
    performance = Field()
    interior = Field()
    reliability = Field()
    new = Field()
    use = Field()
    recommend = Field()
    helpful = Field()
    outOf = Field()
