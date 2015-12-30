// define custom event if needed
/*
 * Polyfill for adding CustomEvent
 * see : https://developer.mozilla.org/fr/docs/Web/API/CustomEvent
 */

if (!window.CustomEvent) { // Create only if it doesn't exist
    (function () {
        function CustomEvent ( event, params ) {
            params = params || { bubbles: false, cancelable: false, detail: undefined };
            var evt = document.createEvent( 'CustomEvent' );
            evt.initCustomEvent( event, params.bubbles, params.cancelable, params.detail );
            return evt;
        };

        CustomEvent.prototype = window.Event.prototype;

        window.CustomEvent = CustomEvent;
    })();
}

// api call helper
function appDeckAPICall(command, param, onAPISuccess, onAPIError)
{
    if (!app.is_appdeck)
    {
        console.log("appDeckAPICall: "+command, param);
        return;
    }
    var eventid = false;
    if (!(typeof(onAPISuccess) === 'undefined' && typeof(onAPIError) === 'undefined'))
        eventid = "appdeck_" + Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
    if (eventid)
    {
        var listener = function(e) {
            if (e.detail.type == "success" && typeof(onAPISuccess) !== 'undefined')
                onAPISuccess.apply(onAPISuccess, e.detail.params);
            if (e.detail.type == "error" && typeof(onAPIError) !== 'undefined')
                onAPIError.apply(onAPIError, e.detail.params);
            document.removeEventListener(eventid, listener, false);
        };
        document.addEventListener(eventid, listener, false);
    }
    // value format: {success: true/false, result: result}
    try {
        var value_json = window.prompt('appdeckapi:' + command, JSON.stringify({param: param, eventid: eventid}));
        //alert(value_json);
        var value = JSON.parse(value_json);
        //alert(window.prompt('appdeckapi:' + command, JSON.stringify({param: param, eventid: eventid})));
        //alert(value.result);
        if (value === null || typeof(value.result) === 'undefined')
            return null;
        return value.result.shift();
    } catch(err) {
        return null;
    }
}

// meta observer

if (typeof(window.WebKitMutationObserver) != "undefined")
{
    //var MutationObserver = MutationObserver || WebKitMutationObserver || MozMutationObserver;
    var obs = new WebKitMutationObserver(function(mutations, observer) {
        // app must be ready
        if (app.is_ready !== true)
            return;
        // look through all mutations that just occured
        var buttonUpdated = false;
        var previousNextUpdated = false;
        mutations.forEach(function(mutation) {
            Array.prototype.map.call(mutation.addedNodes, function(addedNode) {
                if (addedNode.name == "appdeck-menu-entry")
                    buttonUpdated = true;
                if (addedNode.name == "appdeck-next-page" || addedNode.name == "next-page" ||
                    addedNode.name == "appdeck-previous-page" || addedNode.name == "previous-page")
                    previousNextUpdated = true;

            });
        });
        if (buttonUpdated)
            app.refreshTopMenu();
        if (previousNextUpdated)
            app.refreshPreviousNextPage();
    });

    // have the observer observe foo for changes in children
    obs.observe(document.head, {
        attributes: true,
        childList: true
    });
} else {
    document.head.addEventListener("DOMSubtreeModified", function() {
        app.refreshUI();
    });
}

var helper =
{
    addinhistory: function(url)
    {
        var desired_url = url;
        var current_url = window.location.href;
        window.history.replaceState({}, '', desired_url);
        window.history.replaceState({}, '', current_url);
    },

    hasClass: function (ele,cls)
    {
        return ele.className.match(new RegExp('(\\s|^)'+cls+'(\\s|$)'));
    },

    addClass: function (ele,cls)
    {
        if (!this.hasClass(ele,cls)) ele.className += " "+cls;
    },

    removeClass: function (ele,cls)
    {
        if (this.hasClass(ele,cls)) {
            var reg = new RegExp('(\\s|^)'+cls+'(\\s|$)');
            ele.className=ele.className.replace(reg,' ');
        }
    },

    checkConfig: function(name, command)
    {
        Array.prototype.forEach.call(document.getElementsByTagName('meta'), function(meta) {
            if (meta.name == name)
            {
                if (meta.content == 'true')
                    appDeckAPICall(command, 1);
                else
                    appDeckAPICall(command, 0);
            }
        });
    },

    resolveURL: function(url)
    {
        if (url === undefined || url === false || url === 0 || url === "" || url === null)
            return url;
        var resolver = document.createElement('a');
        resolver.href = url;
        resolved_url  = resolver.href; // browser magic at work here
        return "" + resolved_url;
    },

    ajax:  function(url, params, callback) {
        var httpRequest = new XMLHttpRequest();
        httpRequest.onreadystatechange = function() {
            if (httpRequest.readyState == 4) {
                if (httpRequest.status == 200) {
                    if (callback && typeof callback === "function")
                        callback(JSON.parse(httpRequest.responseText));
                } else {
                    if (callback && typeof callback === "function")
                        callback(false);
                }
            }
        };
        httpRequest.open('POST', url, true);
        params = JSON.stringify(params);
        httpRequest.setRequestHeader("Content-type", "application/json");
        //httpRequest.setRequestHeader("Content-length", params.length);
        //httpRequest.setRequestHeader("Connection", "close");
        httpRequest.send(params);
        return httpRequest;
    }
};

