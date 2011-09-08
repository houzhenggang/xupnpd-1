if cfg.daemon==true then core.detach() end

core.openlog(cfg.log_ident,cfg.log_facility)

if cfg.daemon==true then core.touchpid(cfg.pid_file) end

update_id=0

dofile('xupnpd_mime.lua')
dofile('xupnpd_m3u.lua')
dofile('xupnpd_ssdp.lua')
dofile('xupnpd_http.lua')

function reload_playlist()
    dofile('xupnpd_mime.lua')
    dofile('xupnpd_m3u.lua')
    update_id=update_id+1

    if cfg.debug>0 then print('reload playlist <'..update_id..'>') end
end

events["SIGUSR1"]=reload_playlist
events["reload"]=reload_playlist

print("start "..cfg.log_ident)

--services.cds.Browse({['ObjectID']='0/1', ['BrowseFlag']='BrowseDirectChildren', ['StartingIndex']='0', ['RequestedCount']='3'})
--services.cds.Browse({['ObjectID']='0/1/1', ['BrowseFlag']='BrowseMetadata', ['StartingIndex']='0', ['RequestedCount']='0'})
--services.cds.Search({['ContainerID']='0', ['StartingIndex']='0', ['RequestedCount']='3', ['SearchCriteria']='upnp:class derivedfrom \"object.item.videoItem\" and @refID exists false'})

core.mainloop()

print("stop "..cfg.log_ident)

if cfg.daemon==true then os.remove(cfg.pid_file) end
