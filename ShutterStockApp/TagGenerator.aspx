<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TagGenerator.aspx.cs" Inherits="ShutterStockApp.TagGenerator" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <title>Tags</title>

    <!--STYLES-->
    <script src="Scripts/jquery-3.2.1.js"></script>
    <script src="Scripts/jquery-3.2.1.min.js"></script>
    <script src="Scripts/jquery-3.2.1.slim.js"></script>
    <script src="Scripts/jquery-3.2.1.slim.min.js"></script>
    <link href="Content/bootstrap-theme.css" rel="stylesheet" />
    <link href="Content/bootstrap-theme.min.css" rel="stylesheet" />
    <link href="Content/bootstrap.css" rel="stylesheet" />
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <link href="Content/Site.css" rel="stylesheet" />
    <script src="Scripts/bootstrap.js"></script>
    <script src="Scripts/bootstrap.min.js"></script>
    <script src="Scripts/modernizr-2.6.2.js"></script>
    <script src="Scripts/respond.js"></script>
    <script src="Scripts/respond.min.js"></script>
    <script src="Scripts/_references.js"></script>
    <!--STYLES-->

    <!-- SCRIPTS -->
    <script src="Scripts/jquery-3.2.1.min.js"></script>
    <script type="text/javascript" language="javascript">

        var API_URL = 'https://api.shutterstock.com/v2';

        // Base 64 encode Client ID and Client Secret for use in the Authorization header
        function encodeAuthorization() {
            var clientId = 'f1fd4-a25d6-cdb38-b1109-fb79d-49523';
            var clientSecret = 'b8ac3-250b8-0a199-28846-de07c-154dc';

            if (!clientId || !clientSecret) {
                $('#collapseAuthentication').collapse('show');
                alert('Client id and/or client secret are missing in the API key section, with out these you wont be able to contact the API.');
                return;
            }
            return 'Basic ' + window.btoa(clientId + ':' + clientSecret);
        }
        function encodeAuthorizationImageId() {
            var clientId = 'cb772-e9c3f-63317-86051-04262-3c51f';
            var clientSecret = 'dcfc7-feea4-0393c-e5a0d-05ecc-44e96';

            if (!clientId || !clientSecret) {
                $('#collapseAuthentication').collapse('show');
                alert('Client id and/or client secret are missing in the API key section, with out these you wont be able to contact the API.');
                return;
            }
            return 'Basic ' + window.btoa(clientId + ':' + clientSecret);
        }


        function getShutterImages() {

            var param = {};
            var returnObj = [];
            var authorization = encodeAuthorizationImageId();
            $.ajax({
                type: 'GET',
                url: 'https://api.shutterstock.com/v2/images/search?query=istanbul&sort=popular&view=minimal',
                data: JSON.stringify(param),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                async: false,
                headers: {
                    Authorization: authorization
                },
                success: function (data) {
                    //returnObj = JSON.parse(data.data);
                    returnObj = data.data;
                },
                error: function (xhr, status, error) {
                    var msg = JSON.parse(xhr.responseText);
                    showModal(msg);
                }
            });

            return returnObj;
        }
        function getShutterImageId(tagId) {
            //https://api.shutterstock.com/v2/images/750576661?view=full
            var inputUrl = 'https://api.shutterstock.com/v2/images/{0}?view=full';
            inputUrl = inputUrl.replace('{0}', tagId);
            var param = {};
            var returnObj = [];
            var authorization = encodeAuthorizationImageId();
            $.ajax({
                type: 'GET',
                url: inputUrl,
                data: JSON.stringify(param),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                async: false,
                headers: {
                    Authorization: authorization
                },
                success: function (data) {
                    //returnObj = JSON.parse(data.data);
                    returnObj = data.keywords;
                },
                error: function (xhr, status, error) {
                    var msg = JSON.parse(xhr);
                    showModal(msg);
                }
            });

            return returnObj;
        }
        function getStrategyDetail() {

            var param = 'istanbul';
            var returnObj;

            $.ajax({
                type: 'Post',
                url: 'Tags.aspx/GetShutterImages',
                data: JSON.stringify(param),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                async: false,
                success: function (data) {
                    returnObj = JSON.parse(data.keywords);
                },
                error: function (xhr, status, error) {
                    var msg = JSON.parse(xhr.responseText);
                    showModal(msg);
                }
            });

            return returnObj;
        }

        function getUrl(url) {
            var Httpreq = new XMLHttpRequest(); // a new request
            Httpreq.open("GET", url, false);
            Httpreq.send(null);
            return Httpreq.responseText;
        }
        function getShutterImagesV2() {
            var url = 'https://www.shutterstock.com/search?search_source=base_landing_page&language=en&searchterm=istanbul&image_type=all';
            var json_obj = JSON.parse(getUrl(url));
        }
        $(document).ready(function (e) {
            $.session = new Object();

            //$(document).on({
            //    ajaxStart: (function () {
            //        //showLoading();
            //    }),
            //    ajaxStop: (function () {
            //        //hideLoading();
            //    })
            //});
            $('#tagList').val();

            $('#BtnSearch').click(function () {
                //getShutterImagesV2()
                //var images = getShutterImages();
                var tagId = $('#tags').val();
                var imageTagList = getShutterImageId(tagId);
                var tagList = "";

                //$.each(images, function () {
                //    imgList += '<td><img src= "' + this.assets.preview.url + '"></td>';
                //});
                //$('#dvImagePreview1').append(imgList);

                $.each(imageTagList, function () {
                    tagList += this + ', ';
                });
                //$('#divTagList').val(tagList);
                $('#tagList').val(tagList);
            });

        });
    </script>
    <!-- SCRIPTS -->
