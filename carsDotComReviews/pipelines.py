# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://doc.scrapy.org/en/latest/topics/item-pipeline.html
from scrapy.exceptions import DropItem

class CarsdotcomreviewsPipeline(object):
    
    def process_item(self, item, spider):
        if not all(item.values()):
            raise DropItem("Missing values!")
        else:
            return item
    
    def __init__(self):
        self.filename = 'carsDotComReviews.txt'
        
    def open_spider(self, spider):
        self.file = open(self.filename, 'w')
        
    def close_spider(self, spider):
        self.file.close()
        
    def process_item(self, item, spider):
        line = '\t'.join(item.values()) + '\n'
        self.file.write(line)
        return item
