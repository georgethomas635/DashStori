//
//  Constants.swift
//  DashStori
//
//  Created by George on 20/03/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import Foundation


var CLIENTID = "362302626154-5n9novmvf1vpkoabqtqkfdtr053p2nva.apps.googleusercontent.com"
// MARK: API Request URL
var BASE_URL:String = "https://www.dashstori.com/dashstori/api/v1/" //"http://10.7.60.12:8080/api/v1/"
var BASE: String = "https://www.dashstori.com/" //"http://34.223.236.107/"
var IMAGE_URL:String = "" //Local http://10.7.60.12:8080/api/v1/
var LOGIN:String = "login"
var SIGNUP:String = "signup"
var PUBLISH_STORI = "create_stori"
var LIST_OF_STORIES:String = "stories?page="
var UPDATE_PROFILE = "update"
var LOGOUT = "logout"
var STORI_DETAILS = "full_stori/"
var AUTHOR_DETAILS = "author_profile/"
var EDIT_STORI = "edit_stori/"
var DELETE_STORI = "delete_stori/"
var UPDATESTORI = "edit_stori_mob/"
var CONTACTUS = "contact_us"
var FORGOT_PASSWORD = "forgot-password"
var REPORT_STORI = "report_stori"
var STORIS_AROUND_ME = "storis_around_me"

var MYSTORY = "mystori"
var LATESTSTORI = "latest_stori"
var MY_STORI = "MyStori"
var LATEST_STORI = "LatestStori"
var COLOR_RED = "FF2828"
var COLOR_ASH = "5C5B5B"
var DARK_GRAY = "141414"

var START_STORI = "start stori here"
var LINK = "Link(s):"
var RELATED_DOCUMENTS = "Related Documents"
var VIDEO = "Video(s)"

var UPLOAD_FILES = "Upload file(s)"
var ADD_URL = "add url"
var ADD_VIDEO_URL = "add video url"
var OK = "OK"
var CANCEL = "Cancel"
var GOOGLE = "google"
var FACEBOOK = "facebook"
var UPDATE_STORI = "Update Stori"
var PUBLISH = "Publish Stori"
var EDIT_PAGE_HEADING = "  Edit Stori"
var WRITE_PAGE_HEADING = "  Write Stori"
var DELETE = "Delete"
var CONFORMATION_DELETION = "Are you sure you want to delete this stori?"
var REPORT_ABUSE = "Report Abuse"

let USER_LOCKED_ERROR = "Your account is locked, please contact DashStori at contactus@dashstori.com"

//MARK: HTTP Status codes
public let HTTP_STATUS_OK                      = 200
public let HTTP_STATUS_CREATED                 = 201
public let HTTP_STATUS_ACCEPTED                = 202
public let HTTP_STATUS_PARTIAL_RESPONSE        = 203
public let HTTP_STATUS_NO_CONTENT              = 204

public let HTTP_STATUS_MOVED                   = 301
public let HTTP_STATUS_FOUND                   = 302
public let HTTP_STATUS_METHOD                  = 303
public let HTTP_STATUS_NOT_MODIFIED            = 303

public let HTTP_STATUS_BAD_REQUEST             = 400
public let HTTP_STATUS_UNAUTHORIZED            = 401
public let HTTP_STATUS_FORBIDDEN               = 403
public let HTTP_STATUS_NOT_FOUND               = 404

public let HTTP_STATUS_INTERNAL_SERVER_ERROR   = 500
public let HTTP_STATUS_NOT_IMPLEMENTED         = 501
public let HTTP_STATUS_SERVICE_OVERLOADED      = 502
public let HTTP_STATUS_GATEWAY_TIMEOUT         = 503

//MARK: app utility Keys
public let ErrorLocalizedDescription = "NSLocalizedDescription"

var RESIZE_WIDTH = 500
