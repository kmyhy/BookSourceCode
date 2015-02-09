var menusDiv = document.querySelector('div.nv_i');
var menus = menusDiv.querySelectorAll('li');
function parseMenus() {
    result = []
    for (var i = 0; i < menus.length; i++) {
        var menu = menus[i];
        var url = menu.querySelector('a').getAttribute('href');
        var title = menu.querySelector('a').textContent;
        result.push({'url' : url, 'title' :title});
    }
    return result;
}
var items = parseMenus();
webkit.messageHandlers.didFetchMenus.postMessage(items);