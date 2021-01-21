// ---------------------------------------------------------------------------
// mquery.js
//
// This function allows me to query the remote server through a CGI process
// to get a JSOON string back
// ---------------------------------------------------------------------------


// ------------------------------------------------------------------------------
// This function parses JSON into CVS
// ------------------------------------------------------------------------------
function JSON2CSV(objArray) {
    var array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;

    var str = '';
    var line = '';

    if ($("#labels").is(':checked')) {
        var head = array[0];
        if ($("#quote").is(':checked')) {
            for (var index in array[0]) {
                var value = index + "";
                line += '"' + value.replace(/"/g, '""') + '",';
            }
        } else {
            for (var index in array[0]) {
                line += index + ',';
            }
        }

        line = line.slice(0, -1);
        str += line + '\r\n';
    }

    for (var i = 0; i < array.length; i++) {
        var line = '';

        if ($("#quote").is(':checked')) {
            for (var index in array[i]) {
                var value = array[i][index] + "";
                line += '"' + value.replace(/"/g, '""') + '",';
            }
        } else {
            for (var index in array[i]) {
                line += array[i][index] + ',';
            }
        }

        line = line.slice(0, -1);
        str += line + '\r\n';
    }
    return str;

}

// ------------------------------------------------------------------------------
// This takes a json stream and downloads it to a local csv file
// ------------------------------------------------------------------------------
function json_to_csvfile(data, docname)    {
    // Parse the JSON to CSV
    var csv = JSON2CSV(data);
 
    // This is to save the craeted csv data into a local file named
    // database.csv.
    var downloadLink = document.createElement("a");
    var blob = new Blob(["\ufeff", csv]);
    var url = URL.createObjectURL(blob);
    downloadLink.href = url;
    downloadLink.download = docname;
    document.body.appendChild(downloadLink);
    downloadLink.click();
    document.body.removeChild(downloadLink);
}

// --------------------------------------------------------------------------------
// This calls databasedump.rb on the server which will dump the contents of the
// database into a json string of elements after removing IDs
// --------------------------------------------------------------------------------
function csv_request(where, param_string, docname) {
    var http = new XMLHttpRequest();
    var url = where;

    http.open("POST", url, true);

    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

    http.onreadystatechange = function() {
        if(http.readyState == 4 && http.status == 200) {
            var obj = JSON.parse(http.responseText);
            json_to_csvfile(obj, docname);
        }
    }
    http.send(param_string);
}

