!function(){var t=null;
(function(){function S(d){function n(){try{J.doScroll("left")}catch(k){setTimeout(n,50);return}w("poll")}function w(n){if(!(n.type=="readystatechange"&&c.readyState!="complete")&&((n.type=="load"?x:c)[y](k+n.type,w,!1),!p&&(p=!0)))d.call(x,n.type||n)}var p=!1,u=!0,s=c.addEventListener?"addEventListener":"attachEvent",y=c.addEventListener?"removeEventListener":"detachEvent",k=c.addEventListener?"":"on";if(c.readyState=="complete")d.call(x,"lazy");else{if(c.createEventObject&&J.doScroll){try{u=!x.frameElement}catch(E){}u&&
n()}c[s](k+"DOMContentLoaded",w,!1);c[s](k+"readystatechange",w,!1);x[s](k+"load",w,!1)}}for(var x=window,c=document,J=c.documentElement,K=c.getElementsByTagName("head")[0]||c.documentElement,y="",L=c.scripts,d=L.length;--d>=0;){var p=L[d],N=p.src.match(/\/run_prettify\.js(?:\?([^#]*))?(?:#.*)?$/);if(N){y=N[1]||"";p.parentNode.removeChild(p);break}}var M=!0,E=[],z=[],H=[];y.replace(/[&?]([^&=]+)=([^&]+)/g,function(c,n,w){w=decodeURIComponent(w);n=decodeURIComponent(n);n=="autorun"?M=!/^[0fn]/i.test(w):
n=="lang"?E.push(w):n=="skin"?z.push(w):n=="callback"&&H.push(w)});d=0;for(y=E.length;d<y;++d)p=c.createElement("script"),p.type="text/javascript",p.src="https://google-code-prettify.googlecode.com/svn/loader/lang-"+encodeURIComponent(E[d])+".js",K.appendChild(p);p=[];d=0;for(y=z.length;d<y;++d)p.push("https://google-code-prettify.googlecode.com/svn/loader/skins/"+encodeURIComponent(z[d])+".css");p.push("https://google-code-prettify.googlecode.com/svn/loader/prettify.css");(function(d){function n(p){if(p!==
w){var u=c.createElement("link");u.rel="stylesheet";u.type="text/css";if(p+1<w)u.error=u.onerror=function(){n(p+1)};u.href=d[p];K.appendChild(u)}}var w=d.length;n(0)})(p);var T=function(){window.PR_SHOULD_USE_CONTINUATION=!0;var c;(function(){function n(b){function h(f){var a=f.charCodeAt(0);if(a!==92)return a;var i=f.charAt(1);return(a=k[i])?a:"0"<=i&&i<="7"?parseInt(f.substring(1),8):i==="u"||i==="x"?parseInt(f.substring(2),16):f.charCodeAt(1)}function l(f){if(f<32)return(f<16?"\\x0":"\\x")+f.toString(16);
f=String.fromCharCode(f);return f==="\\"||f==="-"||f==="]"||f==="^"?"\\"+f:f}function e(f){var a=f.substring(1,f.length-1).match(/\\u[\dA-Fa-f]{4}|\\x[\dA-Fa-f]{2}|\\[0-3][0-7]{0,2}|\\[0-7]{1,2}|\\[\S\s]|[^\\]/g),f=[],i=a[0]==="^",b=["["];i&&b.push("^");for(var i=i?1:0,g=a.length;i<g;++i){var m=a[i];if(/\\[bdsw]/i.test(m))b.push(m);else{var m=h(m),j;i+2<g&&"-"===a[i+1]?(j=h(a[i+2]),i+=2):j=m;f.push([m,j]);j<65||m>122||(j<65||m>90||f.push([Math.max(65,m)|32,Math.min(j,90)|32]),j<97||m>122||f.push([Math.max(97,
m)&-33,Math.min(j,122)&-33]))}}f.sort(function(f,a){return f[0]-a[0]||a[1]-f[1]});a=[];g=[];for(i=0;i<f.length;++i)m=f[i],m[0]<=g[1]+1?g[1]=Math.max(g[1],m[1]):a.push(g=m);for(i=0;i<a.length;++i)m=a[i],b.push(l(m[0])),m[1]>m[0]&&(m[1]+1>m[0]&&b.push("-"),b.push(l(m[1])));b.push("]");return b.join("")}function n(f){for(var a=f.source.match(/\[(?:[^\\\]]|\\[\S\s])*]|\\u[\dA-Fa-f]{4}|\\x[\dA-Fa-f]{2}|\\\d+|\\[^\dux]|\(\?[!:=]|[()^]|[^()[\\^]+/g),b=a.length,h=[],g=0,m=0;g<b;++g){var j=a[g];j==="("?++m:
"\\"===j.charAt(0)&&(j=+j.substring(1))&&(j<=m?h[j]=-1:a[g]=l(j))}for(g=1;g<h.length;++g)-1===h[g]&&(h[g]=++c);for(m=g=0;g<b;++g)j=a[g],j==="("?(++m,h[m]||(a[g]="(?:")):"\\"===j.charAt(0)&&(j=+j.substring(1))&&j<=m&&(a[g]="\\"+h[j]);for(g=0;g<b;++g)"^"===a[g]&&"^"!==a[g+1]&&(a[g]="");if(f.ignoreCase&&D)for(g=0;g<b;++g)j=a[g],f=j.charAt(0),j.length>=2&&f==="["?a[g]=e(j):f!=="\\"&&(a[g]=j.replace(/[A-Za-z]/g,function(a){a=a.charCodeAt(0);return"["+String.fromCharCode(a&-33,a|32)+"]"}));return a.join("")}
for(var c=0,D=!1,o=!1,G=0,a=b.length;G<a;++G){var q=b[G];if(q.ignoreCase)o=!0;else if(/[a-z]/i.test(q.source.replace(/\\u[\da-f]{4}|\\x[\da-f]{2}|\\[^UXux]/gi,""))){D=!0;o=!1;break}}for(var k={b:8,t:9,n:10,v:11,f:12,r:13},r=[],G=0,a=b.length;G<a;++G){q=b[G];if(q.global||q.multiline)throw Error(""+q);r.push("(?:"+n(q)+")")}return RegExp(r.join("|"),o?"gi":"g")}function d(b,h){function l(b){var a=b.nodeType;if(a==1){if(!e.test(b.className)){for(a=b.firstChild;a;a=a.nextSibling)l(a);a=b.nodeName.toLowerCase();
if("br"===a||"li"===a)n[o]="\n",D[o<<1]=c++,D[o++<<1|1]=b}}else if(a==3||a==4)a=b.nodeValue,a.length&&(a=h?a.replace(/\r\n?/g,"\n"):a.replace(/[\t\n\r ]+/g," "),n[o]=a,D[o<<1]=c,c+=a.length,D[o++<<1|1]=b)}var e=/(?:^|\s)nocode(?:\s|$)/,n=[],c=0,D=[],o=0;l(b);return{a:n.join("").replace(/\n$/,""),d:D}}function p(b,h,l,e){h&&(b={a:h,e:b},l(b),e.push.apply(e,b.g))}function u(b,h){function l(b){for(var o=b.e,n=[o,"pln"],a=0,q=b.a.match(c)||[],d={},r=0,f=q.length;r<f;++r){var B=q[r],i=d[B],v=void 0,g;
if(typeof i==="string")g=!1;else{var m=e[B.charAt(0)];if(m)v=B.match(m[1]),i=m[0];else{for(g=0;g<k;++g)if(m=h[g],v=B.match(m[1])){i=m[0];break}v||(i="pln")}if((g=i.length>=5&&"lang-"===i.substring(0,5))&&!(v&&typeof v[1]==="string"))g=!1,i="src";g||(d[B]=i)}m=a;a+=B.length;if(g){g=v[1];var j=B.indexOf(g),F=j+g.length;v[2]&&(F=B.length-v[2].length,j=F-g.length);i=i.substring(5);p(o+m,B.substring(0,j),l,n);p(o+m+j,g,y(i,g),n);p(o+m+F,B.substring(F),l,n)}else n.push(o+m,i)}b.g=n}var e={},c;(function(){for(var l=
b.concat(h),o=[],k={},a=0,q=l.length;a<q;++a){var d=l[a],r=d[3];if(r)for(var f=r.length;--f>=0;)e[r.charAt(f)]=d;d=d[1];r=""+d;k.hasOwnProperty(r)||(o.push(d),k[r]=t)}o.push(/[\S\s]/);c=n(o)})();var k=h.length;return l}function s(b){var h=[],l=[];b.tripleQuotedStrings?h.push(["str",/^(?:'''(?:[^'\\]|\\[\S\s]|''?(?=[^']))*(?:'''|$)|"""(?:[^"\\]|\\[\S\s]|""?(?=[^"]))*(?:"""|$)|'(?:[^'\\]|\\[\S\s])*(?:'|$)|"(?:[^"\\]|\\[\S\s])*(?:"|$))/,t,"'\""]):b.multiLineStrings?h.push(["str",/^(?:'(?:[^'\\]|\\[\S\s])*(?:'|$)|"(?:[^"\\]|\\[\S\s])*(?:"|$)|`(?:[^\\`]|\\[\S\s])*(?:`|$))/,
t,"'\"`"]):h.push(["str",/^(?:'(?:[^\n\r'\\]|\\.)*(?:'|$)|"(?:[^\n\r"\\]|\\.)*(?:"|$))/,t,"\"'"]);b.verbatimStrings&&l.push(["str",/^@"(?:[^"]|"")*(?:"|$)/,t]);var e=b.hashComments;e&&(b.cStyleComments?(e>1?h.push(["com",/^#(?:##(?:[^#]|#(?!##))*(?:###|$)|.*)/,t,"#"]):h.push(["com",/^#(?:(?:define|e(?:l|nd)if|else|error|ifn?def|include|line|pragma|undef|warning)\b|[^\n\r]*)/,t,"#"]),l.push(["str",/^<(?:(?:(?:\.\.\/)*|\/?)(?:[\w-]+(?:\/[\w-]+)+)?[\w-]+\.h(?:h|pp|\+\+)?|[a-z]\w*)>/,t])):h.push(["com",
/^#[^\n\r]*/,t,"#"]));b.cStyleComments&&(l.push(["com",/^\/\/[^\n\r]*/,t]),l.push(["com",/^\/\*[\S\s]*?(?:\*\/|$)/,t]));b.regexLiterals&&l.push(["lang-regex",/^(?:^^\.?|[+-]|[!=]={0,2}|#|%=?|&&?=?|\(|\*=?|[+-]=|->|\/=?|::?|<<?=?|>{1,3}=?|[,;?@[{~]|\^\^?=?|\|\|?=?|break|case|continue|delete|do|else|finally|instanceof|return|throw|try|typeof)\s*(\/(?=[^*/])(?:[^/[\\]|\\[\S\s]|\[(?:[^\\\]]|\\[\S\s])*(?:]|$))+\/)/]);(e=b.types)&&l.push(["typ",e]);b=(""+b.keywords).replace(/^ | $/g,"");b.length&&l.push(["kwd",
RegExp("^(?:"+b.replace(/[\s,]+/g,"|")+")\\b"),t]);h.push(["pln",/^\s+/,t," \r\n\t\u00a0"]);l.push(["lit",/^@[$_a-z][\w$@]*/i,t],["typ",/^(?:[@_]?[A-Z]+[a-z][\w$@]*|\w+_t\b)/,t],["pln",/^[$_a-z][\w$@]*/i,t],["lit",/^(?:0x[\da-f]+|(?:\d(?:_\d+)*\d*(?:\.\d*)?|\.\d\+)(?:e[+-]?\d+)?)[a-z]*/i,t,"0123456789"],["pln",/^\\[\S\s]?/,t],["pun",/^.[^\s\w"$'./@\\`]*/,t]);return u(h,l)}function x(b,h,l){function e(a){var b=a.nodeType;if(b==1&&!c.test(a.className))if("br"===a.nodeName)n(a),a.parentNode&&a.parentNode.removeChild(a);
else for(a=a.firstChild;a;a=a.nextSibling)e(a);else if((b==3||b==4)&&l){var i=a.nodeValue,h=i.match(d);if(h)b=i.substring(0,h.index),a.nodeValue=b,(i=i.substring(h.index+h[0].length))&&a.parentNode.insertBefore(o.createTextNode(i),a.nextSibling),n(a),b||a.parentNode.removeChild(a)}}function n(b){function h(a,b){var f=b?a.cloneNode(!1):a,j=a.parentNode;if(j){var j=h(j,1),i=a.nextSibling;j.appendChild(f);for(var e=i;e;e=i)i=e.nextSibling,j.appendChild(e)}return f}for(;!b.nextSibling;)if(b=b.parentNode,
!b)return;for(var b=h(b.nextSibling,0),i;(i=b.parentNode)&&i.nodeType===1;)b=i;a.push(b)}for(var c=/(?:^|\s)nocode(?:\s|$)/,d=/\r\n?|\n/,o=b.ownerDocument,k=o.createElement("li");b.firstChild;)k.appendChild(b.firstChild);for(var a=[k],q=0;q<a.length;++q)e(a[q]);h===(h|0)&&a[0].setAttribute("value",h);var p=o.createElement("ol");p.className="linenums";for(var h=Math.max(0,h-1|0)||0,q=0,r=a.length;q<r;++q)k=a[q],k.className="L"+(q+h)%10,k.firstChild||k.appendChild(o.createTextNode("\u00a0")),p.appendChild(k);
b.appendChild(p)}function k(b,h){for(var l=h.length;--l>=0;){var e=h[l];O.hasOwnProperty(e)?P.console&&console.warn("cannot override language handler %s",e):O[e]=b}}function y(b,h){if(!b||!O.hasOwnProperty(b))b=/^\s*</.test(h)?"default-markup":"default-code";return O[b]}function E(b){var h=b.h;try{var l=d(b.c,b.i),e=l.a;b.a=e;b.d=l.d;b.e=0;y(h,e)(b);var n=/\bMSIE\s(\d+)/.exec(navigator.userAgent),n=n&&+n[1]<=8,h=/\n/g,k=b.a,c=k.length,l=0,o=b.d,p=o.length,e=0,a=b.g,q=a.length,s=0;a[q]=c;var r,f;for(f=
r=0;f<q;)a[f]!==a[f+2]?(a[r++]=a[f++],a[r++]=a[f++]):f+=2;q=r;for(f=r=0;f<q;){for(var u=a[f],i=a[f+1],v=f+2;v+2<=q&&a[v+1]===i;)v+=2;a[r++]=u;a[r++]=i;f=v}a.length=r;var g=b.c,m;if(g)m=g.style.display,g.style.display="none";try{for(;e<p;){var j=o[e+2]||c,F=a[s+2]||c,v=Math.min(j,F),C=o[e+1],Q;if(C.nodeType!==1&&(Q=k.substring(l,v))){n&&(Q=Q.replace(h,"\r"));C.nodeValue=Q;var x=C.ownerDocument,R=x.createElement("span");R.className=a[s+1];var A=C.parentNode;A.replaceChild(R,C);R.appendChild(C);l<j&&
(o[e+1]=C=x.createTextNode(k.substring(v,j)),A.insertBefore(C,R.nextSibling))}l=v;l>=j&&(e+=2);l>=F&&(s+=2)}}finally{if(g)g.style.display=m}}catch(z){P.console&&console.log(z&&z.stack?z.stack:z)}}var P=window,A=["break,continue,do,else,for,if,return,while"],I=[[A,"auto,case,char,const,default,double,enum,extern,float,goto,inline,int,long,register,short,signed,sizeof,static,struct,switch,typedef,union,unsigned,void,volatile"],"catch,class,delete,false,import,new,operator,private,protected,public,this,throw,true,try,typeof"],
z=[I,"alignof,align_union,asm,axiom,bool,concept,concept_map,const_cast,constexpr,decltype,delegate,dynamic_cast,explicit,export,friend,generic,late_check,mutable,namespace,nullptr,property,reinterpret_cast,static_assert,static_cast,template,typeid,typename,using,virtual,where"],H=[I,"abstract,assert,boolean,byte,extends,final,finally,implements,import,instanceof,interface,null,native,package,strictfp,super,synchronized,throws,transient"],J=[H,"as,base,by,checked,decimal,delegate,descending,dynamic,event,fixed,foreach,from,group,implicit,in,internal,into,is,let,lock,object,out,override,orderby,params,partial,readonly,ref,sbyte,sealed,stackalloc,string,select,uint,ulong,unchecked,unsafe,ushort,var,virtual,where"],
I=[I,"debugger,eval,export,function,get,null,set,undefined,var,with,Infinity,NaN"],K=[A,"and,as,assert,class,def,del,elif,except,exec,finally,from,global,import,in,is,lambda,nonlocal,not,or,pass,print,raise,try,with,yield,False,True,None"],L=[A,"alias,and,begin,case,class,def,defined,elsif,end,ensure,false,in,module,next,nil,not,or,redo,rescue,retry,self,super,then,true,undef,unless,until,when,yield,BEGIN,END"],N=[A,"as,assert,const,copy,drop,enum,extern,fail,false,fn,impl,let,log,loop,match,mod,move,mut,priv,pub,pure,ref,self,static,struct,true,trait,type,unsafe,use"],
A=[A,"case,done,elif,esac,eval,fi,function,in,local,set,then,until"],M=/^(DIR|FILE|vector|(de|priority_)?queue|list|stack|(const_)?iterator|(multi)?(set|map)|bitset|u?(int|float)\d*)\b/,S=/\S/,T=s({keywords:[z,J,I,"caller,delete,die,do,dump,elsif,eval,exit,foreach,for,goto,if,import,last,local,my,next,no,our,print,package,redo,require,sub,undef,unless,until,use,wantarray,while,BEGIN,END",K,L,A],hashComments:!0,cStyleComments:!0,multiLineStrings:!0,regexLiterals:!0}),O={};k(T,["default-code"]);k(u([],
[["pln",/^[^<?]+/],["dec",/^<!\w[^>]*(?:>|$)/],["com",/^<\!--[\S\s]*?(?:--\>|$)/],["lang-",/^<\?([\S\s]+?)(?:\?>|$)/],["lang-",/^<%([\S\s]+?)(?:%>|$)/],["pun",/^(?:<[%?]|[%?]>)/],["lang-",/^<xmp\b[^>]*>([\S\s]+?)<\/xmp\b[^>]*>/i],["lang-js",/^<script\b[^>]*>([\S\s]*?)(<\/script\b[^>]*>)/i],["lang-css",/^<style\b[^>]*>([\S\s]*?)(<\/style\b[^>]*>)/i],["lang-in.tag",/^(<\/?[a-z][^<>]*>)/i]]),["default-markup","htm","html","mxml","xhtml","xml","xsl"]);k(u([["pln",/^\s+/,t," \t\r\n"],["atv",/^(?:"[^"]*"?|'[^']*'?)/,
t,"\"'"]],[["tag",/^^<\/?[a-z](?:[\w-.:]*\w)?|\/?>$/i],["atn",/^(?!style[\s=]|on)[a-z](?:[\w:-]*\w)?/i],["lang-uq.val",/^=\s*([^\s"'>]*(?:[^\s"'/>]|\/(?=\s)))/],["pun",/^[/<->]+/],["lang-js",/^on\w+\s*=\s*"([^"]+)"/i],["lang-js",/^on\w+\s*=\s*'([^']+)'/i],["lang-js",/^on\w+\s*=\s*([^\s"'>]+)/i],["lang-css",/^style\s*=\s*"([^"]+)"/i],["lang-css",/^style\s*=\s*'([^']+)'/i],["lang-css",/^style\s*=\s*([^\s"'>]+)/i]]),["in.tag"]);k(u([],[["atv",/^[\S\s]+/]]),["uq.val"]);k(s({keywords:z,hashComments:!0,
cStyleComments:!0,types:M}),["c","cc","cpp","cxx","cyc","m"]);k(s({keywords:"null,true,false"}),["json"]);k(s({keywords:J,hashComments:!0,cStyleComments:!0,verbatimStrings:!0,types:M}),["cs"]);k(s({keywords:H,cStyleComments:!0}),["java"]);k(s({keywords:A,hashComments:!0,multiLineStrings:!0}),["bash","bsh","csh","sh"]);k(s({keywords:K,hashComments:!0,multiLineStrings:!0,tripleQuotedStrings:!0}),["cv","py","python"]);k(s({keywords:"caller,delete,die,do,dump,elsif,eval,exit,foreach,for,goto,if,import,last,local,my,next,no,our,print,package,redo,require,sub,undef,unless,until,use,wantarray,while,BEGIN,END",
hashComments:!0,multiLineStrings:!0,regexLiterals:!0}),["perl","pl","pm"]);k(s({keywords:L,hashComments:!0,multiLineStrings:!0,regexLiterals:!0}),["rb","ruby"]);k(s({keywords:I,cStyleComments:!0,regexLiterals:!0}),["javascript","js"]);k(s({keywords:"all,and,by,catch,class,else,extends,false,finally,for,if,in,is,isnt,loop,new,no,not,null,of,off,on,or,return,super,then,throw,true,try,unless,until,when,while,yes",hashComments:3,cStyleComments:!0,multilineStrings:!0,tripleQuotedStrings:!0,regexLiterals:!0}),
["coffee"]);k(s({keywords:N,cStyleComments:!0,multilineStrings:!0}),["rc","rs","rust"]);k(u([],[["str",/^[\S\s]+/]]),["regex"]);var U=P.PR={createSimpleLexer:u,registerLangHandler:k,sourceDecorator:s,PR_ATTRIB_NAME:"atn",PR_ATTRIB_VALUE:"atv",PR_COMMENT:"com",PR_DECLARATION:"dec",PR_KEYWORD:"kwd",PR_LITERAL:"lit",PR_NOCODE:"nocode",PR_PLAIN:"pln",PR_PUNCTUATION:"pun",PR_SOURCE:"src",PR_STRING:"str",PR_TAG:"tag",PR_TYPE:"typ",prettyPrintOne:function(b,h,l){var e=document.createElement("div");e.innerHTML=
"<pre>"+b+"</pre>";e=e.firstChild;l&&x(e,l,!0);E({h:h,j:l,c:e,i:1});return e.innerHTML},prettyPrint:c=c=function(b,h){function l(){var m;for(var h=P.PR_SHOULD_USE_CONTINUATION?a.now()+250:Infinity;q<k.length&&a.now()<h;q++){var j=k[q],e=j.className;if(f.test(e)&&!u.test(e)){for(var c=!1,d=j.parentNode;d;d=d.parentNode)if(g.test(d.tagName)&&d.className&&f.test(d.className)){c=!0;break}if(!c){j.className+=" prettyprinted";var e=e.match(r),p;if(c=!e){for(var c=j,d=void 0,o=c.firstChild;o;o=o.nextSibling)var w=
o.nodeType,d=w===1?d?c:o:w===3?S.test(o.nodeValue)?c:d:d;c=(p=d===c?void 0:d)&&v.test(p.tagName)}c&&(e=p.className.match(r));e&&(e=e[1]);i.test(j.tagName)?c=1:(c=j.currentStyle,d=n.defaultView,m=(c=c?c.whiteSpace:d&&d.getComputedStyle?d.getComputedStyle(j,t).getPropertyValue("white-space"):0)&&"pre"===c.substring(0,3),c=m);(d=(d=j.className.match(/\blinenums\b(?::(\d+))?/))?d[1]&&d[1].length?+d[1]:!0:!1)&&x(j,d,c);s={h:e,c:j,j:d,i:c};E(s)}}}q<k.length?setTimeout(l,250):"function"===typeof b&&b()}
for(var e=h||document.body,n=e.ownerDocument||document,e=[e.getElementsByTagName("pre"),e.getElementsByTagName("code"),e.getElementsByTagName("xmp")],k=[],c=0;c<e.length;++c)for(var d=0,p=e[c].length;d<p;++d)k.push(e[c][d]);var e=t,a=Date;a.now||(a={now:function(){return+new Date}});var q=0,s,r=/\blang(?:uage)?-([\w.]+)(?!\S)/,f=/\bprettyprint\b/,u=/\bprettyprinted\b/,i=/pre|xmp/i,v=/^code$/i,g=/^(?:pre|code|xmp)$/i;l()}};typeof define==="function"&&define.amd&&define("google-code-prettify",[],function(){return U})})();
return c}();if(M)(x.code_google_com_googleprettify||(x.code_google_com_googleprettify={})).run=function(){S(function(){var c=H.length;T(c?function(){for(var d=0;d<c;++d)(function(c){setTimeout(function(){x.exports[H[c]].apply(x,arguments)},0)})(d)}:void 0)})},d=c.createElement("script"),d.type="text/javascript",d.appendChild(c.createTextNode("code_google_com_googleprettify.run()")),(c.body||c.documentElement).appendChild(d)})();}()