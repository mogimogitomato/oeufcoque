const puppeteer = require('puppeteer');
const TARGET_URL = 'https://www.suruga-ya.jp/';
const SEARCH_WORDS = process.argv[2];

async function getScrapingData(search_word) {
  const browser = await puppeteer.launch({headless:true})
  const page = await browser.newPage()
  await page.goto(TARGET_URL, {waitUntil: 'networkidle2'})
  await page.type('input[name=search_word]', search_word)
  const searchElement = await page.$('input[id=btn]')
  await Promise.all([
    page.waitForNavigation({waitUntil: "domcontentloaded"}),
    searchElement.click()
  ])
  const scrapingData = await page.evaluate(() => {
    const dataList = []
    const itemList = Array.from(document.querySelectorAll("div.item"))
    for (let i = 0; i < itemList.length; i++) {
      let item = itemList[i].children[1].children[1].children[0]
      // 商品価格はタイムセールなどで子要素が可変になるため判定
      let priceList = itemList[i].children[2]
      let price = null
      for (let j = 0; j < priceList.children.length; j++) {
        if (priceList.children[j].className == "price") {
          price = priceList.children[j]
          break
        }
      }
      let data = {
        url: item.href,
        title: item.textContent,
        price: price.textContent
      }　
      dataList.push(data)
    }
    return dataList
  })
  const result = []
  result.push({[search_word]: scrapingData})
  const json = JSON.stringify(result, null, " ")
  await browser.close()
  console.log(json)
}

getScrapingData(SEARCH_WORDS)