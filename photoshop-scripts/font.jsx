function main(){
Stdlib = function Stdlib() {};
Stdlib.findFiles = function(folder, mask) {//from Xbytor's Xtools
     var files = Stdlib.getFiles(folder, mask);
     var folders = Stdlib.getFolders(folder);

     for (var i = 0; i < folders.length; i++) {
       var f = folders[i];
       var ffs = Stdlib.findFiles(f, mask);
       while (ffs.length > 0) {
         files.push(ffs.shift());
       }
     }
     return files;
   };

   Folder.prototype.findFiles = function(mask) {
     return Stdlib.findFiles(this, mask);
   };
   Stdlib.getFiles = function(folder, mask) {
  var files = [];
  var getF;
  if (Folder.prototype._getFiles) {
    getF = function(f, m) { return f._getFiles(m); }
  } else {
    getF = function(f, m) { return f.getFiles(m); }
  }

  if (mask instanceof RegExp) {
    var allFiles = getF(folder);
    for (var i = 0; i < allFiles.length; i = i + 1) {
      var f = allFiles[i];
      if (decodeURI(f.absoluteURI).match(mask)) {
        files.push(f);
      }
    }
  } else if (typeof mask == "function") {
    var allFiles = getF(folder);
    for (var i = 0; i < allFiles.length; i = i + 1) {
      var f = allFiles[i];
      if (mask(f)) {
        files.push(f);
      }
    }
  } else {
    files = getF(folder, mask);
  }

  return files;
};
Stdlib.getFolders = function(folder) {
  return Stdlib.getFiles(folder, function(file) {
                           return file instanceof Folder; });
}
   
function getDocFonts(){
function traverseLayers (doc, ftn, reverse) { //from Xbytor

  function _traverse(doc, layers, ftn, reverse) {
    var ok = true;
    for (var i = 1; i <= layers.length && ok != false; i++) {
      var index = (reverse == true) ? layers.length-i : i - 1;
      var layer = layers[index];

      if (layer.typename == "LayerSet") {
        ok = _traverse(doc, layer.layers, ftn, reverse);
      } else {
        ok = ftn(doc, layer);
      }
    }
    return ok;
  };

  return _traverse(doc, doc.layers, ftn, reverse);
};
function getLayersList(doc, reverse) {
  function _ftn(doc, layer) {

   if(layer.kind == LayerKind.TEXT){ _ftn.list.push(layer);};
  };

  _ftn.list = [];
  traverseLayers(doc, _ftn, reverse);

  return _ftn.list;
};
Array.prototype.add = function(obj) { //from Andrew Hall
   if (this.toString().search(RegExp("(?:^|,)" + obj.toString() + "(?:$|,)")) == -1) this.push(obj);
};
function getFontInfo(){
   var info = new Array;
   var ref = new ActionReference();
      ref.putEnumerated( stringIDToTypeID( "layer" ), charIDToTypeID( "Ordn" ), charIDToTypeID( "Trgt" ));
   var desc= executeActionGet( ref )
   var list =  desc.getObjectValue(charIDToTypeID("Txt ")) ;
   var tsr =  list.getList(charIDToTypeID("Txtt")) ;
   for(var i = 0;i<tsr.count;i++){
      var tsr0 =  tsr.getObjectValue(i) ; 
      var textStyle = tsr0.getObjectValue(charIDToTypeID("TxtS"));
      var font = textStyle.getString(charIDToTypeID("FntN" ));
      var style = textStyle.getString(charIDToTypeID( "FntS" ));
      font = font+"-"+style;
        info.add(font);
         }
   return info;
};

   
var doc = app.activeDocument;
var allLayers = getLayersList(doc);
if (allLayers.length>0){
   var allFonts = new Array;
   for(var i = 0;i<allLayers.length;i++){
       if(allLayers[i].kind == LayerKind.TEXT){
        app.activeDocument.activeLayer = allLayers[i];
        allFonts.add(getFontInfo());
      }
     };
   }
return allFonts;
};


var listOfFonts =  new Array;
var selectedFolder = Folder.selectDialog( "Please select the input folder", Folder( "~" ) );
if(selectedFolder == null) return;
var psdFiles = selectedFolder.findFiles(/\.psd$|\.PSD$/);
   for(var i = 0;i < psdFiles.length; i++){
      var doc = open(psdFiles[i]);
      var test = getDocFonts();
      if(test != undefined){
         listOfFonts.push([psdFiles[i].name,test])
      };
      doc.close(SaveOptions.DONOTSAVECHANGES);
   };
   
var f = new File(selectedFolder+"/fonts.txt") ;
if (!f.open("w")) {
    throw "Unable to open file: " + f.error;
};
f.writeln("File,Fonts");
var fullList = new Array;
for(var i = 0;i<listOfFonts.length;i++){
   f.writeln(listOfFonts[i]);
   if(listOfFonts[i][1].length == 1){
      fullList.add(listOfFonts[i][1]);
   }else{
      for(var idx = 0; idx<listOfFonts[i][1].length;idx++){
         fullList.add(listOfFonts[i][1][idx].shift());
      };
   };   
};
f.writeln();
f.writeln("List of fonts used in all documents")
fullList.sort();
for(var i = 0;i<fullList.length;i++){
   f.writeln(fullList[i]);
   };
f.close();
};
main();