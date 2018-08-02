from scrapy import Spider
from carsDotComReviews.items import carsDotComReviewsItem

class carsDotComSpider(Spider):
    name = 'cdcspider'
    allowed_urls = ['https://www.cars.com/research/']
    start_urls = ['https://www.cars.com/research/honda-accord-2017/consumer-reviews/?pg=1&nr=10',
                  'https://www.cars.com/research/toyota-camry-2017/consumer-reviews/?pg=1&nr=10']
    
    def parse(self, response):
        reviews = response.xpath('//article') #tag for the user reviews
        modelYear, make, model = response.xpath('//span[@class="cui-heading-3"]/text()').extract_first().split()
        print(len(reviews))
        print("="*40)
        i = 1
        for review in reviews:
            print(i)
            print("="*40)
            i += 1
            rating = review.xpath('./cars-star-rating/@rating').extract_first()
            url = review.xpath('./p[@class="cui-heading-6"]/a/@href').extract_first()
            title = review.xpath('./p[@class="cui-heading-6"]/a/text()').extract_first()
            reviewerInfo = review.xpath('./p[@class="review-card-review-by"]/text()').extract_first().split("\n")[1:4] #contains username, location and time
            #location = reviewerInfo[1].lstrip().split(", ")
            reviewBody = review.xpath('./p[@class="review-card-text"]/text()').extract_first().strip().replace('\n', ' ') #remove .replace when using SQL
            comfort = review.xpath('./div/div[1]/cars-star-rating/@rating').extract_first()
            performance = review.xpath('./div/div[2]/cars-star-rating/@rating').extract_first()
            exteriorStyling = review.xpath('./div/div[3]/cars-star-rating/@rating').extract_first()
            interior = review.xpath('./div/div[4]/cars-star-rating/@rating').extract_first()
            value = review.xpath('./div/div[5]/cars-star-rating/@rating').extract_first()
            reliability = review.xpath('./div/div[6]/cars-star-rating/@rating').extract_first()
            extras = review.xpath('./p[@class="review-card-extra"]')
            new = ''
            use = ''
            recommend = ''
            for extra in extras:
                if extra.xpath('./text()').extract_first().find('Purchased') != -1:
                    new = extra.xpath('./b/text()').extract_first()
                    continue
                if extra.xpath('./text()').extract_first().find('Uses') != -1:
                    use = extra.xpath('./b/text()').extract_first()
                    continue
                if extra.xpath('./text()').extract_first().find('recommend') != -1:
                    recommend = extra.xpath('./b/text()').extract_first()
            #new = review.xpath('./p[4]/b/text()').extract_first() #these three are inconsistent
            #use = review.xpath('./p[5]/b/text()').extract_first()
            #recommend = review.xpath('./p[6]/b/text()').extract_first()
            helpful = review.xpath('./p[@class="review-card-feedback"]/b[1]/text()').extract_first()
            outOf = review.xpath('./p[@class="review-card-feedback"]/b[2]/text()').extract_first()
            
            item = carsDotComReviewsItem()
            item['make'] = make  #add these later after correct way to loop through urls is
            item['model'] = model
            item['modelYear'] = modelYear
            item['rating'] = rating
            item['url'] = url
            item['title'] = title
            item['author'] = reviewerInfo[0].lstrip()[3:]
            item['location'] = reviewerInfo[1].lstrip()[5:].rstrip()
            #item['city'] = location[0][5:]
            #item['state'] = location[1]
            item['date'] = reviewerInfo[2].lstrip()[3:]
            item['reviewBody'] = reviewBody
            item['comfort'] = comfort
            item['exteriorStyling'] = exteriorStyling
            item['value'] = value
            item['performance'] = performance
            item['interior'] = interior
            item['reliability'] = reliability
            item['new'] = new
            item['use'] = use
            item['recommend'] = recommend
            item['helpful'] = helpful
            item['outOf'] = outOf
            yield item
