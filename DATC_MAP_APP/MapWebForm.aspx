<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MapWebForm.aspx.cs" Inherits="DATC_MAP_APP.MapWebForm" %>

<style>
    #map {
        height: 400px;
        width: 700px;
    }
</style>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
 
</head>


<body>
    <div class="row">
    <div id="map"></div>
    <script>
        var map;
        var markers = [];
        var contentString = 'placeholder';
        var infoWindow;


        var name;
        var severity;
        var lat;
        var long;

        var pt;


        function initMap() {
            map = new google.maps.Map(document.getElementById('map'), {
                center: { lat: 45.74782405166663, lng: 21.208970709276187 },//45.74782405166663, 21.208970709276187
                zoom: 8
            });
            infoWindow = new google.maps.InfoWindow({ content: contentString });
            map.addListener("click", (event) => { addMarker(event.latLng); });



        }

        function addInfoWindow(marker, message) {

            var contentOfWindow = '';

            var infoWindow = new google.maps.InfoWindow({
                //document.getElementById('form') // message
                content: message
            });

            google.maps.event.addListener(marker, 'mouseover', function () {
                infoWindow.open(map, marker);
            });
            google.maps.event.addListener(marker, 'click', function () {

                //var smth = document.getElementById('form');
                openForm();
                infoWindow.setContent("User: " + name + '\n' + "Rating: " + severity + '\n' + "Coord: " + marker.getPosition());

                document.getElementById("markerLat").value = marker.getPosition().lat();
                document.getElementById("markerLng").value = marker.getPosition().lng();


                document.forms["mapSubForm"]["lat"].value = marker.getPosition().lat();

                document.forms["mapSubForm"]["lng"].value = marker.getPosition().lng();


                passData();
               // insert();
                // contentString = document.getElementById('form');

                // infoWindow.setContent(contentString);
                //      document.forms["mapSubForm"]["name"].value = lat.toString() +  " " +
                //  document.forms["mapSubForm"]["address"].value.toString();




            });
            google.maps.event.addListener(marker, 'mouseout', function () {
                infoWindow.close();
            });
        }



        function addMarker(position) {//make a new marker
            const marker = new google.maps.Marker({ position, map, });

            markers.push(marker);

            //lat = marker.lat.toString();
            //lng = marker.lng.toString();
      
            //  contentString = marker.getPosition().toString(); //add content

            contentString = marker.getPosition().toString();

            addInfoWindow(marker, contentString);//add to the current marker functions and data



            /* marker['infowindow'] = new google.maps.InfoWindow({content:contentString
 
             marker.addListener('mouseover', function(){this['infowindow'].open(map,this);});
 
             marker.addListener('mouseout', function(){this['infowindow'].close(map,this);});
 
             infoWindow = new google.maps.InfoWindow({ content: contentString });
 
             infoWindow.setContent(contentString);
 
             marker.addListener('mouseover', function() {  infoWindow.open(map,marker);} );
 
             marker.addListener('mouseout', function() {infoWindow.close();});*/


        }


        function getDistance(source, destination) {
            return google.maps.geometry.spherical.computeDistanceBetween(
                new google.maps.LatLng(source.lat, source.lng),
                new google.maps.LatLng(destination.lat, destination.lng)
            );
        }

        function openForm() {
            document.getElementById("form").style.display = "block";
        }
        function closeForm() {
            document.getElementById("form").style.display = "none";
        }
        function updateValues() {
            name = document.forms["mapSubForm"]["name"].value.toString();
            severity = document.forms["mapSubForm"]["severity"].value.toString();
           // document.forms["mapSubForm"]["lat"].value = markers[markers.length - 1].lat.toString();
           // document.forms["mapSubForm"]["lng"].value = markers[markers.length - 1].lng.toString();
           
        }
        function insert() {
            SqlDataSource1.Insert();
            GridView.DataBind();
        }
        function formShow() {
            $('#map').click(function () {
                $('#form').addClass('.formShow');
            });
        };


    </script>
        <input type="hidden" name="markerLat" id="markerLat">
        <input type="hidden" name="markerLng" id="markerLng">

    @*End of Map Section*@

    <script async
            src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDbHI68VOT3NH7bCKvxjtysi2U0fngweSU&callback=initMap">
    </script>
