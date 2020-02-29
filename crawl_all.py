import requests
import re
import concurrent.futures
import asyncio
import urllib3

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


def my_func(u):
	try:
		return requests.get(u, verify=False,timeout=3)
	except:
		return None


async def producer_func(loop, executor,queue):
	i = 0
	with open("alldomains.txt") as urls:
		for u in urls:
			i += 1
			if i%1000 == 0:
				await asyncio.sleep(5)
			u = u.rstrip()
			await queue.put((u,loop.run_in_executor(executor, my_func,"http://"+u)))
		await queue.put(None)

async def consumer_func(loop, executor,queue):
	while True:
		item = await queue.get()
		if item == None:
			break
		request = await item[1]
		if request == None:
			continue
		ua_tokens = re.findall('UA-\d*-\d*',request.text)
		ca_tokens = re.findall('ca-pub-\d*',request.text)
		analytics_script = re.findall('src="[^\""]*analytics[^\"]*\.js\"', request.text)
		for i in ua_tokens:
			print(item[0], i)
		for i in ca_tokens:
			print(item[0], i)
		for i in analytics_script:
			print(item[0], i)



with concurrent.futures.ThreadPoolExecutor(max_workers=200) as executor:
	loop = asyncio.get_event_loop()
	queue = asyncio.Queue(loop=loop)
	consumer = consumer_func(loop, executor,queue)
	producer = producer_func(loop, executor,queue)

	loop.run_until_complete(asyncio.gather(producer, consumer))
	loop.close()
