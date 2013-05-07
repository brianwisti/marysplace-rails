String.prototype.commafy = () ->
  with_commas = this.replace /(^|[^\w.])(\d{4,})/g, ($0, $1, $2) ->
    inter = $1 + $2.replace(/\d(?=(?:\d\d\d)+(?!\d))/g, "$&,")
    return inter
  return with_commas

String.prototype.digits = () ->
  return this.replace /,/, ''

Number.prototype.commafy = () ->
  return String(this).commafy()
