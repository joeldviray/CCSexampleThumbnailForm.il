/* CCSexampleThumbnailForm.il

Language   SKILL
Date       Mar 13, 2014 

Example of showing a thumbnail icon on a form - showing
the thumbnail of the lib/cell/view.

The key is that the field is a label field, where the icon
is updated dynamically based on changes in the lib/cell/view
fields.

Also shows an HTML tooltip over the icon to show the thumbnail
in more detail.

To invoke, call CCSexampleThumbnailForm()

***************************************************

SCCS Info: @(#) CCSexampleThumbnailForm.il 03/13/14.12:47:00 1.1

*/

/*******************************************************************************
*  DISCLAIMER: The following code is provided for Cadence customers to use at  *
*   their own risk. The code may require modification to satisfy the           *
*   requirements of any user. The code and any modifications to the code may   *
*   not be compatible with current or future versions of Cadence products.     *
*   THE CODE IS PROVIDED "AS IS" AND WITH NO WARRANTIES, INCLUDING WITHOUT     *
*   LIMITATION ANY EXPRESS WARRANTIES OR IMPLIED WARRANTIES OF MERCHANTABILITY *
*   OR FITNESS FOR A PARTICULAR USE.                                           *
*******************************************************************************/


/***************************************************************
*                                                              *
*               CCScreateExampleThumbnailForm()                *
*                                                              *
*                   Create the example form.                   *
*                                                              *
***************************************************************/

procedure(CCScreateExampleThumbnailForm()
    let((lib cell view thumbnailIcon browse)
        lib=hiCreateStringField(
            ?name 'lib
            ?prompt "Library"
            ?callback "CCSexampleThumbnailSyncWithForm(hiGetCurrentForm() 'lib)"
        )
        cell=hiCreateStringField(
            ?name 'cell
            ?prompt "Cell"
            ?callback "CCSexampleThumbnailSyncWithForm(hiGetCurrentForm() 'cell)"
        )
        view=hiCreateStringField(
            ?name 'view
            ?prompt "View"
            ?callback "CCSexampleThumbnailSyncWithForm(hiGetCurrentForm() 'view)"
        )
        ;----------------------------------------------------------------
        ; Create a thumbnail with the labelText set to an (almost)
        ; empty string. It needs to have a space in it because either
        ; the labelText or labelIcon have to be specified.
        ;----------------------------------------------------------------
        thumbnailIcon=hiCreateLabel(
            ?name 'thumbnailIcon
            ?labelText " "
        )
        browse=hiCreateButton(
            ?buttonText "Browse"
            ?name 'browse
            ?callback "CCSexampleThumbnailSyncWithBrowser(hiGetCurrentForm())"
        )
        hiCreateAppForm(
            ?name 'CCSexampleThumbnailForm
            ?formTitle "Example Thumbnail Form"
            ?fields
                list(
                    list(lib 0:0 400:30 100)
                    list(cell 0:30 400:30 100)
                    list(view 0:60 400:30 100)
                    list(thumbnailIcon 420:5 64:64)
                    list(browse 100:90 100:30)
                )
            ?attachmentList
                list(
                    hicLeftPositionSet|hicRightPositionSet|hicTopPositionSet
                    hicLeftPositionSet|hicRightPositionSet|hicTopPositionSet
                    hicLeftPositionSet|hicRightPositionSet|hicTopPositionSet
                    hicRightPositionSet|hicTopPositionSet
                    hicLeftPositionSet|hicTopPositionSet
                )
            ?initialSize 500:120
        )
        CCSexampleThumbnailForm
    )
)

/***************************************************************
*                                                              *
*          CCSexampleThumbnailSyncWithBrowser(form)            *
*                                                              *
*                   Launch the file browser                    *
*                                                              *
***************************************************************/

procedure(CCSexampleThumbnailSyncWithBrowser(form)
    ddsSyncWithForm(form 'browse 'lib 'cell 'view)
)
    
/***************************************************************
*                                                              *
*        CCSexampleThumbnailSyncWithForm(form _field)          *
*                                                              *
* Synchronize changes in the typed-in fields with the browser. *
*                 Also updates the thumbnail.                  *
*                                                              *
***************************************************************/

procedure(CCSexampleThumbnailSyncWithForm(form _field)
    ddsUpdateSyncWithForm()
    CCSexampleThumbnailUpdateIcon(form)
)

/***************************************************************
*                                                              *
*             CCSexampleThumbnailUpdateIcon(form)              *
*                                                              *
* Update the icon on the form - either to the thumbnail image  *
* or to blank if the view doesn't have one or it is an invalid *
*                          view name                           *
*                                                              *
***************************************************************/

procedure(CCSexampleThumbnailUpdateIcon(form)
    let((lib cell view icon file)
        lib=form->lib->value
        cell=form->cell->value
        view=form->view->value
        unless(blankstrp(lib) || blankstrp(cell) || blankstrp(view)
            file=ddGetObj(lib cell view hiGetThumbnailFilename())->readPath
            when(file
                icon=hiLoadImageFile(file 64 64)
            )
        )
        unless(icon
            icon=" "
        )
        form->thumbnailIcon->value=icon
        if(file then
            ;------------------------------------------------------------
            ; Fancy tooltip using HTML
            ;------------------------------------------------------------
            form->thumbnailIcon->hiToolTip=sprintf(nil "<table><tr bgcolor='black'><td><center><img src='%s'></center></td></tr><tr><td>%s %s %s</tr></td></table>" file lib cell view)
        else
            form->thumbnailIcon->hiToolTip=""
        )
    )
)


/***************************************************************
*                                                              *
*                  CCSexampleThumbnailForm()                   *
*                                                              *
*            Main function - show the example form.            *
*                                                              *
***************************************************************/

procedure(CCSexampleThumbnailForm()
    unless(boundp('CCSexampleThumbnailForm)
        CCScreateExampleThumbnailForm()
    )
    ;--------------------------------------------------------------------
    ; Update the thumbnail in the case that the field values
    ; have been changed outside the function.
    ;--------------------------------------------------------------------
    CCSexampleThumbnailUpdateIcon(CCSexampleThumbnailForm)
    hiDisplayForm(CCSexampleThumbnailForm)
)
