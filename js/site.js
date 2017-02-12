$(function() {

    // set title from config
    $('title').text(config.name + ' - ' + config.slogan);

    // add document structure
    $('body').append(
        $('<div id="header">'),
        $('<div id="content">')
    );

    // add fancy parallax effect
    addFancyParallaxMirko();

    // load content
    loadContent();
});

// adds a fancy rolling eye Mirko to the given container
function addFancyParallaxMirko() {

    // prepare layers
    var eyes = $('<img src="/images/mirko/eyes.png">')
        .addClass('parallax-layer')
        .css({width: 1209, height: 1613});
    var face = $('<img src="/images/mirko/face.png">')
        .addClass('parallax-layer')
        .css({width: 1233, height: 1623});

    // arrange
    var viewport = $('<div class="parallax-viewport">')
        .css({width: 1233, height: 1623})
        .append(eyes, face)

    // magic!
    viewport.children().parallax();

    // connect
    $('#header').append(viewport);
}

// loads content into the given container
function loadContent(container) {

    // prepare showdown (markdown renderer)
    var markdownRenderer = new showdown.Converter();
    var renderMarkdown   = function(md) {
        return markdownRenderer.makeHtml(md);
    };

    // load content
    $.get('./' + config.contentFile, function(content) {

        // split documents
        var documents = content.split("\n-----\n");

        // first document: header content
        var headerContent = documents.shift();
        $('#header').append(renderMarkdown(headerContent));

        // rest of the documents: content sections
        renderSections(renderMarkdown, documents);
    });
}

// render markdown documents as sections
function renderSections(render, documents) {
    documents.forEach(function(content) {

        // prepare
        var section = $('<div class="section">').html(render(content));

        // inject into dom
        section.appendTo($('#content'));
    });

    $('.section a img').parent().colorbox();
}
