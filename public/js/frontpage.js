$(function() {

$('<div class="row">')
    .insertAfter($('main h2'))
    .append(
        $('main > p')
            .addClass('col-md-4')
    );

});