</head>

<body>
    <form>
        <div class="container">

            <div class="jumbotron row">
                <h1>Tags:</h1>
                <div>
                    <p>
                        <input class="form-control col-xs-4 input-lg" id="tags" type="text" placeholder="Search..">
                    </p>
                    <p>
                        <button type="submit" id="BtnSearch" onclick="return false;" class="btn btn-primary btn-lg" value="">Gönder</button>
                    </p>
                </div>
            </div>
            <div class="jumbotron row" id="divTagList">
                <input class="form-control " id="tagList" type="text" value ="">
            </div>

            <div class="jumbotron row" id="dvImagePreview1">
            </div>
            <div class="jumbotron row" id="dvImagePreview">
                <td>
                    <img src="https://image.shutterstock.com/display_pic_with_logo/696496/291252509/stock-photo-istanbul-the-capital-of-turkey-eastern-tourist-city-291252509.jpg"></td>
                <td>
                    <img src="https://image.shutterstock.com/display_pic_with_logo/696496/291252509/stock-photo-istanbul-the-capital-of-turkey-eastern-tourist-city-291252509.jpg"></td>
                <td>
                    <img src="https://image.shutterstock.com/display_pic_with_logo/696496/291252509/stock-photo-istanbul-the-capital-of-turkey-eastern-tourist-city-291252509.jpg"></td>
                <td>
                    <img src="https://image.shutterstock.com/display_pic_with_logo/696496/291252509/stock-photo-istanbul-the-capital-of-turkey-eastern-tourist-city-291252509.jpg"></td>
            </div>

            <div class="jumbotron row" id="dvImageSmall">
                <td>
                    <img src="https://thumb7.shutterstock.com/thumb_small/696496/291252509/stock-photo-istanbul-the-capital-of-turkey-eastern-tourist-city-291252509.jpg"></td>
                <td>
                    <img src="https://thumb7.shutterstock.com/thumb_small/696496/291252509/stock-photo-istanbul-the-capital-of-turkey-eastern-tourist-city-291252509.jpg"></td>
                <td>
                    <img src="https://thumb7.shutterstock.com/thumb_small/696496/291252509/stock-photo-istanbul-the-capital-of-turkey-eastern-tourist-city-291252509.jpg"></td>
                <td>
                    <img src="https://thumb7.shutterstock.com/thumb_small/696496/291252509/stock-photo-istanbul-the-capital-of-turkey-eastern-tourist-city-291252509.jpg"></td>
            </div>
            <div class="jumbotron row" id="dvImageLarge">
                <td>
                    <img src="https://thumb7.shutterstock.com/thumb_large/696496/291252509/stock-photo-istanbul-the-capital-of-turkey-eastern-tourist-city-291252509.jpg"></td>
                <td>
                    <img src="https://thumb7.shutterstock.com/thumb_large/696496/291252509/stock-photo-istanbul-the-capital-of-turkey-eastern-tourist-city-291252509.jpg"></td>
                <td>
                    <img src="https://thumb7.shutterstock.com/thumb_large/696496/291252509/stock-photo-istanbul-the-capital-of-turkey-eastern-tourist-city-291252509.jpg"></td>
                <td>
                    <img src="https://thumb7.shutterstock.com/thumb_large/696496/291252509/stock-photo-istanbul-the-capital-of-turkey-eastern-tourist-city-291252509.jpg"></td>
            </div>
            <div class="col-xs-12 col-md-8">
                <div class="row">
                    <div class="col-xs-4 col-md-4">
                        <img src="https://image.shutterstock.com/display_pic_with_logo/696496/291252509/stock-photo-istanbul-the-capital-of-turkey-eastern-tourist-city-291252509.jpg" class="img-responsive" alt="Logo">
                    </div>
                    <div class="col-xs-4 col-md-4">
                        <img src="https://image.shutterstock.com/display_pic_with_logo/696496/291252509/stock-photo-istanbul-the-capital-of-turkey-eastern-tourist-city-291252509.jpg" class="img-responsive" alt="Logo">
                    </div>
                    <div class="col-xs-4 col-md-4">
                        <img src="https://image.shutterstock.com/display_pic_with_logo/696496/291252509/stock-photo-istanbul-the-capital-of-turkey-eastern-tourist-city-291252509.jpg" class="img-responsive" alt="Logo">
                    </div>

                </div>
            </div>
        </div>
    </form>
</body>
</html>
