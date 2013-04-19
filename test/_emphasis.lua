return {
  {markdown = 'with ***strong and em***', html = '<p>with <strong><em>strong and em</em></strong></p>'},
  {markdown = 'with strong ***and*** em', html = '<p>with strong <strong><em>and</em></strong> em</p>'},
  {markdown = 'with ___strong and em___', html = '<p>with <strong><em>strong and em</em></strong></p>'},
  {markdown = 'with strong ___and___ em', html = '<p>with strong <strong><em>and</em></strong> em</p>'},
  {markdown = 'not* emphasized*', html = '<p>not* emphasized*</p>'},
  {markdown = 'single l*e*tt__e__r', html = '<p>single l<em>e</em>tt<strong>e</strong>r</p>'},
  {markdown = 'mixed __x __weird', html = '<p>mixed <em>_x _</em>weird</p>'}
}