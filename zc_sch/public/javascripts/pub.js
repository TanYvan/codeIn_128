function page_check()
{
    if ( /^[1-9]d*$/.test(document.getElementById('page').value)  &&  /^[1-9]d*$/.test(document.getElementById('page_lines').value) )
    {
        return true;
    }
    else
    {
        alert('翻页信息非法！');
        return false;
    }
}  

function to_excel(obj) {
    //obj为某个table  document.getElementById，copy到excel
    window.clipboardData.setData("Text",obj.outerHTML);   //document.all('tt')
    try
    {
        var ExApp = new ActiveXObject("Excel.Application")
        var ExWBk = ExApp.workbooks.add()
        var ExWSh = ExWBk.worksheets(1)
        ExApp.DisplayAlerts = false
        ExApp.visible = true
    }
    catch(e)
    {
        alert("您的电脑没有安装Microsoft Excel软件！")
        return false
    }
    ExWBk.worksheets(1).Paste;
    window.clipboardData.setData("Text","")
}

function   to_word() {
    //取整个页面,copy到word
    document.execCommand("SelectAll");
    document.execCommand("Copy");
    try
    {
        var   WordApp=new   ActiveXObject("Word.Application");
        WordApp.Application.Visible=true;
        var   Doc=WordApp.Documents.Add();
        Doc.Activate();
        Doc.Content.Paste();  
        WordApp.visible = true
    }
    catch(e)
    {
        alert("您的电脑没有安装Microsoft Word软件！")
        return false
    }
    Doc.Content.Paste();
}

