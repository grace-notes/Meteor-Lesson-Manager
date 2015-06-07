if Meteor.isServer
  Meteor.startup ->
    return
    Lessons.remove({})
    unrtf = Meteor.wrapAsync Meteor.npmRequire('unrtf')

    Messages.find().forEach (m)->
      [code, title] = m.headers.subject.split(/[-:]/).map (s)-> String.prototype.trim.apply s
      if !title then [title, code] = [code, title]
      console.log title
      text = m.text
      attachments = []
      for a in m.attachments
        if a.contentType == 'application/rtf' && a.content?.length
          try
            result = unrtf(new Buffer(a.content).toString('ascii'))
            if result then html = result.html
          catch e
            console.log e
        if a.contentType == 'application/pdf'
          a.content = {data: a.content}
          attachments.push(a)
      Lessons.insert { code, title, text, html, attachments }