</div>

   
<div id="form">
    <form onSubmit="check();return false;" enctype="multipart/form-data" id="mapSubForm" runat="server">
        <h2>Add New Alert</h2>
        <p>
            <label for="name">Enter a user name:</label>
            <%--<input type="text" name="name" id="name" value="">--%>
            <asp:TextBox   runat="server" id="name" name="name"></asp:TextBox>
        </p>

        <p>
            <label for="severity">Enter a severity rating:</label>
            <%--<input type="text" name="severity" id="severity" value="">--%>
              <asp:TextBox   runat="server" id="severity" name="severity"></asp:TextBox>
        </p>

        <p>
             <label for="lat">Latitude:</label>
              <asp:TextBox   runat="server" id="lat" name="lat"></asp:TextBox>
        </p>
         <label for="lng">Longitude:</label>
              <asp:TextBox   runat="server" id="lng" name="lng"></asp:TextBox>
       
        <p>

        </p>
       <%-- <input type="text" name="lat" id="lat">
        <input type="text" name="lng" id="lng">--%>

        <input type="button" name="submitMapBtn" value="All OK" onclick="updateValues(); closeForm();">

        <asp:Button ID="Button1" runat="server" Text="Add last alert" OnClick="Button1_Click" />

        <asp:GridView runat="server" DataSourceID="SqlDataSource1" ID="ctl03" AutoGenerateColumns="False" DataKeyNames="id">
            <Columns>
                <asp:BoundField DataField="id" HeaderText="id" ReadOnly="True" InsertVisible="False" SortExpression="id"></asp:BoundField>
                <asp:BoundField DataField="lat" HeaderText="lat" SortExpression="lat"></asp:BoundField>
                <asp:BoundField DataField="lng" HeaderText="lng" SortExpression="lng"></asp:BoundField>
                <asp:BoundField DataField="name" HeaderText="name" SortExpression="name"></asp:BoundField>
                <asp:BoundField DataField="severity" HeaderText="severity" SortExpression="severity"></asp:BoundField>
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource runat="server" ID="SqlDataSource1"
            ConflictDetection="CompareAllValues" 
            ConnectionString="<%$ ConnectionStrings:GoogleMapDBConnectionString %>" 
            DeleteCommand="DELETE FROM [Google map info] WHERE [id] = @original_id AND (([lat] = @original_lat) OR ([lat] IS NULL AND @original_lat IS NULL)) AND (([lng] = @original_lng) OR ([lng] IS NULL AND @original_lng IS NULL)) AND (([name] = @original_name) OR ([name] IS NULL AND @original_name IS NULL)) AND (([severity] = @original_severity) OR ([severity] IS NULL AND @original_severity IS NULL))"
            InsertCommand="INSERT INTO [Google map info] ([lat], [lng], [name], [severity]) VALUES (@lat, @lng, @name, @severity)" 
            OldValuesParameterFormatString="original_{0}" 
            SelectCommand="SELECT * FROM [Google map info]" 
            UpdateCommand="UPDATE [Google map info] SET [lat] = @lat, [lng] = @lng, [name] = @name, [severity] = @severity WHERE [id] = @original_id AND (([lat] = @original_lat) OR ([lat] IS NULL AND @original_lat IS NULL)) AND (([lng] = @original_lng) OR ([lng] IS NULL AND @original_lng IS NULL)) AND (([name] = @original_name) OR ([name] IS NULL AND @original_name IS NULL)) AND (([severity] = @original_severity) OR ([severity] IS NULL AND @original_severity IS NULL))">
            <DeleteParameters>
                <asp:Parameter Name="original_id" Type="Int32"></asp:Parameter>
                <asp:Parameter Name="original_lat" Type="String"></asp:Parameter>
                <asp:Parameter Name="original_lng" Type="String"></asp:Parameter>
                <asp:Parameter Name="original_name" Type="String"></asp:Parameter>
                <asp:Parameter Name="original_severity" Type="String"></asp:Parameter>
            </DeleteParameters>
            <InsertParameters>
                <asp:ControlParameter ControlID="lat" Name="lat" Type="String"></asp:ControlParameter>
                <asp:ControlParameter ControlID="lng" Name="lng" Type="String"></asp:ControlParameter>
                <asp:ControlParameter ControlID="name" Name="name" Type="String"></asp:ControlParameter>
                <asp:ControlParameter ControlID="severity" Name="severity" Type="String"></asp:ControlParameter>
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="lat" Type="String"></asp:Parameter>
                <asp:Parameter Name="lng" Type="String"></asp:Parameter>
                <asp:Parameter Name="name" Type="String"></asp:Parameter>
                <asp:Parameter Name="severity" Type="String"></asp:Parameter>
                <asp:Parameter Name="original_id" Type="Int32"></asp:Parameter>
                <asp:Parameter Name="original_lat" Type="String"></asp:Parameter>
                <asp:Parameter Name="original_lng" Type="String"></asp:Parameter>
                <asp:Parameter Name="original_name" Type="String"></asp:Parameter>
                <asp:Parameter Name="original_severity" Type="String"></asp:Parameter>
            </UpdateParameters>
        </asp:SqlDataSource>
    </form>
</div>
    <div>


    </div>
    <form id="form1">

        <script>
            
            function passData()
            {
                document.getElementById("lat1").setAttribute('value', lat.toString());
                document.getElementById("lng1").setAttribute('value', lng.toString());
                document.getElementById("name1").setAttribute('value',name.toString());
                document.getElementById("severity1").setAttribute('value',severity.toString());
               
              
                
            }

        </script>
       <%-- <div>
             <asp:TextBox  runat="server" id="lat1" name="latitude" value="$lat"></asp:TextBox>
             <asp:TextBox   runat="server" id="lng1" name="longitude"></asp:TextBox>
             <asp:TextBox   runat="server" id="name1" name="name"></asp:TextBox>
             <asp:TextBox   runat="server" id="severity1" name="severity"></asp:TextBox>
        </div>--%>

        
          
        
         
    </form>
</body>
</html>

<%--<div>
             <asp:TextBox    runat="server" id="lat" name="latitude"></asp:TextBox>
            <asp:TextBox   runat="server" id="lng" name="longitude"></asp:TextBox>
       <div align="center" id="map" style="width: 600px; height: 400px"></div>
    </div>--%>