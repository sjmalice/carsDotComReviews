from scrapy import Spider
from carsDotComReviews.items import carsDotComReviewsItem

class carsDotComSpider(Spider):
    name = 'cdcspider'
    allowed_urls = ['https://www.cars.com/research/']
    yearRange = range(13, 19) #check this
    #generate urls for honda models
    hondas = ['accord', 'accord_hybrid', 'civic', 'civic_type_r', 'clarity_plug_in_hybrid', 'fit', 'insight', 'cr_v', 'hr_v', 'pilot', 'ridgeline', 'odyssey']
    urlH = []
    for model in hondas:
        for year in yearRange:
            for i in range(1, 4):
                urlH.append('https://www.cars.com/research/honda-{}-20{}/consumer-reviews/?pg={}&nr=250'.format(model, year, i))
    #generate urls for toyota models
    toyotas = ['86', 'avalon', 'avalon_hybrid', 'camry', 'camry_hybrid', 'corolla', 'corolla_im', 'mirai', 'prius', 'prius_prime', 'prius_c', 'prius_v', 'yaris', '4runner', 'c_hr', 'highlander', 'highlander_hybrid', 'land_cruiser', 'rav4', 'rav4_hybrid', 'sequoia', 'tacoma', 'tundra', 'sienna']
    urlT = []
    for model in toyotas:
        for year in yearRange:
            for i in range(1, 4):
                urlT.append('https://www.cars.com/research/toyota-{}-20{}/consumer-reviews/?pg={}&nr=250'.format(model, year, i))
    
    start_urls = urlT + urlH
    #['https://www.cars.com/research/honda-accord-2017/consumer-reviews/?pg={}&nr=10'.format(i) for i in range(1, 4)
                  #'https://www.cars.com/research/toyota-86-2016/consumer-reviews/',
                  #'https://www.cars.com/research/honda-accord-2017/consumer-reviews/?pg=2&nr=250',
                  #'https://www.cars.com/research/honda-accord-2017/consumer-reviews/?pg=3&nr=250',
                  #'https://www.cars.com/research/toyota-camry-2017/consumer-reviews/?pg=1&nr=10',
                  #'https://www.cars.com/research/toyota-camry-2017/consumer-reviews/?pg=2&nr=100']
    
    def parse(self, response):
        reviews = response.xpath('//article') #tag for the user reviews
        ymm = response.xpath('//span[@class="cui-heading-3"]/text()').extract_first().split()
        modelYear, make = ymm[:2]
        model = ' '.join(ymm[2:])
        #print(len(reviews))
        #print("="*40)
        #i = 1
        for review in reviews:
            #print(i)
            #print("="*40)
            #i += 1
            rating = review.xpath('./cars-star-rating/@rating').extract_first()
            url = review.xpath('./p[@class="cui-heading-6"]/a/@href').extract_first()
            title = review.xpath('./p[@class="cui-heading-6"]/a/text()').extract_first()
            reviewerInfo = review.xpath('./p[@class="review-card-review-by"]/text()').extract_first().split("\n")[1:4] #contains username, location and time
            reviewBody = review.xpath('./p[@class="review-card-text"]/text()').extract_first() #remove .replace when using SQL
            comfort = review.xpath('./div/div[1]/cars-star-rating/@rating').extract_first()
            performance = review.xpath('./div/div[2]/cars-star-rating/@rating').extract_first()
            exteriorStyling = review.xpath('./div/div[3]/cars-star-rating/@rating').extract_first()
            interior = review.xpath('./div/div[4]/cars-star-rating/@rating').extract_first()
            value = review.xpath('./div/div[5]/cars-star-rating/@rating').extract_first()
            reliability = review.xpath('./div/div[6]/cars-star-rating/@rating').extract_first()
            extras = review.xpath('./p[@class="review-card-extra"]')
            new = '' #should these 3 be set to None?
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
            helpful = review.xpath('./p[@class="review-card-feedback"]/b[1]/text()').extract_first()
            if not helpful:
                helpful = ''
            outOf = review.xpath('./p[@class="review-card-feedback"]/b[2]/text()').extract_first()
            if not outOf:
                outOf = ''
            
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
