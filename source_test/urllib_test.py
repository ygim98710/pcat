import urllib.parse
import urllib.request


details = urllib.parse.urlencode({'a': 'Whatdoesthefoxsay', 'b': 'lingdingdingdingdingdiding'})
details = details.encode('UTF-8')
url = urllib.request.Request('http://localhost:8081/Capston/text_test.jsp', details)
#url.add_header('User-Agent','Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US) AppleWebKit/525.13 (KHTML, like Gecko) Chrome/0.2.149.29 Safari/525.13')
urllib.request.urlopen(url).read().decode('utf-8')
#print(ResponseData)