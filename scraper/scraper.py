import requests  
import urlparse  
import collections
from lxml import html  



STARTING_URL = 'http://www.gorejunkies.com/'

urls_queue = collections.deque()  
urls_queue.append(STARTING_URL)  
found_urls = set()  
found_urls.add(STARTING_URL)

while len(urls_queue):  
    url = urls_queue.popleft()

    try:
        response = requests.get(url)
        parsed_body = html.fromstring(response.content)

        #Get Images
        images = parsed_body.xpath('//img/@src')
        images = [urlparse.urljoin(response.url, url) for url in images]  
        for imageurl in images[0:10]:  
            r = requests.get(imageurl)
            f = open('gorejunkies.com/%s' % imageurl.split('/')[-1], 'w')
            f.write(r.content)
            f.close()


        # Prints the page title
        print parsed_body.xpath('//title/text()')

        # Find all links
        links = {urlparse.urljoin(response.url, url) for url in parsed_body.xpath('//a/@href') if urlparse.urljoin(response.url, url).startswith('http')}

        # Set difference to find new URLs
        for link in (links - found_urls):
            found_urls.add(link)
            urls_queue.append(link)

    except:
        print 'unexpected error'
