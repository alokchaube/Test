//http://coderzone.org/library/1047.htm

var uiWebview_SearchResultCount = 0;

/*!
 @method     uiWebview_HighlightAllOccurencesOfStringForElement
 @abstract   // helper function, recursively searches in elements and their child nodes
 @discussion // helper function, recursively searches in elements and their child nodes
 
 element    - HTML elements
 keyword    - string to search
 */

function uiWebview_HighlightAllOccurencesOfStringForElement(element,keyword) {
    
    if (element) {
        
        if (element.nodeType == 3) {        // Text node
            
            while (true) {
                
                var value = element.nodeValue;  // Search for keyword in text node
                var idx = value.toLowerCase().indexOf(keyword);
                
                if (idx < 0) break;             // not found, abort
                
                //we create a SPAN element for every parts of matched keywords
                var span = document.createElement("span");
                var text = document.createTextNode(value.substr(idx,keyword.length));
                span.appendChild(text);
                
                span.setAttribute("class","uiWebviewHighlight"); 
                span.style.backgroundColor="#d7ecfa";
                span.style.color="black";

                uiWebview_SearchResultCount++;    // update the counter
            
                text = document.createTextNode(value.substr(idx+keyword.length));
                element.deleteData(idx, value.length - idx);
                var next = element.nextSibling;
                element.parentNode.insertBefore(span, next);
                element.parentNode.insertBefore(text, next);
                element = text;
            }
            
        } else if (element.nodeType == 1) { // Element node
            if (element.style.display != "none" && element.nodeName.toLowerCase() != 'select') {
                for (var i=element.childNodes.length-1; i>=0; i--) {
                    uiWebview_HighlightAllOccurencesOfStringForElement(element.childNodes[i],keyword);
                }
            }
        }
        
        setIdOfHighlighetedSpan();//calling to set id attribute.
    }
}

// the main entry point to start the search
// @param : keyword - search text which you want to search & Highlight

function uiWebview_HighlightAllOccurencesOfString(keyword) {
    uiWebview_RemoveAllHighlights();
    uiWebview_HighlightAllOccurencesOfStringForElement(document.body, keyword.toLowerCase());
}

// helper function, recursively removes the highlights in elements and their childs
// @param : element - in which element you need to remove highlight e.g - document.body

function uiWebview_RemoveAllHighlightsForElement(element) {
    
    if (element) {
        
        if (element.nodeType == 1) {
            
            if (element.getAttribute("class") == "uiWebviewHighlight") {
                var text = element.removeChild(element.firstChild);
                element.parentNode.insertBefore(text,element);
                element.parentNode.removeChild(element);
                return true;
            } else {
                
                var normalize = false;
                for (var i=element.childNodes.length-1; i>=0; i--) {
                    if (uiWebview_RemoveAllHighlightsForElement(element.childNodes[i])) {
                        normalize = true;
                    }
                }
                if (normalize) {
                    element.normalize();
                }
            }
        }
    }
    return false;
}

//---Method to remove the highlights---
function uiWebview_RemoveAllHighlights() {
    uiWebview_SearchResultCount = 0;
    uiWebview_RemoveAllHighlightsForElement(document.body);
}

//-----set id of all span respectively----
function setIdOfHighlighetedSpan() {
    
    var arr = getElementsByClassName(document.body,'span','uiWebviewHighlight');
    
    for (var i=0; i<arr.length; i++) {
        var idforspan = "uiWebviewHighlight_"+(i+1);
        var span = arr[i];
        span.setAttribute("id",idforspan);
    }
}

/*
 get array of objects with class
 @param : oElm - the object in which we need to search all objec. e.g - document.body
 @param : strTagName - tag of the object for which you are looking for.
 @param : strClassName - class name of object.
*/

function getElementsByClassName(oElm, strTagName, strClassName) {
    
    var arrElements = (strTagName == "*" && oElm.all)? oElm.all :
    oElm.getElementsByTagName(strTagName);
    var arrReturnElements = new Array();
    strClassName = strClassName.replace(/\-/g, "\\-");
    var oRegExp = new RegExp("(^|\\s)" + strClassName + "(\\s|$)");
    var oElement;
    for(var i=0; i<arrElements.length; i++){
        oElement = arrElements[i];     
        if(oRegExp.test(oElement.className)){
            arrReturnElements.push(oElement);
        }   
    }
    return (arrReturnElements)
}

/*-----change background color of object---
@param : objectId - id of object.
@param : colorName - specify the color which you want to put.
*/

function changeColorOfSpanById(objectId,colorName) {
    var span = document.getElementById(objectId);
    if(span) {
        span.style.backgroundColor = colorName;
    } 
}

/*
 method to change the color of current/previous selected span
 @param : spanId - current span id
 @param : preSpanId - previous span id
 */
function changeColorOfCurrentHighlighetedSpan(spanId,preSpanId) {
    changeColorOfSpanById(spanId,"#b3dbff"); //change color of current span
    document.getElementById(spanId).style.boxShadow = "10px 10px 5px #ff00000";//set shadow
    changeColorOfSpanById(preSpanId,"#d7ecfa");//change color of previous span
    document.getElementById(spanId).style.boxShadow = "0px 0px 0px #888888";//release shadow
}

