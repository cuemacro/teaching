from builtins import list, str, round

import urllib.request
import concurrent.futures

from multiprocessing import Pool

import time

## URLS to download
URLS = ['http://www.foxnews.com/',
        'http://www.cnn.com/',
        'http://europe.wsj.com/',
        'http://www.bbc.co.uk/'] * 20

def time_func(func):
    """Wrap a function with a timer

    Parameters
    ----------
    func : func
        Function to decorate

    Returns
    -------
    func
    """

    def wrapper():
        start_time = time.time()
        x = func()
        duration = str(round(time.time() - start_time, 1))

        print("Function ran in %s seconds" %duration)

        return x

    return wrapper

def load_url(url, timeout=15):
    """Loads the raw text from a URL

    Parameters
    ----------
    url : str
        URL to download

    timeout : int (optional)
        Number of seconds to timeout

    Returns
    -------
    str
    """
    return urllib.request.urlopen(url, timeout=timeout).read()

@time_func
def run_single_thread():
    """Loads URLs in a single threaded way.

    Returns
    -------
    str (list)
    """
    print('--- Single thread ---')
    return [load_url(x) for x in URLS]


@time_func
def run_concurrent_futures_threadpool():
    """Loads URLs using concurrent.futures (abstraction on top of threading)

    Returns
    -------
    str (list)
    """

    print('--- Concurrent futures threadpool ---')
    with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
        return list(executor.map(load_url, URLS))

@time_func
def run_concurrent_futures_processpool():
    """Loads URLs using concurrent.futures (abstraction on top of multiprocessing)

    Returns
    -------
    str (list)
    """

    print('--- Concurrent futures processpool ---')
    with concurrent.futures.ProcessPoolExecutor(max_workers=5) as executor:
        return list(executor.map(load_url, URLS))

@time_func
def run_multiproccesing():
    """Loads URLs using multiprocessor directly, rather than using via concurrent.futures

    Returns
    -------
    str (list)
    """

    print('--- Multiprocessing ---')
    with Pool(5) as executor:
        return list(executor.map(load_url, URLS))

if __name__ == "__main__":
    ### kick off each example and compare timings!

    # the "__main__" indicates the code inside this if statement should only be executed when you run the file which
    # contains those code block. It will not executed if the program is imported as a module.

    # multiprocessing code must be executed under the __main__ block

    single_threaded_webpages = run_single_thread()
    print(len(single_threaded_webpages))

    concurrent_futures_webpages_threadpool = run_concurrent_futures_threadpool()
    print(len(concurrent_futures_webpages_threadpool))

    concurrent_futures_webpages_processpool = run_concurrent_futures_processpool()
    print(len(concurrent_futures_webpages_processpool))

    multiprocessing_webpages = run_multiproccesing()
    print(len(multiprocessing_webpages))

