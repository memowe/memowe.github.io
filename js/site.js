$(function() {

    // set title from config
    $('title').text(config.name + ' - ' + config.slogan);

    // add document structure
    $('body').append(
        $('<div id="header">'),
        $('<div id="content">')
    );

    // load content
    loadContent();
});

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
        $('#content').append($('<div class="section">').html(render(content)));
    });
}
