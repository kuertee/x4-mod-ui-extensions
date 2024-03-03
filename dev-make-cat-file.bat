cd ..\..

XRCatTool.exe -dump -include ".lua" ".xpl" ".xml" -exclude "content.xml" -in "extensions\kuertee_ui_extensions" -out "extensions\kuertee_ui_extensions\subst_01.cat"

set /p DUMMY=Hit ENTER to exit...
