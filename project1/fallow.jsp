<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%
    // 예시 팔로우 리스트 초기화
    List<String> followList = (List<String>) session.getAttribute("followList");
    if (followList == null) {
        followList = new ArrayList<>();
        session.setAttribute("followList", followList);
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SNS 메인 페이지</title>
    <style>
        body { font-family: Arial, sans-serif; background: linear-gradient(to right, #a8e6cf, #dcedc1); margin: 0; padding: 20px 10px; }
        .container { max-width: 800px; margin: auto; background-color: white; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); border-radius: 12px; overflow: hidden; padding: 20px; }
        .post-container { margin-bottom: 20px; padding: 10px; border: 1px solid #ccc; border-radius: 8px; }
        .post { border-bottom: 1px solid #e9ebee; padding: 10px 0; }
        .post:last-child { border-bottom: none; }
        .post-title, .comment-content { font-size: 16px; font-weight: bold; color: #4CAF50; }
        .post-content, .comment-text { margin: 10px 0; color: #333; }
        .btn { background: none; border: none; cursor: pointer; color: #5fa477; font-size: 14px; transition: color 0.3s; margin-right: 10px; }
        .btn:hover { color: #588971ac; }
        .hidden { display: none; }
        .follow-item { display: flex; justify-content: space-between; align-items: center; padding: 10px 0; border-bottom: 1px solid #e9ebee; }
        .follow-item:last-child { border-bottom: none; }
        .username { font-size: 16px; font-weight: bold; color: #4CAF50; }
        .unfollow-btn { background: none; border: none; cursor: pointer; color: #5fa477; font-size: 14px; transition: color 0.3s; }
        .unfollow-btn:hover { color: #588971ac; }
        #noFollowers { text-align: center; color: #4CAF50; font-size: 18px; margin-top: 20px; }
        .like-btn { color: #5fa477; font-size: 14px; margin-right: 10px; cursor: pointer; }
        .like-btn.active { color: #588971ac; }
    </style>
</head>
<body>
    <div class="container">
        <h2>사용자</h2>
        <div id="other-posts">
            <!-- 사용자1 -->
            <div class="post-container">
                <div class="post" id="post-1">
                    <div class="post-title">사용자1</div>
                    <div class="post-content">다른 사람의 내용 1</div>
                    <button class="btn comment-btn" onclick="showCommentBox(1)">댓글 쓰기</button>
                    <button class="btn follow-btn" onclick="toggleFollow(1, '사용자1')">팔로우</button>
                    <div id="comment-box-1" class="comment-box hidden">
                        <textarea id="comment-text-1" class="comment-text" rows="2" placeholder="댓글 입력"></textarea>
                        <button class="btn add-comment-btn" onclick="addComment(1)">댓글 업로드</button>
                    </div>
                    <div id="comments-1" class="comments">
                        <!-- 다른 사람 댓글 예시 -->
                        <div class="comment">
                            <div class="comment-content">다른 사람의 댓글 내용 1</div>
                            <button class="btn like-btn" onclick="toggleLike(1, 1)">좋아요</button>
                        </div>
                        <div class="comment">
                            <div class="comment-content">다른 사람의 댓글 내용 2</div>
                            <button class="btn like-btn" onclick="toggleLike(1, 2)">좋아요</button>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 사용자2 -->
            <div class="post-container">
                <div class="post" id="post-2">
                    <div class="post-title">사용자2</div>
                    <div class="post-content">다른 사람의 내용 2</div>
                    <button class="btn comment-btn" onclick="showCommentBox(2)">댓글 쓰기</button>
                    <button class="btn follow-btn" onclick="toggleFollow(2, '사용자2')">팔로우</button>
                    <div id="comment-box-2" class="comment-box hidden">
                        <textarea id="comment-text-2" class="comment-text" rows="2" placeholder="댓글 입력"></textarea>
                        <button class="btn add-comment-btn" onclick="addComment(2)">댓글 업로드</button>
                    </div>
                    <div id="comments-2" class="comments">
                        <!-- 다른 사람 댓글 예시 -->
                        <div class="comment">
                            <div class="comment-content">다른 사람의 댓글 내용 3</div>
                            <button class="btn like-btn" onclick="toggleLike(2, 1)">좋아요</button>
                        </div>
                        <div class="comment">
                            <div class="comment-content">다른 사람의 댓글 내용 4</div>
                            <button class="btn like-btn" onclick="toggleLike(2, 2)">좋아요</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // 초기 데이터
        let otherPosts = [
            { id: 1, title: "사용자1", content: "다른 사람의 내용 1", comments: [{ id: 1, content: "다른 사람의 댓글 내용 1", likes: 0 }, { id: 2, content: "다른 사람의 댓글 내용 2", likes: 0 }], isFollowed: false },
            { id: 2, title: "사용자2", content: "다른 사람의 내용 2", comments: [{ id: 1, content: "다른 사람의 댓글 내용 3", likes: 0 }, { id: 2, content: "다른 사람의 댓글 내용 4", likes: 0 }], isFollowed: false }
        ];

        // 팔로우한 사용자 목록 (예시 데이터)
        let followList = <%= followList %>;

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

            const newComment = { id: Date.now(), content: commentText, isMine: true };
            const post = otherPosts.find(post => post.id === postId);
            post.comments.push(newComment);

            textArea.value = '';
            renderComments(postId);
        }

        // 팔로우 토글 함수
        function toggleFollow(postId, username) {
            const post = otherPosts.find(post => post.id === postId);
            post.isFollowed = !post.isFollowed;

            if (post.isFollowed) {
                if (!followList.includes(username)) {
                    followList.push(username);
                }
            } else {
                followList = followList.filter(user => user !== username);
            }

            // 서버에 업데이트된 팔로우 리스트 전송
            const xhr = new XMLHttpRequest();
            xhr.open("POST", "updateFollowList.jsp", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.send("followList=" + JSON.stringify(followList));

            renderPosts();
        }

        // 댓글 삭제 함수
        function deleteComment(postId, commentId) {
            const post = otherPosts.find(post => post.id === postId);
            post.comments = post.comments.filter(comment => comment.id !== commentId);
            renderComments(postId);
        }

        // 댓글 좋아요 토글 함수
        function toggleLike(postId, commentId) {
            const post = otherPosts.find(post => post.id === postId);
            const comment = post.comments.find(comment => comment.id === commentId);
            comment.likes += 1;
            renderComments(postId);
        }

        // 댓글 렌더링 함수
        function renderComments(postId) {
            const post = otherPosts.find(post => post.id === postId);
            const commentsContainer = document.getElementById(`comments-${postId}`);
            commentsContainer.innerHTML = '';

            post.comments.forEach(comment => {
                const commentDiv = document.createElement('div');
                commentDiv.classList.add('comment');

                const commentContent = document.createElement('div');
                commentContent.classList.add('comment-content');
                commentContent.textContent = comment.content;

                const likeBtn = document.createElement('button');
                likeBtn.classList.add('btn', 'like-btn');
                likeBtn.textContent = `좋아요 (${comment.likes})`;
                likeBtn.onclick = () => toggleLike(postId, comment.id);

                commentDiv.appendChild(commentContent);
                commentDiv.appendChild(likeBtn);

                commentsContainer.appendChild(commentDiv);
            });
        }

        // 팔로우한 사용자 렌더링 함수
        function renderPosts() {
            otherPosts.forEach(post => {
                const followBtn = document.querySelector(`#post-${post.id} .follow-btn`);
                followBtn.textContent = post.isFollowed ? '팔로잉' : '팔로우';
            });
        }

        // 페이지 로드 시 초기 렌더링
        window.onload = function() {
            followList.forEach(user => {
                const post = otherPosts.find(post => post.title === user);
                if (post) {
                    post.isFollowed = true;
                }
            });
            renderPosts();
        };
    </script>
</body>
</html>