var pref =
{
    get: function(name, value)
    {
        return appDeckAPICall("preferencesget", {name: name, value: value});
    },
    set: function(name, value)
    {
        return appDeckAPICall("preferencesset", {name: name, value: value});
    }
};

var app =
{
    self: this,

    version: "1.7",

    is_ready: false,

    is_appdeck: (navigator.userAgent.indexOf("AppDeck") != -1),

    native_ad_count: 0,
    // AppDeck api

    helper: helper,

    addTopMenuButton: function (icon, link, title)
    {
        var button = document.createElement('meta');
        button.setAttribute("type", "button");
        button.setAttribute("name", "appdeck-menu-entry");
        button.setAttribute("content", link);
        button.setAttribute("icon", icon);
        button.setAttribute("title", title);
        document.getElementsByTagName('head')[0].appendChild(button);
    },

    refreshConfig: function()
    {
        app.helper.checkConfig('appdeck-disable-catch-link', 'disable_catch_link');
        app.helper.checkConfig('appdeck-disable-cache', 'disable_cache');
        app.helper.checkConfig('appdeck-disable-ad', 'disable_ad');
        app.helper.checkConfig('appdeck-disable-pulltorefresh', 'disable_pulltorefresh');
    },

    refreshTopMenu: function()
    {
        var entries = [];
        Array.prototype.forEach.call(document.getElementsByTagName('meta'), function(meta) {
            if (meta.name == 'appdeck-menu-entry')
            {
                var entry = {};
                for (var k = 0; k < meta.attributes.length; k++)
                {
                    var attr = meta.attributes[k];
                    if(attr.name != 'class')
                        entry[attr.name] = attr.value;
                }
                entries.push(entry);
        }
        });
        appDeckAPICall("menu", entries);
    },

    refreshPreviousNextPage : function()
    {
        var previous_page = false;
        var next_page = false;
        Array.prototype.forEach.call(document.getElementsByTagName('meta'), function(meta) {
            if (meta.name == 'appdeck-previous-page' || meta.name == 'previous-page')
                previous_page = meta.content;
            if (meta.name == 'appdeck-next-page' || meta.name == 'next-page')
                next_page = meta.content;
        });
        appDeckAPICall("previousnext", {previous_page: this.helper.resolveURL(previous_page), next_page: this.helper.resolveURL(next_page)});
    },

    checkNativeAds: function ()
    {
        var idx = this.native_ad_count;

        Array.prototype.forEach.call(document.querySelectorAll('.appdeck-native-ad:not(.appdeck-native-ad-ready):not(.appdeck-native-ad-working)'), function(el) {

            el.className += " appdeck-native-ad-working";

            if (el.id == "")
                el.id = "appdeck-native-ad-" + idx;

            appDeckAPICall("nativead", {id: el.id});

            idx++;

        });

        this.native_ad_count = idx;
    },

    injectNativeAd: function(divid, properties)
    {
        var nativeAdElement = document.querySelector('#'+divid);

        // clone node to remove all event listener
        var elClone = nativeAdElement.cloneNode(true);
        nativeAdElement.parentNode.replaceChild(elClone, nativeAdElement);
        nativeAdElement = elClone;

        // inject properties
        if (properties.title != undefined)
            Array.prototype.forEach.call(document.querySelectorAll('#'+divid+' .appdeck-native-ad-title'), function(el) {
                el.innerHTML = properties.title;
            });
        if (properties.text != undefined)
            Array.prototype.forEach.call(document.querySelectorAll('#'+divid+' .appdeck-native-ad-text'), function(el) {
                el.innerHTML = properties.text;
            });
        if (properties.ctatext != undefined)
            Array.prototype.forEach.call(document.querySelectorAll('#'+divid+' .appdeck-native-ad-action-text'), function(el) {
                el.innerHTML = properties.ctatext;
                //el.onClick = "app.nativeAdClick('"+divid+"');";
            });
        /*if (properties.ctatext != undefined)
        {
            var els = document.querySelectorAll('#'+divid+' .appdeck-native-ad-action-text')
            for (var k = 0; k < els.length; k++)
            {
                var el = els[k];
                el.innerHTML = properties.ctatext;
                el.href = "javascript:app.nativeAdClick('"+divid+"')";
            }
        }*/
        if (properties.iconimage != undefined)
            Array.prototype.forEach.call(document.querySelectorAll('#'+divid+' .appdeck-native-ad-img-icon'), function(el) {
                el.src = properties.iconimage;
            });
        if (properties.mainimage != undefined)
            Array.prototype.forEach.call(document.querySelectorAll('#'+divid+' .appdeck-native-ad-img-main'), function(el) {
                el.src = properties.mainimage;
            });
        if (properties.daaimage != undefined)
            Array.prototype.forEach.call(document.querySelectorAll('#'+divid+' .appdeck-native-ad-img-daa'), function(el) {
                el.src = properties.daaimage;
            });
        // catch all sublink
        Array.prototype.forEach.call(document.querySelectorAll('#'+divid+' a'), function(el) {
            el.onClick = "app.nativeAdClick('"+divid+"');";
        });
        // mark class as ready
        nativeAdElement.className = nativeAdElement.className.replace('appdeck-native-ad-working','appdeck-native-ad-ready');
        nativeAdElement.style.display = 'inherit';
        nativeAdElement.onClick = "app.nativeAdClick('"+divid+"');";
        nativeAdElement.addEventListener("click", function(el) { app.nativeAdClick(divid); return false; }, false);
    },

    nativeAdClick:function(divid) {
        appDeckAPICall("nativeadclick", {id: divid});
    },

    refreshUITimer: false,

    refreshUI: function() {
        if (this.refreshUITimer)
            return;
        this.refreshUITimer = setTimeout(function() { app.refreshUIWorker(); }, 100);
    },

    refreshUIWorker: function()
    {
        this.refreshUITimer = false;
        this.refreshConfig();
        this.refreshTopMenu();
        this.refreshPreviousNextPage();
        this.checkNativeAds();
    },

    ready: function ()
    {
        if (this.is_ready === true)
        {
            //appDeckAPICall("info", "appdeck already ready");
            return;
        }
        //appDeckAPICall("info", "appdeck ready begin");
        this.is_ready = true;
        // init all
        this.refreshUI();
        this.helper.addClass(document.body, "appdeck");
        if (this.info.isIOS())
            this.helper.addClass(document.body, "appdeck_ios");
        else
            this.helper.addClass(document.body, "appdeck_android");
        if (this.info.isTablet())
            this.helper.addClass(document.body, "appdeck_tablet");
        else
            this.helper.addClass(document.body, "appdeck_phone");
        appDeckAPICall("ready", {ready: "ready"});
        var evt = document.createEvent('Event');
        evt.initEvent('appdeckready', true, true);
        evt.detail = "";
        document.dispatchEvent(evt);
        // disable long touch
        document.documentElement.style.webkitTouchCallout = 'none';
        // enable fastclick
        if (typeof(FastClick) !== 'undefined')
            FastClick.attach(document.body);
        //appDeckAPICall("info", "appdeck ready end");
    },

    // child

    share: function(title, url, imageurl)
    {
        appDeckAPICall("share", {title: title, url: this.helper.resolveURL(url), imageurl: this.helper.resolveURL(imageurl)});
    },

    gotoprevious: function()
    {
        appDeckAPICall("gotoprevious");
    },

    gotonext: function()
    {
        appDeckAPICall("gotonext");
    },

    popup: function(url)
    {
        appDeckAPICall("popup", this.helper.resolveURL(url));
    },


    popover: function(config)
    {
        appDeckAPICall("popover", config);
    },

    inhistory: function(url)
    {
        return appDeckAPICall("inhistory", this.helper.resolveURL(url));
    },

    loadextern: function(url)
    {
        return appDeckAPICall("loadextern", url);
    },

    select: function(values, title, cb)
    {
        return appDeckAPICall("select", {title: title, values: values}, cb);
    },

    selectdate: function(title, year, month, day)
    {
        return appDeckAPICall("selectdate", {title: title, year: year, month: month, day: day});
    },

    shownotice: function(message)
    {
        return appDeckAPICall("shownotice", message);
    },
    showerror: function(message)
    {
        return appDeckAPICall("showerror", message);
    },

    slidemenu: function(command, position)
    {
        return appDeckAPICall("slidemenu", {command: command, position: position});
    },

    // {images: images, startIndex: index, bgcolor: '#000000', gbalpha: 0.8}
    // images: [{url: url, thumbnail: thumbnail_url, caption: 'title'} ...]
    photoBrowser: function(config)
    {
        // give appdeck framework absolute URL
        if (config.images)
        {
            for (var k = 0; k < config.images.length; k++)
            {
                if (config.images[k].url != undefined && config.images[k].url != "")
                    config.images[k].url = this.helper.resolveURL(config.images[k].url);
                if (config.images[k].thumbnail != undefined && config.images[k].thumbnail != "")
                    config.images[k].thumbnail = this.helper.resolveURL(config.images[k].thumbnail);
            }
        }
        return appDeckAPICall("photobrowser", config);
    },


    getElementCoordinate: function (element)
    {
        for (var el=element, lx=0, ly=0;
            el !== null;
            lx += el.offsetLeft, ly += el.offsetTop, el = el.offsetParent);
        return {x: lx,y: ly, width: element.offsetWidth, height: element.offsetHeight};
    },

    page:
        {
            push: function(url) { appDeckAPICall("pagepush", self.helper.resolveURL(url)); },
            pop: function(url) { appDeckAPICall("pagepop", self.helper.resolveURL(url)); },
            poproot: function(url) { appDeckAPICall("pagepoproot", self.helper.resolveURL(url)); },
            root: function(url, reload) { appDeckAPICall("pageroot", self.helper.resolveURL(url)); },
            rootandreload: function(url, reload) { appDeckAPICall("pagerootreload", self.helper.resolveURL(url)); },
            popup: function(url) { appDeckAPICall("popup", self.helper.resolveURL(url)); }
        },

    loading:
        {
            show: function() { appDeckAPICall("loadingshow"); },
            set: function(value) { appDeckAPICall("loadingset", value); },
            hide: function() { appDeckAPICall("loadinghide"); }
        },

    menu:
        {
            left: {
                open: function() { return appDeckAPICall("slidemenu", {command: "open", position: "left"}); },
                close: function() { return appDeckAPICall("slidemenu", {command: "close", position: "left"}); }
            },
            right: {
                open: function() { return appDeckAPICall("slidemenu", {command: "open", position: "right"}); },
                close: function() { return appDeckAPICall("slidemenu", {command: "close", position: "right"}); }
            },
            close: function() { return appDeckAPICall("slidemenu", {command: "close", position: "main"}); }
        },

    info:
        {
            isTablet: function() { return appDeckAPICall("istablet"); },
            isPhone: function() { return appDeckAPICall("isphone"); },
            isIOS: function() { return appDeckAPICall("isios"); },
            isAndroid: function() { return appDeckAPICall("isandroid"); },
            isLandscape: function() { return appDeckAPICall("islandscape"); },
            isPortrait: function() { return appDeckAPICall("isportrait"); }
    },

    clearcache: function () { appDeckAPICall("clearcache"); },
    clearcookies: function () { appDeckAPICall("clearcookies"); },
    reload: function () { appDeckAPICall("reload"); },

    demography:
        {
            postal: function(value) { appDeckAPICall("demography", {name: "postal", value: value}); },
            city: function(value) { appDeckAPICall("demography", {name: "city", value: value}); },
            yearOfBirth: function(value) { appDeckAPICall("demography", {name: "yearOfBirth", value: value}); },
            gender: function(value) { appDeckAPICall("demography", {name: "gender", value: value}); },
            login: function(value) { appDeckAPICall("demography", {name: "login", value: value}); },
            session: function(value) { appDeckAPICall("demography", {name: "session", value: value}); },
            facebook: function(value) { appDeckAPICall("demography", {name: "facebook", value: value}); },
            mail: function(value) { appDeckAPICall("demography", {name: "mail", value: value}); },
            msn: function(value) { appDeckAPICall("demography", {name: "msn", value: value}); },
            twitter: function(value) { appDeckAPICall("demography", {name: "twitter", value: value}); },
            skype: function(value) { appDeckAPICall("demography", {name: "skype", value: value}); },
            yahoo: function(value) { appDeckAPICall("demography", {name: "yahoo", value: value}); },
            googleplus: function(value) { appDeckAPICall("demography", {name: "googleplus", value: value}); },
            linkedin: function(value) { appDeckAPICall("demography", {name: "linkedin", value: value}); },
            youtube: function(value) { appDeckAPICall("demography", {name: "youtube", value: value}); },
            viadeo: function(value) { appDeckAPICall("demography", {name: "viadeo", value: value}); },
            education: function(value) { appDeckAPICall("demography", {name: "education", value: value}); },
            dateOfBirth: function(value) { appDeckAPICall("demography", {name: "dateOfBirth", value: value}); },
            income: function(value) { appDeckAPICall("demography", {name: "income", value: value}); },
            age: function(value) { appDeckAPICall("demography", {name: "age", value: value}); },
            areaCode: function(value) { appDeckAPICall("demography", {name: "areaCode", value: value}); },
            interests: function(value) { appDeckAPICall("demography", {name: "interests", value: value}); },
            maritalStatus: function(value) { appDeckAPICall("demography", {name: "maritalStatus", value: value}); },
            language: function(value) { appDeckAPICall("demography", {name: "language", value: value}); },
            hasChildren: function(value) { appDeckAPICall("demography", {name: "hasChildren", value: value}); },
            custom: function(name, value) { appDeckAPICall("demography", {name: name, value: value}); }
        },

    profile:
        {
            setEnablePrefetch: function(value) { appDeckAPICall("demography", {name: "enable_prefetch", value: (value ? "1" : "0")}); },
            setEnableAd: function(value) { appDeckAPICall("demography", {name: "enable_ad", value: (value ? "1" : "0")}); }
        },

    pulltorefresh:
        {
            enable: function() { appDeckAPICall("enable_pulltorefresh"); },
            disable: function() { appDeckAPICall("disable_pulltorefresh"); }
        },

    postMessage: function(message, target) { appDeckAPICall("postmessage", {message: message, target: target}); },
    receiveMessage: function(message) { window.postMessage(message, "*"); },

    loadapp: function (url, cache) { appDeckAPICall("loadapp", {url: url, cache: cache}); },

    facebook:
    {
        login: function(permissions, cb) { appDeckAPICall("facebooklogin", permissions, cb); }

    },

    twitter:
    {
        login: function(options, cb) { appDeckAPICall("twitterlogin", options, cb); }

    },

    push:
        {
            channels:
            {
                get: function(callback) { return app.helper.ajax("http://push.appdeck.mobi/channel/get", null, callback); },
                set: function(channels, callback) { return app.helper.ajax("http://push.appdeck.mobi/channel/set", channels, callback); }
            }
        },

    ping: function (data, cb) { appDeckAPICall("ping", data, cb); }

};

