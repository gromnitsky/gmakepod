# auto-generated
src := __src__/
e.curl = curl --connect-timeout 15 -fL -C - $1 -o $@ 
ffmpeg.mp3 = $(src)/sh-progress-reporter/example-ffmpeg-mp3.sh $<
%.mp3: %.m4v
	$(ffmpeg.mp3)
	rm $<
%.mp3: %.m4a
	$(ffmpeg.mp3)
	rm $<
%.mp3: %.ogg
	$(ffmpeg.mp3)
	rm $<
.PHONY: all
all:     media/Photography/off_to_beijing_interview_08-04-08.123456.mp3
media/Photography/off_to_beijing_interview_08-04-08.123456.mp3:
	@mkdir -p $(dir $@)
	$(call e.curl,'http://cachefly.oreilly.com/digitalmedia/2008/08/off_to_beijing_interview_08-04-08.mp3')
	@ruby $(src)/history.rb add 'http://cachefly.oreilly.com/digitalmedia/2008/08/off_to_beijing_interview_08-04-08.mp3'
