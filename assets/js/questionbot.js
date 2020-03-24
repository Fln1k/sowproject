$(document).ready(function() {
    // Initial call
    resizeWindow();

    $(window).resize(function() {
        resizeWindow()
    });

    function calculatepercent(position) {
        var a = position;

        $('div.main-top').height(position);
        $('div.main-bottom').height($("#mainContent").height() - (position + 20));
    };

    $("#draggableH").draggable({
        axis: "y",
        start: function(a) {
            calculatepercent(a.target.offsetTop);
        },
        drag: function(b) {
            calculatepercent(b.target.offsetTop);
        },
        stop: function(c) {
            calculatepercent(c.target.offsetTop);
        }
    });

    function resizeWindow() {
        $("#mainContent").height($("body").height() - $(".header").height());

        var height = (($("body").height() - $(".header").height()) / 2) - 10;

        $("#draggableH").css({
            'top': height
        });

        $(".main-top").css({
            'height': height
        });

        $(".main-bottom").css({
            'height': height
        });
    };
});

function answer_input(ele) {
    if (event.key === 'Enter') {
        var message = document.createElement("div")
        message.setAttribute('class', 'usermessagediv slide-left');
        message.setAttribute('style', 'margin-top:10px;');
        message.textContent = ele.value
        document.getElementById("chatcontent").appendChild(message)
        var message = document.createElement("div")
        message.setAttribute('class', 'botmessagediv slide-right');
        message.setAttribute('style', 'margin-top:10px;');
        message.textContent = "Brilliant!!!"
        window.setTimeout(function() {

            // Move to a new location or you can do something else
            document.getElementById("chatcontent").appendChild(message)

        }, 1000);
    }
}

function answer_button(ele) {
    var message = document.createElement("div")
    message.setAttribute('class', 'usermessagediv slide-left');
    message.setAttribute('style', 'margin-top:10px;');
    message.textContent = ele.value
    document.getElementById("chatcontent").appendChild(message)
    var message = document.createElement("div")
    message.setAttribute('class', 'botmessagediv slide-right');
    message.setAttribute('style', 'margin-top:10px;');
    message.textContent = "Brilliant!!!"
    window.setTimeout(function() {

        // Move to a new location or you can do something else
        document.getElementById("chatcontent").appendChild(message)

    }, 1000);

}