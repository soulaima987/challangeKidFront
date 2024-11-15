<?php

namespace App\Controller;

use App\Entity\Category;
use App\Entity\Lesson;
use App\Entity\Post;
use App\Entity\User;
use App\Form\LessonType;
use App\Repository\LessonRepository;
use App\Repository\PostRepository;
use App\Service\LessonService;
use Doctrine\ORM\EntityManagerInterface;
use Doctrine\ORM\Mapping\Entity;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use OpenApi\Attributes as OA;
use Symfony\Bundle\SecurityBundle\Security;
use Symfony\Component\HttpFoundation\File\UploadedFile;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

#[Route('/api/lesson')]
#[OA\Tag(name: 'Lesson')]
class LessonController extends AbstractController
{
    private $lessonService;
    private $security;
    private $entityManager;
    public function __construct(LessonService $lessonService, Security $security, EntityManagerInterface $entityManager)
    {
        $this->lessonService = $lessonService;
        $this->security = $security;
        $this->entityManager = $entityManager;
    }

    #[Route('/', name: 'lesson_index', methods: ['GET'])]
    public function index(LessonRepository $lessonRepository): JsonResponse
    {
        $listJson = [];
        $list = $lessonRepository->findAll();
        foreach ($list as $key => $value) {
            $listJson[$key] = $this->lessonService->lessonToJson($value);
        }
        return new JsonResponse($listJson);
    }

    #[Route('/coach', name: 'lesson_coach', methods: ['GET'])]
    public function getCoachLessons(LessonRepository $lessonRepository): JsonResponse
    {
        $user = $this->security->getUser();

        $listJson = [];
        $list = $lessonRepository->findBy(["coach" => $user]);
        foreach ($list as $key => $value) {
            $listJson[$key] = $this->lessonService->lessonToJson($value);
        }
        return new JsonResponse($listJson);
    }

