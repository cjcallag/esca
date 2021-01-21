
var selected;

// --------------------------------------------------------------------------------------
// Function called by the export CSV button
// Use the last search, remove the _id keys and send it to a local file
// Also translate dates from numbers
// -------------------------------------------------------------------------------------
function search_export()    {
    var l_json = JSON.parse(localStorage.getItem('Results'));
    l_json.forEach( function(element) { delete element._id; });
    l_json.forEach( function(element) { element.starttime = new Date(parseInt(element.starttime)); });
    l_json.forEach( function(element) { element.donetime = new Date(parseInt(element.donetime)); });
    json_to_csvfile(l_json, "search.csv");
}

// -----------------------------------------------------------------------------------
// This builds an entry table from a JSON structure that contains participants
// -----------------------------------------------------------------------------------
function myCreateFunction(l_json) {
        var tablecont = document.getElementById("MyTable");
        
        var table = document.createElement("TABLE");
        table.style.width = '100%';
        table.border = "1";
        var row = table.insertRow(-1);
        var cell1 = row.insertCell(0);
        var cell2 = row.insertCell(1);
        var cell3 = row.insertCell(2);
        var cell4 = row.insertCell(3);
        var cell5 = row.insertCell(4);
        var cell6 = row.insertCell(5);
        var cell7 = row.insertCell(6);
        var cell8 = row.insertCell(7);
        var cell9 = row.insertCell(8);
        var cell10 = row.insertCell(9);
        cell1.innerHTML = "<u>Num</u>".bold();
        cell2.innerHTML = "<u>Name</u>".bold();
        cell3.innerHTML = "<u>Email</u>".bold();
        cell4.innerHTML = "<u>Employer</u>".bold();
        cell5.innerHTML = "<u>Group</u>".bold();
        cell6.innerHTML = "<u>Member</u>".bold();
        cell7.innerHTML = "<u>Complete</u>".bold();
        cell8.innerHTML = "<u>Cert #</u>".bold();
        cell9.innerHTML = "<u>Finished</u>".bold();
        cell10.innerHTML = "<u>Start</u>".bold();
        for (i=0; i<l_json.length;i++)   {
            var row = table.insertRow(-1);
            row.entry = l_json[i];
            // ------------------------------------------------------------------
            // Add a high light function
            // This also sets the current ID to the JSON ID
            // ------------------------------------------------------------------
            row.onclick= function(){
                unhighlight();
                this.origColor=this.style.backgroundColor;
                this.style.backgroundColor='#BCD4EC';
                this.hilite = true;
                selected = this.entry;
                window.currentSelection = this.cells[0].innerHTML;
            }; 
            var cell1 = row.insertCell(0);
            var cell2 = row.insertCell(1);
            var cell3 = row.insertCell(2);
            var cell4 = row.insertCell(3);
            var cell5 = row.insertCell(4);
            var cell6 = row.insertCell(5);
            var cell7 = row.insertCell(6);
            var cell8 = row.insertCell(7);
            var cell9 = row.insertCell(8);
            var cell10 = row.insertCell(9);
            cell1.innerHTML = (i + 1).toString();
            var name = l_json[i]["fname"] + " " + l_json[i]["last"]; 
            cell2.innerHTML = name;
            cell3.innerHTML = l_json[i]["email"];
            cell4.innerHTML = l_json[i]["employer"];
            cell5.innerHTML = l_json[i]["group"];
            cell6.innerHTML = l_json[i]["member"];
            complete = l_json[i]["complete"];
            cell7.innerHTML = complete;

            group = l_json[i]["group"];

						if (group == 'NoCredit') {
                cell8.innerHTML = "";
						}
            else if (complete != 'true') {
                cell8.innerHTML = "Incomplete";
            }
            else {
                cell8.innerHTML = l_json[i]["idval"];
            }

            var datenum = parseInt(l_json[i]["donetime"]);
            if (datenum <= 1000)  {
                cell9.innerHTML = "Incomplete";
            }
            else {
                cell9.innerHTML = new Date(datenum);
            }
            var sdatenum = parseInt(l_json[i]["starttime"]);
            cell10.innerHTML = new Date(sdatenum);
        }
        
        tablecont.innerHTML = "";
        tablecont.appendChild(table);
}

