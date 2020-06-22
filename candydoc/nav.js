var searchLookup = {}
var searchKeys = []
var ddocMain;
var searchField;
var markContext
var markInstance

document.addEventListener("DOMContentLoaded", function (event) {
    var elements = document.getElementsByClassName("collapsable");
    ddocMain = document.getElementById('ddoc_main');

    for (var i = 0; i < elements.length; i++) {
        var element = elements[i];
        var targets = element.getElementsByClassName('collapse_target');

        for (var n = 0; n < targets.length; n++) {
            var target = targets[n];
            target.addEventListener('click', toggleCollapse, false);
            var lookupKey = target.textContent.trim().replace('\n', '').replace('  ', ' ').toLowerCase();
            searchLookup[lookupKey] = {
                target: target,
                collapsable: element
            }
        }
    }

    searchKeys = Object.keys(searchLookup);

    searchfield = document.getElementById('search_field');
    if (searchfield) {
        searchfield.addEventListener('keydown', debounce(function () { handleSearchChange() }, 500));
    }

    markContext = document.querySelector("#ddoc_main");
    markInstance = new Mark(markContext);
});

function handleSearchChange() {
    var searchValue = searchfield.value.toLowerCase();

    if (!!searchValue.trim()) {
        setSearchActive(true)
    } else {
        setSearchActive(false)
    }

    var filtered = searchKeys.filter(function (value) {
        var valueElement = searchLookup[value].collapsable;
        if (valueElement.classList.contains('filtered')) {
            valueElement.classList.remove('filtered')
        }
        if (valueElement.classList.contains('filtered-parent')) {
            valueElement.classList.remove('filtered-parent')
        }
        return value.indexOf(searchValue) !== -1;
    });

    for (let value of filtered) {
        var valueElement = searchLookup[value].collapsable;
        if (!valueElement.classList.contains('filtered')) {
            valueElement.classList.add('filtered')
        }
        filterParentRecursive(valueElement)
    }
    markInstance.unmark();
    markInstance.mark(searchValue);
}

function filterParentRecursive(node) {
    if (!node.parentNode || !node.parentNode.classList) return;

    if (node.parentNode.classList.contains('collapsable')) {
        if (!node.parentNode.classList.contains('filtered')) {
            node.parentNode.classList.add('filtered');
            node.parentNode.classList.add('filtered-parent');
        }
    } else {
        filterParentRecursive(node.parentNode);
    }
}

function setSearchActive(value) {
    if (value) {
        if (!ddocMain.classList.contains('search_active')) {
            ddocMain.classList.add('search_active');
        }
    } else {
        if (ddocMain.classList.contains('search_active')) {
            ddocMain.classList.remove('search_active');
        }
    }
}


function toggleCollapse() {
    var collapsable = this.parentNode;
    if (collapsable.classList.contains('collapsable--expanded')) {
        collapsable.classList.remove('collapsable--expanded')
    } else {
        collapsable.classList.add('collapsable--expanded')
    }
}

function debounce(func, wait, immediate) {
    var timeout;
    return function () {
        var context = this, args = arguments;
        var later = function () {
            timeout = null;
            if (!immediate) func.apply(context, args);
        };
        var callNow = immediate && !timeout;
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
        if (callNow) func.apply(context, args);
    };
};