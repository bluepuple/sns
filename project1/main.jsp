<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SNS 애플리케이션</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to right, #a8e6cf, #dcedc1);
            margin: 0;
            padding: 20px 10px;
        }
        .container {
            max-width: 800px;
            margin: auto;
            background-color: white;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 12px;
            overflow: hidden;
            padding: 20px;
        }
        .post-container {
            margin-bottom: 20px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 8px;
        }
        .post {
            border-bottom: 1px solid #e9ebee;
            padding: 10px 0;
        }
        .post:last-child {
            border-bottom: none;
        }
        .post-title, .comment-content {
            font-size: 16px;
            font-weight: bold;
            color: #4CAF50;
        }
        .post-content, .comment-text {
            margin: 10px 0;
            color: #333;
        }
        .btn {
            background: none;
            border: none;
            cursor: pointer;
            color: #5fa477;
            font-size: 14px;
            transition: color 0.3s;
            margin-right: 10px;
        }
        .btn:hover {
            color: #588971ac;
        }
        .hidden {
            display: none;
        }
        form {
            display: flex;
            flex-direction: column;
            margin-bottom: 20px;
        }
        input[type="text"], textarea, input[type="file"] {
            margin-bottom: 15px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            outline: none;
            width: 100%;
            box-sizing: border-box;
            transition: border-color 0.3s;
        }
        input[type="text"]:focus, textarea:focus, input[type="file"]:focus {
            border-color: #a8e6cf;
        }
        button {
            padding: 10px;
            background-color: #a8e6cf;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
            width: fit-content;
        }
        button:hover {
            background-color: #dcedc1;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>사용자</h2>

        <!-- 포스트 작성 및 수정 폼 -->
        <div id="post-form-container">
            <h2 id="form-title">글 작성</h2>
            <form id="post-form">
                <input type="text" id="post-title" placeholder="제목" required>
                <textarea id="post-content" rows="5" placeholder="내용" required></textarea>
                <input type="file" id="post-file" accept="image/*, video/*">
                <button type="submit">저장</button>
                <button type="button" id="delete-btn">삭제</button>
            </form>
        </div>

        <!-- 메인 페이지의 포스트들을 표시하는 컨테이너 -->
        <div id="other-posts">
            <!-- 포스트 1 -->
            <div class="post-container">
                <div class="post" id="post-1">
                    <div class="post-title">사용자1</div>
                    <div class="post-content">다른 사람의 내용 1</div>
                    <button class="btn like-btn" onclick="toggleLike(1)">좋아요</button>
                    <button class="btn comment-btn" onclick="showCommentBox(1)">댓글 쓰기</button>
                    <button class="btn follow-btn" onclick="toggleFollow(1)">팔로우</button>
                    <div id="comment-box-1" class="comment-box hidden">
                        <textarea id="comment-text-1" class="comment-text" rows="2" placeholder="댓글 입력"></textarea>
                        <button class="btn add-comment-btn" onclick="addComment(1)">댓글 업로드</button>
                    </div>
                    <div id="comments-1" class="comments"></div>
                </div>
            </div>
            
            <!-- 포스트 2 -->
            <div class="post-container">
                <div class="post" id="post-2">
                    <div class="post-title">사용자2</div>
                    <div class="post-content">다른 사람의 내용 2</div>
                    <button class="btn like-btn" onclick="toggleLike(2)">좋아요</button>
                    <button class="btn comment-btn" onclick="showCommentBox(2)">댓글 쓰기</button>
                    <button class="btn follow-btn" onclick="toggleFollow(2)">팔로우</button>
                    <div id="comment-box-2" class="comment-box hidden">
                        <textarea id="comment-text-2" class="comment-text" rows="2" placeholder="댓글 입력"></textarea>
                        <button class="btn add-comment-btn" onclick="addComment(2)">댓글 업로드</button>
                    </div>
                    <div id="comments-2" class="comments"></div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // 초기 데이터
        let otherPosts = [
            { id: 1, title: "사용자1", content: "다른 사람의 내용 1", likes: 0, comments: [], isLiked: false, isFollowed: false },
            { id: 2, title: "사용자2", content: "다른 사람의 내용 2", likes: 0, comments: [], isLiked: false, isFollowed: false }
        ];

        // 좋아요 토글 함수
        function toggleLike(postId) {
            const post = otherPosts.find(post => post.id === postId);
            post.isLiked = !post.isLiked;
            post.isLiked ? post.likes++ : post.likes--;
            renderPosts();
        }

        // 댓글 작성 토글 함수
        function showCommentBox(postId) {
            const commentBox = document.getElementById(`comment-box-${postId}`);
            commentBox.classList.toggle('hidden');
        }

        // 댓글 추가 함수
        function addComment(postId) {
            const textArea = document.getElementById(`comment-text-${postId}`);
            const commentText = textArea.value.trim();
            if (commentText === '') return;

            const newComment = { id: Date.now(), content: commentText, likes: 0, isLiked: false };
            const post = otherPosts.find(post => post.id === postId);
            post.comments.push(newComment);

            textArea.value = '';
            renderComments(postId);
        }

        // 팔로우 토글 함수
        function toggleFollow(postId) {
            const post = otherPosts.find(post => post.id === postId);
            post.isFollowed = !post.isFollowed;
            renderPosts();
        }

        // 댓글 좋아요 토글 함수
        function toggleCommentLike(postId, commentId) {
            const post = otherPosts.find(post => post.id === postId);
            const comment = post.comments.find(comment => comment.id === commentId);
            comment.isLiked = !comment.isLiked;
            comment.isLiked ? comment.likes++ : comment.likes--;
            renderComments(postId);
        }

        // 댓글 렌더링 함수
        function renderComments(postId) {
            const post = otherPosts.find(post => post.id === postId);
            const commentsContainer = document.getElementById(`comments-${postId}`);
            commentsContainer.innerHTML = '';

            post.comments.forEach(comment => {
                const commentDiv = document.createElement('div');
                commentDiv.className = 'comment';
                commentDiv.innerHTML = `
                    <div class="comment-content">${comment.content}</div>
                    <button class="btn like-btn" onclick="toggleCommentLike(${postId}, ${comment.id})">${comment.isLiked ? '좋아요 취소' : '좋아요'}</button>
                `;
                commentsContainer.appendChild(commentDiv);
            });
        }

        // 포스트 렌더링 함수
        function renderPosts() {
            const otherPostsContainer = document.getElementById('other-posts');
            otherPostsContainer.innerHTML = '';

            otherPosts.forEach(post => {
                const postContainer = document.createElement('div');
                postContainer.className = 'post-container';
                postContainer.innerHTML = `
                    <div class="post">
                        <div class="post-title">${post.title}</div>
                        <div class="post-content">${post.content}</div>
                        <button class="btn like-btn" onclick="toggleLike(${post.id})">${post.isLiked ? '좋아요 취소' : '좋아요'}</button>
                        <button class="btn comment-btn" onclick="showCommentBox(${post.id})">댓글 쓰기</button>
                        <button class="btn follow-btn" onclick="toggleFollow(${post.id})">${post.isFollowed ? '언팔로우' : '팔로우'}</button>
                        <div id="comment-box-${post.id}" class="comment-box hidden">
                            <textarea id="comment-text-${post.id}" class="comment-text" rows="2" placeholder="댓글 입력"></textarea>
                            <button class="btn add-comment-btn" onclick="addComment(${post.id})">댓글 업로드</button>
                        </div>
                        <div id="comments-${post.id}" class="comments"></div>
                    </div>
                `;
                otherPostsContainer.appendChild(postContainer);
                renderComments(post.id);
            });
        }

        // 포스트 제출 및 삭제 기능
        document.getElementById('post-form').addEventListener('submit', function(event) {
            event.preventDefault();
            const title = document.getElementById('post-title').value.trim();
            const content = document.getElementById('post-content').value.trim();
            const file = document.getElementById('post-file').files[0];

            if (title === '' || content === '') return;

            const newPost = {
                id: Date.now(),
                title: title,
                content: content,
                likes: 0,
                comments: [],
                isLiked: false,
                isFollowed: false
            };

            otherPosts.push(newPost);
            renderPosts();

            // 추가적인 처리 (예: 서버로 데이터 전송)
            console.log('새 포스트:', newPost);

            // 폼 초기화
            document.getElementById('post-title').value = '';
            document.getElementById('post-content').value = '';
            document.getElementById('post-file').value = '';
            document.getElementById('form-title').textContent = '글 작성'; // 폼 제목 리셋
        });

        // 삭제 버튼 기능
        document.getElementById('delete-btn').addEventListener('click', function() {
            // 삭제 로직 추가 (필요 시 구현)
            alert('글이 삭제되었습니다.');
        });

        // 페이지 로드 시 포스트 렌더링
        window.onload = function() {
            renderPosts();
        };
    </script>
</body>
</html>