// catch console
if (app.is_appdeck)
{
    (function (c) {
        "use strict";
        var oldInfo = c.info;
        var oldLog = c.log;
        var oldwarn = c.warn;
        var oldError = c.error;

        c.info = function () {
            var args = Array.prototype.slice.call(arguments);
            for (var k = 0; k < args.length; k++)
                appDeckAPICall("debug", args[k]);
            return oldLog.apply(c, args);
        };
        c.log = function () {
            var args = Array.prototype.slice.call(arguments);
            for (var k = 0; k < args.length; k++)
                appDeckAPICall("info", args[k]);
            return oldLog.apply(c, args);
        };
        c.warn = function () {
            var args = Array.prototype.slice.call(arguments);
            for (var k = 0; k < args.length; k++)
                appDeckAPICall("warning", args[k]);
            return oldLog.apply(c, args);
        };
        c.error = function () {
            var args = Array.prototype.slice.call(arguments);
            for (var k = 0; k < args.length; k++)
                appDeckAPICall("error", args[k]);
            return oldLog.apply(c, args);
        };
    }(window.console));

    // catch javascript error

    var gOldOnError = window.onerror;
    window.onerror = function myErrorHandler(message, filename, lineno, colno, error) {
        console.error("JavaScript Error: '" + message + "' on line " + lineno + " for " + filename + " (column: " + colno + " error: " + error + ")");
        if (gOldOnError)
            return gOldOnError(message, url, lineNumber);
        return false;
    };
}

// this allow handling iframe menu in webapp mode
if (navigator.userAgent.indexOf("AppDeck") == -1 && window.parent != undefined)
{
    try {
        window.app = window.parent.app;
    } catch (e) {

    }
} else {
    window.addEventListener('DOMContentLoaded', function(e) {
        app.ready();
    });

    window.addEventListener('load', function(e) {
        app.ready();
    });

    if (document.readyState == "complete" || document.readyState == "loaded") {
        app.ready();
    }
}

//appDeckAPICall("info", "end of appdeck script");