    #[Route('/new', name: 'lesson_new', methods: ['POST'])]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            type: Object::class,
            example: [
                "title" => "1st Lesson",
                "description" => "This is the description of the first lesson",
                "LessonNumber" => 1,
            ]
        )
    )]
    public function new(Request $request, EntityManagerInterface $entityManager): JsonResponse
    {
        $data = json_decode($request->getContent(), true);

        $coach = $this->security->getUser();

        $lesson = new Lesson();
        $lesson->setCoach($coach);
        $form = $this->createForm(LessonType::class, $lesson);
        $form->submit($data);

        if ($form->isSubmitted()) {
            $entityManager->persist($lesson);
            $entityManager->flush();
        }

        return new JsonResponse(true);
    }

    #[Route('/{id}/edit', name: 'lesson_edit', methods: ['PUT'])]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            type: Object::class,
            example: [
                "title" => "1st Lesson Changed",
                "description" => "This is the changed description of the first lesson",
                "LessonNumber" => 1,
            ]
        )
    )]
    public function edit($id, Request $request, LessonRepository $lessonRepository, EntityManagerInterface $entityManager): Response
    {
        $lesson = $lessonRepository->find($id);

        $data = json_decode($request->getContent(), true);
        $form = $this->createForm(LessonType::class, $lesson);
        $form->submit($data);

        if ($form->isSubmitted()) {
            $entityManager->persist($lesson);
            $entityManager->flush();

            return new JsonResponse(['status' => 'Lesson updated successfully']);
        }

        return new JsonResponse(['error' => 'An error has occured']);
    }

    #[Route('/delete/{id}', name: 'lesson_delete', methods: ['DELETE'])]
    public function delete($id, LessonRepository $lessonRepository, EntityManagerInterface $entityManager): Response
    {
        $lesson = $lessonRepository->find($id);
        if (!$lesson) {
            throw new NotFoundHttpException('Lesson not found');
        }

        $entityManager->remove($lesson);
        $entityManager->flush();

        return new JsonResponse(['status' => 'The Lesson has been deleted']);
    }

    #[Route('/{id}/assignPost', name: 'lesson_assign_post', methods: ['PUT'])]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            type: Object::class,
            example: [
                "postId" => 4,
            ]
        )
    )]
    public function addPost($id, Request $request, PostRepository $postRepository, LessonRepository $lessonRepository): JsonResponse
    {
        $lesson = $lessonRepository->find($id);
        $data = json_decode($request->getContent(), true);
        $post = $postRepository->find($data["postId"]);
        $lesson->setPost($post);
        $this->entityManager->persist($lesson);
        $this->entityManager->flush();
        return new JsonResponse(true);
    }

    #[Route('/postswithoutlessons', name: 'my_posts_without_lesson', methods: ['GET'])]
    public function myPostsWithoutLesson(PostRepository $postRepository): JsonResponse
    {

        $user = $this->security->getUser();

        $posts = $postRepository->findPostsByUserWithNullLesson($user);

        $postData = [];
        foreach ($posts as $post) {
            $postData[] = [
                'id' => $post->getId(),
                'title' => $post->getTitle(),
            ];
        }

        return new JsonResponse($postData);
    }


    #[Route('/{lessonId}/createPost', name: 'lesson_create_post', methods: ['POST'])]
    #[OA\Post(
        summary: 'Add a new post',
        description: 'Creates a new post for the specified user.',
        requestBody: new OA\RequestBody(
            description: 'Request body for adding a new post',
            required: true,
            content: [
                'multipart/form-data' => new OA\MediaType(
                    mediaType: 'multipart/form-data',
                    schema: new OA\Schema(
                        type: 'object',
                        properties: [
                            new OA\Property(
                                property: 'title',
                                type: 'string',
                                example: 'hadil'
                            ),
                            new OA\Property(
                                property: 'content',
                                type: 'string',
                                example: 'tahki yasser'
                            ),
                            new OA\Property(
                                property: 'mediaFileName',
                                type: 'string',
                                format: 'binary',
                                description: 'File to upload'
                            ),
                            new OA\Property(
                                property: 'categories',
                                type: 'array',
                                items: new OA\Items(
                                    type: 'string',
                                    example: 'Category1'
                                ),
                                description: 'List of category titles'
                            )
                        ],
                        required: ['title', 'content']
                    )
                )
            ]
        ),
    )]
    public function createPostForLesson(Request $request, $lessonId, LessonRepository $lessonRepository): JsonResponse
    {
        $user = $this->security->getUser();
        $lesson = $lessonRepository->find($lessonId);

        $post = new Post();
        $post->setUser($user);
        $title = $request->request->get('title');
        $content = $request->request->get('content');
        $mediaFile = $request->files->get('mediaFileName');
        $categoryTitlesJson  = $request->request->get('categories');
        $categoryTitles = json_decode($categoryTitlesJson, true);

        if (!$title || !$content) {
            return new JsonResponse(['success' => false, 'message' => 'Title and content are required.'], 400);
        }

        $post->setTitle($title);
        $post->setContent($content);
        $post->setAddedDate(new \DateTime());

        if ($mediaFile instanceof UploadedFile) {

            $fileName = uniqid() . '.' . $mediaFile->guessExtension();

            $uploadsDirectory = $this->getParameter('kernel.project_dir') . '/public/uploads/images';

            $mediaFile->move($uploadsDirectory, $fileName);

            $post->setMediaFileName($fileName);
        } else {

            return new JsonResponse(['message' => 'File upload failed or not recognized.']);
        }

        if (is_array($categoryTitles)) {

            foreach ($categoryTitles as $categoryTitle) {
                $category = $this->entityManager->getRepository(Category::class)->findOneBy(['title' => $categoryTitle]);
                if ($category) {
                    $post->addCategory($category);
                }
            }
        } else {
            return new JsonResponse("failed to load categories");
        }

        $lesson->addPost($post);
        $this->entityManager->persist($lesson);
        $this->entityManager->persist($post);
        $this->entityManager->flush();

        return new JsonResponse(['success' => true, 'message' => 'Post created successfully.']);
    }
}
