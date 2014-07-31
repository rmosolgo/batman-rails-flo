var flo = require('fb-flo'),
    path = require('path'),
    fs = require('fs'),
    coffee = require('coffee-script');

var sourceDirToWatch = "./app/assets/";

var server = flo(
  sourceDirToWatch,
  {
    port: 8888,
    host: 'localhost',
    verbose: false,
    glob: [
      '**/*.coffee',
      '**/*.html*', // * to all .html.slim and friends
      '**/*.css*'
    ]
  },
  resolver
);

function resolver(filepath, callback) {
  try {
    var isHTML = filepath.indexOf(".html") > -1;
    var isCSS = filepath.indexOf(".css") > -1;

    var contents = fs.readFileSync(sourceDirToWatch + filepath).toString()
    var folderName = filepath
      .replace(/batman\//, '') // It's not in the asset path
      .replace(/\.coffee/, '');
    var fileURL = 'assets/' + folderName

    if (filepath.indexOf(".coffee") > -1 ) {
      // for a coffeescript file, compile it then send its contents
      contents = coffee.compile(contents);
      console.log("COFFEE", filepath)
      if (fileURL.indexOf(".js") == -1) {
        fileURL = fileURL + ".js" // In case it's just my_model.coffee
      }
    } else if (isHTML) {
      // for HTML, just send the path. We'll reload it from the asset pipeline
      // in case there are any preprocessors involved.
      contents = "HTML>>" + fileURL
      console.log("HTML", contents)
      fileURL = "/assets/batman/live_reload.js"
    } else if (isCSS) {
      // for CSS, blank out the contents.
      // Again, we'll reload it from the asset pipeline in case there
      // are any preprocessors involved
      fileURL = fileURL
        .match(/(.*\.css)/, '$1')[0]  // remove any preprocessors
        .replace(/\/stylesheets/, "") // remove unneeded path
      console.log("CSS", fileURL)
      contents = "" // we'll force reload on the client
    }

    callback({
      resourceURL: fileURL,
      contents: contents,
      match: "indexOf",
    });
  }
  catch (err) {
    console.log(err);
  }
}