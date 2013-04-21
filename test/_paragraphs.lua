return {
  {markdown = 'Some\nText', html = '<p>Some\nText</p>'},
  {markdown = 'Two\n\nParagraphs', html = '<p>Two</p>\n<p>Paragraphs</p>'},
  {markdown = 'Ignore consequent\n    \n \n\n\n  \n \nEmpty Lines', html = '<p>Ignore consequent</p>\n<p>Empty Lines</p>'},
  {markdown = 'Linebroken  \nParagraph', html = '<p>Linebroken  <br />\nParagraph</p>'},
  {markdown = 'No break before end  ', html = '<p>No break before end  </p>'}
}