# auto-generated
.DELETE_ON_ERROR:
comma := ,
src := __src__/
history = @rlock --timeout 5 history.lock -- ruby --disable-gems -e 'IO.write "history.txt", ARGV[0]+"\n", mode: "a"' $1 2>/dev/null
ffmpeg := $(src)/sh-progress-reporter/example-ffmpeg.sh
%.mp3: %.m4v
	$(ffmpeg) -i $< -vn $@
	rm $<
%.mp3: %.m4a
	$(ffmpeg) -i $< -vn $@
	rm $<
%.m4a: %.mp3
	$(ffmpeg) -i $< -c:a aac -vn $@
	rm $<
%.mp3: %.ogg
	$(ffmpeg) -i $< -vn $@
	rm $<
%.ogg: %.mp3
	$(ffmpeg) -i $< -vn $@
	rm $<
%.ultrafast.mp3: %.mp3
	$(ffmpeg) -i $< -vn -c:a libmp3lame -qscale:a 8 $@
	rm $<
.PHONY: all
all:

media/Photography/off_to_beijing_interview_08-04-08.123456.mp3:
	@mkdir -p $(dir $@)
	curl --connect-timeout 15 -fL -C - -o $@  'http://cachefly.oreilly.com/digitalmedia/2008/08/off_to_beijing_interview_08-04-08.mp3'
	$(call history,'http://cachefly.oreilly.com/digitalmedia/2008/08/off_to_beijing_interview_08-04-08.mp3')
all:  media/Photography/off_to_beijing_interview_08-04-08.123456.mp3