function createtable() {
    l_json = JSON.parse(localStorage.getItem('Results'));
    myCreateFunction(l_json);
    window.currentSelection = "None";
}

function unhighlight(){
   var tablecont = document.getElementById("MyTable");
   var table = tablecont.firstChild;
   for (var i=0;i < table.rows.length;i++){
       var row = table.rows[i];
       row.style.backgroundColor='#C1BFC7';
       row.hilite = false;
   }
}

function deleteid() {
    if (selected == null){
        alert("You must select an item if you wish to delete it");
        return;
    }
    var l_id = selected._id["$oid"]
    var l_search = localStorage.getItem('LastSearch');
    post('/cgi-bin/dodelete.rb', {'id' : l_id, 'lastsearch' : l_search });
}

function download() {
    if (selected == null){
        alert("You must select an item if you wish to delete it");
        return;
    }
    var l_id = selected._id["$oid"]
    var l_search = localStorage.getItem('LastSearch');
    post('/cgi-bin/download2_pdf.rb', {'id' : l_id, 'lastsearch' : l_search });
}

function add_entry()    {
    localStorage.setItem('fname','');
    localStorage.setItem('last','');
    localStorage.setItem('email','');
    localStorage.setItem('employer','');
    localStorage.setItem('group','');
    localStorage.setItem('membert','');
    localStorage.setItem('complete','false');
    localStorage.setItem('starttime','');
    localStorage.setItem('donetime','');
    localStorage.setItem('idval','');
    localStorage.setItem('ID','0');
    window.location.href = "editentry.html";
}

function jump_to_completion() {
    if (selected == null) {
        alert("You must select an item if you wish to edit it");
        return;
    }

// This is messed up.... different name used in different places. Yikes Need to fix
    localStorage.setItem("Mode","individual");

    localStorage.setItem('fname',selected["fname"]);
    localStorage.setItem('last',selected["last"]);

    localStorage.setItem('FirstName',selected["fname"]);
    localStorage.setItem('LastName',selected["last"]);

    localStorage.setItem('email',selected["email"]);
    localStorage.setItem('Email',selected["email"]);
    localStorage.setItem('employer',selected["employer"]);
    localStorage.setItem('Employer',selected["employer"]);
    localStorage.setItem('group',selected["group"]);
    localStorage.setItem('member',selected["member"]);
    localStorage.setItem('complete',selected["complete"]);
    localStorage.setItem('starttime',selected["starttime"]);
    localStorage.setItem('donetime',selected["donetime"]);
    localStorage.setItem('idval',selected["idval"]);
    localStorage.setItem('ID',selected._id["$oid"]);
    window.location.href = "page-7.html";
} 

function edit_entry()   {
    if (selected == null) {
        alert("You must select an item if you wish to edit it");
        return;
    }

    localStorage.setItem('fname',selected["fname"]);
    localStorage.setItem('last',selected["last"]);
    localStorage.setItem('email',selected["email"]);
    localStorage.setItem('employer',selected["employer"]);
    localStorage.setItem('group',selected["group"]);
    localStorage.setItem('member',selected["member"]);
    localStorage.setItem('complete',selected["complete"]);
    localStorage.setItem('starttime',selected["starttime"]);
    localStorage.setItem('donetime',selected["donetime"]);
    localStorage.setItem('idval',selected["idval"]);
    localStorage.setItem('ID',selected._id["$oid"]);
    window.location.href = "editentry.html";
}

function post(path, params, method) {
    method = method || "post"; // Set method to post by default if not specified.

    // The rest of this code assumes you are not using a library.
    // It can be made less wordy if you use one.
    var form = document.createElement("form");
    form.setAttribute("method", method);
    form.setAttribute("action", path);

    for(var key in params) {
        if(params.hasOwnProperty(key)) {
            var hiddenField = document.createElement("input");
            hiddenField.setAttribute("type", "hidden");
            hiddenField.setAttribute("name", key);
            hiddenField.setAttribute("value", params[key]);

            form.appendChild(hiddenField);
        }
    }

    document.body.appendChild(form);
    form.submit();
}
    


